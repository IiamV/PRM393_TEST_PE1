import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostApiService {
  static const String _postsUrl =
      'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts() async {
    final response = await http
        .get(Uri.parse(_postsUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load posts. Status: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
