import '../models/profile_model.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final List<Profile> _profiles = [
    Profile(
      id: '1',
      name: 'John Doe',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastUsed: DateTime.now().subtract(const Duration(hours: 2)),
      favoriteGenres: ['Action', 'Thriller'],
      maturityRating: 'Mature',
    ),
    Profile(
      id: '2',
      name: 'Kids',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      isKidsProfile: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastUsed: DateTime.now().subtract(const Duration(days: 1)),
      favoriteGenres: ['Animation', 'Family'],
      maturityRating: 'Kids',
    ),
    Profile(
      id: '3',
      name: 'Sarah',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      lastUsed: DateTime.now().subtract(const Duration(hours: 5)),
      favoriteGenres: ['Romance', 'Drama'],
      maturityRating: 'Teen',
    ),
  ];

  List<Profile> get profiles => List.unmodifiable(_profiles);

  Future<List<Profile>> getProfiles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return profiles;
  }

  Future<Profile> createProfile(Profile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newProfile = profile.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
    );
    _profiles.add(newProfile);
    return newProfile;
  }

  Future<Profile> updateProfile(Profile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
      return profile;
    }
    throw Exception('Profile not found');
  }

  Future<void> deleteProfile(String profileId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profiles.removeWhere((profile) => profile.id == profileId);
  }

  List<String> get availableAvatars => [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
    'https://i.pravatar.cc/150?img=7',
    'https://i.pravatar.cc/150?img=8',
  ];

  List<String> get maturityRatings => ['Kids', 'Teen', 'Mature', 'All'];

  List<String> get availableGenres => [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
  ];
}