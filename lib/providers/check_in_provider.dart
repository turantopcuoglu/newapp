import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class CheckInNotifier extends StateNotifier<CheckInType?> {
  final StorageService _storage;

  CheckInNotifier(this._storage) : super(_storage.getTodayCheckIn());

  void setCheckIn(CheckInType type) {
    state = type;
    _storage.saveTodayCheckIn(type);
  }

  void clearCheckIn() {
    state = null;
  }
}

final checkInProvider =
    StateNotifierProvider<CheckInNotifier, CheckInType?>((ref) {
  final storage = ref.watch(storageProvider);
  return CheckInNotifier(storage);
});
