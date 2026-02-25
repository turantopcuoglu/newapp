import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Global provider for the StorageService.
/// Must be overridden in ProviderScope with the initialized instance.
final storageProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized before use');
});
