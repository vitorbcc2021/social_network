import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../views/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});
  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();
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
            if (uc.logout()) {
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
