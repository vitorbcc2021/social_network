import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/user_controller.dart';
import '../../models/user.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.otherUserId});
  final String? otherUserId;

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    if (otherUserId == null) {
      return _buildProfilePicture(uc.currentUser!, canEdit: true);
    }

    return FutureBuilder<User?>(
      future: uc.getUserById(otherUserId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingProfilePicture();
        }

        if (!snapshot.hasData) {
          return _buildErrorProfilePicture();
        }

        return _buildProfilePicture(snapshot.data!, canEdit: false);
      },
    );
  }

  Widget _buildProfilePicture(User user, {required bool canEdit}) {
    return GestureDetector(
      onTap: canEdit ? () => _changeProfilePicture() : null,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueGrey.shade900, width: 8),
        ),
        child: ClipOval(
          child: user.profilePicture.isNotEmpty
              ? Image.file(File(user.profilePicture), fit: BoxFit.cover)
              : _buildFallbackProfilePicture(),
        ),
      ),
    );
  }

  Future<void> _changeProfilePicture() async {
    final uc = Get.find<UserController>();
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null &&
          result.files.isNotEmpty &&
          result.files[0].path != null) {
        uc.changeProfilePicture(uc.currentUser!, result.files[0].path!);
      }
    } catch (e) {
      e.printError();
      Get.snackbar('Erro', 'Falha ao selecionar imagem');
    }
  }

  Widget _buildLoadingProfilePicture() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueGrey.shade900, width: 8),
      ),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildErrorProfilePicture() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueGrey.shade900, width: 8),
      ),
      child: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  Widget _buildFallbackProfilePicture() {
    return Container(
      color: Colors.blueGrey.shade500,
      child: const Icon(
        Icons.add_a_photo_outlined,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
