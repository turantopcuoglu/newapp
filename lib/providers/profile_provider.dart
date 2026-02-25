import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  final StorageService _storage;

  ProfileNotifier(this._storage)
      : super(_storage.getProfile() ?? const UserProfile());

  void updateAge(int? age) {
    state = state.copyWith(age: age);
    _save();
  }

  void updateWeight(double? weight) {
    state = state.copyWith(weight: weight);
    _save();
  }

  void updateHeight(double? height) {
    state = state.copyWith(height: height);
    _save();
  }

  void updateGender(Gender? gender) {
    state = state.copyWith(gender: gender);
    _save();
  }

  void updateActivityLevel(ActivityLevel level) {
    state = state.copyWith(activityLevel: level);
    _save();
  }

  void updateAllergies(List<String> allergies) {
    state = state.copyWith(allergies: allergies);
    _save();
  }

  void addAllergy(String allergy) {
    final trimmed = allergy.trim().toLowerCase();
    if (trimmed.isEmpty || state.allergies.contains(trimmed)) return;
    state = state.copyWith(allergies: [...state.allergies, trimmed]);
    _save();
  }

  void removeAllergy(String allergy) {
    state = state.copyWith(
        allergies: state.allergies.where((a) => a != allergy).toList());
    _save();
  }

  void updateDislikedIngredients(List<String> disliked) {
    state = state.copyWith(dislikedIngredients: disliked);
    _save();
  }

  void addDislikedIngredient(String ingredientId) {
    if (state.dislikedIngredients.contains(ingredientId)) return;
    state = state.copyWith(
        dislikedIngredients: [...state.dislikedIngredients, ingredientId]);
    _save();
  }

  void removeDislikedIngredient(String ingredientId) {
    state = state.copyWith(
        dislikedIngredients: state.dislikedIngredients
            .where((d) => d != ingredientId)
            .toList());
    _save();
  }

  void saveProfile(UserProfile profile) {
    state = profile;
    _save();
  }

  void _save() => _storage.saveProfile(state);
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  final storage = ref.watch(storageProvider);
  return ProfileNotifier(storage);
});
