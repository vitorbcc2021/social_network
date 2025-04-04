import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../views/profile_screen.dart';

class FloatingProfileButton extends StatelessWidget {
  const FloatingProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    return Obx(() {
      return Positioned(
        top: 25,
        left: 7.0,
        child: GestureDetector(
          onTap: () {
            Get.off(() => const ProfileScreen());
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: uc.currentUser!.profilePicture.isNotEmpty
                  ? Image.network(
                      uc.currentUser!.profilePicture,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.blueGrey.shade500,
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
