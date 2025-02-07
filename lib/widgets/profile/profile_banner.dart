import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/user.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner(
      {super.key, required this.currentUser, required this.otherUser});
  final User currentUser;
  final User? otherUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.greenAccent,
      child: GestureDetector(
        onTap: () async {
          FilePickerResult? result;

          try {
            result = await FilePicker.platform.pickFiles(type: FileType.image);
          } catch (e) {
            e.printError();
          }

          if (result != null && result.files.isNotEmpty) {
            String? imagePath = result.files[0].path;

            if (imagePath != null) {
              if (otherUser == null) {
                UserController uc = Get.find<UserController>();

                uc.changeBanner(currentUser, imagePath);
              }
            }
          }
        },
        child: (otherUser != null)
            ? (otherUser!.banner != '')
                ? Image.file(
                    File(otherUser!.banner),
                    fit: BoxFit.cover,
                  )
                : fallbackBannerContainer()
            : (currentUser.banner != '')
                ? Image.file(
                    File(currentUser.banner),
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
