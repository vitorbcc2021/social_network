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
        'imagePath': post.imgPath,
        'text': '', // Adicione um campo de texto se necessário
        'likes': post.likes,
        'userId': post.user.id
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

  Future<List<Post>> getAllByUserID(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      return postsJson
          .where((post) => post['userId'] == userId)
          .map((json) => Post.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  Future<List<Post>> getAllPosts() async {
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

  Future<Post> updatePost(String id, Post newPost) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'imagePath': newPost.imgPath,
        'text': '', // Adicione um campo de texto se necessário
        'likes': newPost.likes,
        'userId': newPost.user.id
      }),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update post: ${response.statusCode}');
    }
  }

  Future<void> removeById(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post: ${response.statusCode}');
    }
  }
}
