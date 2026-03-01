import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../services/storage_service.dart';
import 'check_in_provider.dart';
import 'storage_provider.dart';

class DailyModeNotifier extends StateNotifier<CheckInType?> {
  final StorageService _storage;
  final CheckInNotifier _checkInNotifier;

  DailyModeNotifier(this._storage, this._checkInNotifier)
      : super(_storage.getDailyMode()) {
    // Sync check-in with daily mode on startup
    final mode = _storage.getDailyMode();
    if (mode != null) {
      _checkInNotifier.setCheckIn(mode);
    }
  }

  bool get isModeSet => state != null;

  void setMode(CheckInType type) {
    state = type;
    _storage.saveDailyMode(type);
    // Sync with check-in provider so recommendations update
    _checkInNotifier.setCheckIn(type);
  }
}

final dailyModeProvider =
    StateNotifierProvider<DailyModeNotifier, CheckInType?>((ref) {
  final storage = ref.watch(storageProvider);
  final checkInNotifier = ref.read(checkInProvider.notifier);
  return DailyModeNotifier(storage, checkInNotifier);
});
