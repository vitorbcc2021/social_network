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
        height: 40,
        width: 90,
        margin: const EdgeInsets.fromLTRB(220, 18, 20, 0),
        decoration: BoxDecoration(
          color: isFollowing ? Colors.grey : Colors.blue[700],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton(
          onPressed: () => uc.toggleFollow(user),
          child: Text(
            isFollowing ? 'Following' : '+ Follow',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );
    });
  }
}
