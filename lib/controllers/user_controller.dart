import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService;

  UserController(this._userService);

  final Rx<User?> _currentUser = Rx<User?>(null);

  User? get currentUser => _currentUser.value;

  final RxMap<String, bool> _followingStatus = <String, bool>{}.obs;
  final RxInt _followerCount = 0.obs;

  bool isFollowing(String userId) => _followingStatus[userId] ?? false;
  int get followerCount => _followerCount.value;

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

  void visitAsRecruiter() {
    final recruiter = User(
      id: '000',
      name: 'Recruiter',
      email: 'recruiterzzz@gmail.com',
      profilePicture: '',
      banner: '',
      followers: [],
    );
    _currentUser.value = recruiter;
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

  Future<void> toggleFollow(User otherUser) async {
    try {
      final currentUserId = currentUser?.id;
      if (currentUserId == null) return;

      final newStatus = !isFollowing(otherUser.id!);
      _followingStatus[otherUser.id!] = newStatus;
      _followerCount.value =
          newStatus ? _followerCount.value + 1 : _followerCount.value - 1;

      await _userService.toggleFollow(
        currentUserId: currentUserId,
        otherUserId: otherUser.id!,
        follow: newStatus,
      );
    } catch (e) {
      _followingStatus[otherUser.id!] = !isFollowing(otherUser.id!);
      _followerCount.value = isFollowing(otherUser.id!)
          ? _followerCount.value + 1
          : _followerCount.value - 1;

      Get.snackbar('Erro', 'Falha ao atualizar: $e', colorText: Colors.red);
    }
  }

  void loadUserFollowers(User user) {
    _followerCount.value = user.followers.length;
    _followingStatus[user.id!] = user.followers.contains(currentUser?.id);
  }
}
