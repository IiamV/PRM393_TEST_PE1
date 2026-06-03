import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/favorites_storage_service.dart';
import '../services/post_api_service.dart';

class PostProvider extends ChangeNotifier {
  PostProvider({
    required this.apiService,
    required this.storageService,
  });

  final PostApiService apiService;
  final FavoritesStorageService storageService;

  final List<Post> _posts = <Post>[];
  final List<Post> _favorites = <Post>[];
  String _searchQuery = '';
  String? _errorMessage;
  bool _isLoading = false;
  bool _isOfflineFallback = false;

  List<Post> get posts {
    final source = _posts.isNotEmpty ? _posts : _favorites;
    if (_searchQuery.trim().isEmpty) {
      return List.unmodifiable(source);
    }

    final query = _searchQuery.toLowerCase();
    return source
        .where(
          (post) =>
              post.title.toLowerCase().contains(query) ||
              post.body.toLowerCase().contains(query),
        )
        .toList();
  }

  List<Post> get favorites => List.unmodifiable(_favorites);
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isOfflineFallback => _isOfflineFallback;
  bool get hasPosts => posts.isNotEmpty;

  Future<void> initialize() async {
    _setLoading(true);
    await _loadFavorites();
    await fetchPosts();
  }

  Future<void> fetchPosts() async {
    _setLoading(true);
    try {
      final fetchedPosts = await apiService.fetchPosts();
      _posts
        ..clear()
        ..addAll(fetchedPosts);
      _errorMessage = null;
      _isOfflineFallback = false;
    } catch (_) {
      _posts.clear();
      _isOfflineFallback = _favorites.isNotEmpty;
      _errorMessage = _isOfflineFallback
          ? 'Offline mode: showing saved favorites.'
          : 'Could not load posts. Check your connection and try again.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleFavorite(Post post) async {
    if (isFavorite(post.id)) {
      _favorites.removeWhere((favorite) => favorite.id == post.id);
    } else {
      _favorites.add(post);
    }

    await storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  bool isFavorite(int postId) {
    return _favorites.any((post) => post.id == postId);
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    try {
      final savedFavorites = await storageService.loadFavorites();
      _favorites
        ..clear()
        ..addAll(savedFavorites);
      notifyListeners();
    } catch (_) {
      _favorites.clear();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
