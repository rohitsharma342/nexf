import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  
  List<Profile> _profiles = [];
  bool _isLoading = false;
  String? _error;

  List<Profile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProfileController() {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _profiles = await _profileService.getProfiles();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load profiles: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createProfile({
    required String name,
    required String avatarUrl,
    bool isKidsProfile = false,
    List<String> favoriteGenres = const [],
    String maturityRating = 'All',
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final profile = Profile(
        id: '',
        name: name,
        avatarUrl: avatarUrl,
        isKidsProfile: isKidsProfile,
        createdAt: DateTime.now(),
        lastUsed: DateTime.now(),
        favoriteGenres: favoriteGenres,
        maturityRating: maturityRating,
      );
      
      final newProfile = await _profileService.createProfile(profile);
      _profiles.add(newProfile);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final updatedProfile = await _profileService.updateProfile(profile);
      final index = _profiles.indexWhere((p) => p.id == profile.id);
      if (index != -1) {
        _profiles[index] = updatedProfile;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteProfile(String profileId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await _profileService.deleteProfile(profileId);
      _profiles.removeWhere((profile) => profile.id == profileId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<String> get availableAvatars => _profileService.availableAvatars;
  List<String> get maturityRatings => _profileService.maturityRatings;
  List<String> get availableGenres => _profileService.availableGenres;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}