import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/user.dart';
import '../../views/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton(
      {super.key, required this.currentUser, required this.controller});
  final User currentUser;
  final UserController controller;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 5,
      child: Container(
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
          border: Border.all(width: 3, color: Colors.white),
        ),
        child: IconButton(
          color: Colors.blueGrey[700],
          padding: const EdgeInsets.symmetric(horizontal: 3),
          onPressed: () {
            if (controller.logout(currentUser)) {
              Get.offAll(() => LoginScreen());
            }
          },
          icon: const Icon(
            Icons.logout_outlined,
          ),
        ),
      ),
    );
  }
}
