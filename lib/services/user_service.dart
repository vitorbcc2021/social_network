import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserService {
  static const String _baseUrl = 'http://localhost:8080/user';

  Future<User> addUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      throw Exception('Email já cadastrado');
    } else {
      throw Exception('Falha no cadastro: ${response.reasonPhrase}');
    }
  }

  Future<User> getById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<User> getByLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  Future<User> updateUser(String id, User newUser) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': newUser.name,
        'email': newUser.email,
        'profilePicture': newUser.profilePicture,
        'banner': newUser.banner,
        'followers': newUser.followers, // Adicionado
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> removeById(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }
}
