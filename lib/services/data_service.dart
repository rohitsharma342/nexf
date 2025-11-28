import 'package:flutter/foundation.dart';
import '../models/content_model.dart';
import '../models/user_model.dart';

class DataService extends ChangeNotifier {
  List<ContentModel> _allContent = [];
  List<UserProfile> _userProfiles = [];
  UserProfile? _currentProfile;
  String _selectedCategory = 'Trending';
  List<String> _searchSuggestions = [];

  DataService() {
    _initializeData();
  }

  List<ContentModel> get allContent => _allContent;
  List<UserProfile> get userProfiles => _userProfiles;
  UserProfile? get currentProfile => _currentProfile;
  String get selectedCategory => _selectedCategory;
  List<String> get searchSuggestions => _searchSuggestions;

  void _initializeData() {
    _allContent = [
      ContentModel(
        id: '1',
        title: 'The Dark Knight',
        description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        imageUrl: 'https://images.unsplash.com/photo-1489599651230-2c39b21c8db2?w=800',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        genre: 'Action, Crime, Drama',
        year: 2008,
        rating: 9.0,
        cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
        type: 'Movie',
      ),
      ContentModel(
        id: '2',
        title: 'Stranger Things',
        description: 'When a young boy disappears, his mother, a police chief and his friends must confront terrifying supernatural forces in order to get him back.',
        imageUrl: 'https://images.unsplash.com/photo-1535016120720-40c646be5580?w=800',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        genre: 'Drama, Fantasy, Horror',
        year: 2016,
        rating: 8.7,
        cast: ['Millie Bobby Brown', 'Finn Wolfhard', 'Winona Ryder'],
        type: 'TV Show',
      ),
      ContentModel(
        id: '3',
        title: 'Inception',
        description: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
        imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=800',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        genre: 'Action, Sci-Fi, Thriller',
        year: 2010,
        rating: 8.8,
        cast: ['Leonardo DiCaprio', 'Marion Cotillard', 'Tom Hardy'],
        type: 'Movie',
      ),
      ContentModel(
        id: '4',
        title: 'Breaking Bad',
        description: 'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
        imageUrl: 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=800',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        genre: 'Crime, Drama, Thriller',
        year: 2008,
        rating: 9.5,
        cast: ['Bryan Cranston', 'Aaron Paul', 'Anna Gunn'],
        type: 'TV Show',
      ),
      ContentModel(
        id: '5',
        title: 'Avengers: Endgame',
        description: 'After the devastating events of Avengers: Infinity War, the universe is in ruins due to the efforts of the Mad Titan, Thanos.',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        genre: 'Action, Adventure, Drama',
        year: 2019,
        rating: 8.4,
        cast: ['Robert Downey Jr.', 'Chris Evans', 'Mark Ruffalo'],
        type: 'Movie',
      ),
      ContentModel(
        id: '6',
        title: 'The Crown',
        description: 'Follows the political rivalries and romance of Queen Elizabeth II\'s reign and the events that shaped the second half of the twentieth century.',
        imageUrl: 'https://images.unsplash.com/photo-1561731216-c3a4d99437d5?w=800',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        genre: 'Biography, Drama, History',
        year: 2016,
        rating: 8.6,
        cast: ['Claire Foy', 'Olivia Colman', 'Imelda Staunton'],
        type: 'TV Show',
      ),
    ];

    _userProfiles = [
      UserProfile(
        id: '1',
        name: 'John Doe',
        avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
        watchlist: ['1', '3'],
      ),
      UserProfile(
        id: '2',
        name: 'Kids Profile',
        avatarUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=200',
        isKidsProfile: true,
        watchlist: [],
      ),
    ];

    _currentProfile = _userProfiles.first;
    _searchSuggestions = _allContent.map((content) => content.title).toList();
  }

  List<ContentModel> getContentByCategory(String category) {
    switch (category) {
      case 'Movies':
        return _allContent.where((content) => content.type == 'Movie').toList();
      case 'TV Shows':
        return _allContent.where((content) => content.type == 'TV Show').toList();
      case 'My Watchlist':
        if (_currentProfile != null) {
          return _allContent.where((content) => _currentProfile!.watchlist.contains(content.id)).toList();
        }
        return [];
      default:
        return _allContent;
    }
  }

  List<ContentModel> searchContent(String query) {
    if (query.isEmpty) return [];
    return _allContent.where((content) => 
      content.title.toLowerCase().contains(query.toLowerCase()) ||
      content.genre.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setCurrentProfile(UserProfile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  void toggleWatchlist(String contentId) {
    if (_currentProfile != null) {
      final watchlist = List<String>.from(_currentProfile!.watchlist);
      if (watchlist.contains(contentId)) {
        watchlist.remove(contentId);
      } else {
        watchlist.add(contentId);
      }
      
      final updatedProfile = _currentProfile!.copyWith(watchlist: watchlist);
      final profileIndex = _userProfiles.indexWhere((profile) => profile.id == _currentProfile!.id);
      _userProfiles[profileIndex] = updatedProfile;
      _currentProfile = updatedProfile;
      
      notifyListeners();
    }
  }

  bool isInWatchlist(String contentId) {
    return _currentProfile?.watchlist.contains(contentId) ?? false;
  }

  ContentModel? getContentById(String id) {
    try {
      return _allContent.firstWhere((content) => content.id == id);
    } catch (e) {
      return null;
    }
  }

  void addProfile(UserProfile profile) {
    _userProfiles.add(profile);
    notifyListeners();
  }

  void removeProfile(String profileId) {
    _userProfiles.removeWhere((profile) => profile.id == profileId);
    if (_currentProfile?.id == profileId && _userProfiles.isNotEmpty) {
      _currentProfile = _userProfiles.first;
    }
    notifyListeners();
  }
}