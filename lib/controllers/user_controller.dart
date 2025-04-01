import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService;

  UserController(this._userService);

  final Rx<User?> _currentUser = Rx<User?>(null);

  User? get currentUser => _currentUser.value;

  Future<User?> getUserById(String userId) async {
    try {
      return await _userService.getById(userId);
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao buscar usuário: $e',
          colorText: Colors.red);
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final user = await _userService.login(email, password);
      _currentUser.value = user;
      return user;
    } catch (e) {
      Get.snackbar('Error', 'Failed to login: $e', colorText: Colors.red);
      return null;
    }
  }

  Future<void> changeProfilePicture(User user, String url) async {
    try {
      final updatedUser = await _userService.update(
        user.id!,
        user.copyWith(profilePicture: url),
      );
      _currentUser.value = updatedUser;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile picture: $e',
          colorText: Colors.red);
    }
  }

  Future<void> changeUserName(String newUsername) async {
    try {
      if (_currentUser.value == null) {
        throw Exception('No user logged in');
      }

      final updatedUser = await _userService.update(
        _currentUser.value!.id!,
        _currentUser.value!.copyWith(name: newUsername),
      );

      _currentUser.value = updatedUser;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update username: $e',
          colorText: Colors.red);
    }
  }

  Future<void> changeBanner(User user, String url) async {
    try {
      final updatedUser = await _userService.update(
        user.id!,
        user.copyWith(banner: url),
      );
      _currentUser.value = updatedUser;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update banner: $e',
          colorText: Colors.red);
    }
  }

  bool logout() {
    _currentUser.value = null;
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final newUser = await _userService.addUser(name, email, password);
      _currentUser.value = newUser;

      return true;
    } on Exception catch (e) {
      if (e.toString().contains('já cadastrado')) {
        return false;
      }
      Get.snackbar('Erro', e.toString(), colorText: Colors.red);
      return false;
    }
  }
}
