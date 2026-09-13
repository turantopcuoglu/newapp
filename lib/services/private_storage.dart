import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Migrates pre-wellness sensitive records without inventing dated history.
/// Plaintext is removed only after the encrypted snapshot is committed.
class PrivateStorage {
  static const protectedKeys = {
    'user_profile',
    'today_check_in',
    'daily_mode',
    'daily_mode_date',
    'beverages',
    'cooked_entries',
    'meal_plans',
  };
  static const snapshotKey = 'private_records_encrypted_v1';
  static const _keyName = 'private_records_key_v1';
  final SharedPreferences prefs;
  final SecretKey key;
  final AesGcm cipher;
  Map<String, String> _values;
  Future<void> _tail = Future.value();
  PrivateStorage._(this.prefs, this.key, this.cipher, this._values);

  static Future<PrivateStorage> open(
    SharedPreferences prefs, {
    FlutterSecureStorage secure = const FlutterSecureStorage(),
  }) async {
    final cipher = AesGcm.with256bits();
    final snapshot = prefs.getString(snapshotKey);
    var encodedKey = await secure.read(key: _keyName);
    if (encodedKey == null) {
      if (snapshot != null) throw StateError('Private storage key unavailable');
      encodedKey = base64Encode(
        await (await cipher.newSecretKey()).extractBytes(),
      );
      await secure.write(key: _keyName, value: encodedKey);
    }
    final key = SecretKey(base64Decode(encodedKey));
    var values = <String, String>{};
    if (snapshot != null) {
      final bytes = await cipher.decrypt(
        SecretBox.fromConcatenation(
          base64Decode(snapshot),
          nonceLength: 12,
          macLength: 16,
        ),
        secretKey: key,
      );
      final decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      if (decoded['version'] != 1) {
        throw const FormatException('Unsupported private storage schema');
      }
      values = Map<String, String>.from(decoded['values'] as Map);
    }
    final migrated = <String>[];
    for (final name in protectedKeys) {
      final legacy = prefs.getString(name);
      if (legacy != null) {
        values.putIfAbsent(name, () => legacy);
        migrated.add(name);
      }
    }
    final store = PrivateStorage._(prefs, key, cipher, values);
    if (migrated.isNotEmpty) {
      await store._commit(values);
      for (final name in migrated) {
        await prefs.remove(name);
      }
    }
    return store;
  }

  String? read(String name) => _values[name];
  Future<void> write(String name, String? value) {
    // Match SharedPreferences' synchronous read-after-write cache contract.
    // Legacy append operations read their predecessor before awaiting disk.
    final previous = _values;
    final next = {..._values};
    if (value == null) {
      next.remove(name);
    } else {
      next[name] = value;
    }
    _values = next;
    final operation = _tail.then((_) async {
      try {
        await _commit(next);
      } catch (_) {
        if (identical(_values, next)) _values = previous;
        rethrow;
      }
    });
    _tail = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> _commit(Map<String, String> values) async {
    final box = await cipher.encrypt(
      utf8.encode(jsonEncode({'version': 1, 'values': values})),
      secretKey: key,
    );
    if (!await prefs.setString(
      snapshotKey,
      base64Encode(box.concatenation()),
    )) {
      throw StateError('Private storage write failed');
    }
  }
}
