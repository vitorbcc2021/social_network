import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/user.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    return Obx(() {
      final isFollowing = uc.isFollowing(user.id!);

      return Container(
        margin: const EdgeInsets.only(right: 40),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.grey : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => uc.toggleFollow(user),
          child: Text(
            isFollowing ? 'Following' : '+ Follow',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }
}
