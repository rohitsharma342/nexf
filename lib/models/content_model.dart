class ContentModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String genre;
  final int year;
  final double rating;
  final List<String> cast;
  final String type;
  final bool isInWatchlist;

  ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.genre,
    required this.year,
    required this.rating,
    required this.cast,
    required this.type,
    this.isInWatchlist = false,
  });

  ContentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? videoUrl,
    String? genre,
    int? year,
    double? rating,
    List<String>? cast,
    String? type,
    bool? isInWatchlist,
  }) {
    return ContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      cast: cast ?? this.cast,
      type: type ?? this.type,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
    );
  }
}