import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../views/profile_screen.dart';

class FloatingProfileButton extends StatelessWidget {
  const FloatingProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    return Obx(() {
      final currentUser = uc.currentUser;
      if (currentUser == null) return const SizedBox.shrink();

      return Positioned(
        top: 25,
        left: 7.0,
        child: GestureDetector(
          onTap: () async {
            final pc = Get.find<PostController>();

            List<Map>? maps = await pc.getAllByUserID(currentUser.id!);

            List<Post> posts = [];
            if (maps != null) {
              for (Map map in maps) {
                final postUser = await uc.getById(map['fk_profile']);
                if (postUser != null) {
                  posts.add(Post(
                    id: map['id'],
                    imagePath: map['photo'],
                    user: postUser,
                    likes: map['likes'],
                  ));
                }
              }
            }

            Get.to(() => ProfileScreen(
                  currentUser: currentUser, // Usando do controller
                  posts: posts,
                ));
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child:
                  currentUser.profilePicture.isNotEmpty // Usando do controller
                      ? Image.file(
                          File(currentUser.profilePicture),
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
