import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class PostService {
  static const String _baseUrl = 'http://localhost:8080/post';

  Future<Post> addPost(Post post) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': post.id,
        'userId': post.userId,
        'imgPath': post.imgPath,
        'likes': post.likes
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post: ${response.reasonPhrase}');
    }
  }

  Future<Post> getById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Post not found');
    } else {
      throw Exception('Failed to load post: ${response.statusCode}');
    }
  }

  Future<List<Post>> getAllFromUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$userId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user posts');
    }
  }

  Future<List<Post>> getAll() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  Future<Post> update(String id, Post newPost) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': newPost.userId,
        'imagePath': newPost.imgPath,
        'likes': newPost.likes
      }),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update post: ${response.statusCode}');
    }
  }

  Future<void> remove(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post: ${response.statusCode}');
    }
  }
}
