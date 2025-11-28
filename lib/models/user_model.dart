class UserProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isKidsProfile;
  final List<String> watchlist;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isKidsProfile = false,
    this.watchlist = const [],
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isKidsProfile,
    List<String>? watchlist,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isKidsProfile: isKidsProfile ?? this.isKidsProfile,
      watchlist: watchlist ?? this.watchlist,
    );
  }
}