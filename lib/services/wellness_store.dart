import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wellness.dart';

abstract class WellnessStore {
  WellnessData get initial;
  Future<void> save(WellnessData data);
}

/// Small, versioned daily records only. Raw sensor streams are not persisted.
/// The encryption key lives in platform secure storage, separately from the
/// authenticated encrypted snapshot. Failed decryption never resets user data.
class EncryptedWellnessStore implements WellnessStore {
  static const snapshotKey = 'wellness_encrypted_v1';
  static const _keyName = 'wellness_key_v1';
  final SharedPreferences prefs;
  final SecretKey key;
  final AesGcm cipher;
  @override
  final WellnessData initial;
  EncryptedWellnessStore._(this.prefs, this.key, this.cipher, this.initial);

  static Future<EncryptedWellnessStore> open(
    SharedPreferences prefs, {
    FlutterSecureStorage secure = const FlutterSecureStorage(),
  }) async {
    final cipher = AesGcm.with256bits();
    final saved = prefs.getString(snapshotKey);
    var encodedKey = await secure.read(key: _keyName);
    if (encodedKey == null) {
      if (saved != null) {
        throw StateError('Wellness encryption key unavailable');
      }
      final newKey = await cipher.newSecretKey();
      encodedKey = base64Encode(await newKey.extractBytes());
      await secure.write(key: _keyName, value: encodedKey);
    }
    final key = SecretKey(base64Decode(encodedKey));
    var initial = const WellnessData();
    if (saved != null) {
      final bytes = await cipher.decrypt(
        SecretBox.fromConcatenation(
          base64Decode(saved),
          nonceLength: 12,
          macLength: 16,
        ),
        secretKey: key,
      );
      initial = WellnessData.fromJson(
        jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>,
      );
    }
    return EncryptedWellnessStore._(prefs, key, cipher, initial);
  }

  @override
  Future<void> save(WellnessData data) async {
    final box = await cipher.encrypt(
      utf8.encode(jsonEncode(data.toJson())),
      secretKey: key,
    );
    if (!await prefs.setString(
      snapshotKey,
      base64Encode(box.concatenation()),
    )) {
      throw StateError('Unable to save wellness data');
    }
  }
}

/// Explicit injection for tests; never used as a production persistence fallback.
class MemoryWellnessStore implements WellnessStore {
  @override
  WellnessData initial;
  MemoryWellnessStore([this.initial = const WellnessData()]);
  @override
  Future<void> save(WellnessData data) async {
    initial = data;
  }
}
