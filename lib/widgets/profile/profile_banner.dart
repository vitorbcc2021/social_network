import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/user.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key, this.otherUserId});
  final String? otherUserId;

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    // Se não tem otherUserId, usa o currentUser
    if (otherUserId == null) {
      return _buildBanner(uc.currentUser!, canEdit: true);
    }

    // Se tem otherUserId, busca o usuário
    return FutureBuilder<User?>(
      future: uc.getUserById(otherUserId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 180,
            width: double.infinity,
            color: Colors.blueGrey.shade500,
          );
        }

        if (!snapshot.hasData) {
          return Container(
            height: 180,
            width: double.infinity,
            color: Colors.blueGrey.shade500,
            child: const Icon(Icons.error_outline, color: Colors.white),
          );
        }

        return _buildBanner(snapshot.data!, canEdit: false);
      },
    );
  }

  Widget _buildBanner(User user, {required bool canEdit}) {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.greenAccent,
      child: GestureDetector(
        onTap: canEdit
            ? () async {
                FilePickerResult? result;

                try {
                  result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                } catch (e) {
                  e.printError();
                }

                if (result != null && result.files.isNotEmpty) {
                  String? imagePath = result.files[0].path;

                  if (imagePath != null) {
                    final uc = Get.find<UserController>();
                    uc.changeBanner(uc.currentUser!, imagePath);
                  }
                }
              }
            : null,
        child: user.banner != ''
            ? Image.network(
                user.banner,
                fit: BoxFit.cover,
              )
            : fallbackBannerContainer(),
      ),
    );
  }

  Widget fallbackBannerContainer() {
    return Container(
      color: Colors.blueGrey.shade500,
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: const Icon(Icons.add_a_photo_outlined,
            color: Colors.white, size: 50),
      ),
    );
  }
}
