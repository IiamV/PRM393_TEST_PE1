import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';

class FavoritesStorageService {
  static const String _favoritesKey = 'favorite_posts';

  Future<List<Post>> loadFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    final values = preferences.getStringList(_favoritesKey) ?? <String>[];
    return values.map(Post.decode).toList();
  }

  Future<void> saveFavorites(List<Post> posts) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _favoritesKey,
      posts.map((post) => post.encode()).toList(),
    );
  }
}
