class Profile {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isKidsProfile;
  final DateTime createdAt;
  final DateTime lastUsed;
  final List<String> favoriteGenres;
  final String maturityRating;

  Profile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isKidsProfile = false,
    required this.createdAt,
    required this.lastUsed,
    this.favoriteGenres = const [],
    this.maturityRating = 'All',
  });

  Profile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isKidsProfile,
    DateTime? createdAt,
    DateTime? lastUsed,
    List<String>? favoriteGenres,
    String? maturityRating,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isKidsProfile: isKidsProfile ?? this.isKidsProfile,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      maturityRating: maturityRating ?? this.maturityRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'isKidsProfile': isKidsProfile,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
      'favoriteGenres': favoriteGenres,
      'maturityRating': maturityRating,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      isKidsProfile: json['isKidsProfile'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastUsed: DateTime.parse(json['lastUsed']),
      favoriteGenres: List<String>.from(json['favoriteGenres'] ?? []),
      maturityRating: json['maturityRating'] ?? 'All',
    );
  }
}