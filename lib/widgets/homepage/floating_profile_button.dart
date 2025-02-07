import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../views/home_page.dart';
import '../../views/profile_screen.dart';

class FloatingProfileButton extends StatelessWidget {
  const FloatingProfileButton({
    super.key,
    required this.widget,
  });

  final HomePage widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 25,
      left: 7.0,
      child: GestureDetector(
        onTap: () async {
          PostController pc = Get.find<PostController>();
          UserController uc = Get.find<UserController>();

          List<Map>? maps = await pc.getAllByUserID(widget.currentUser.id!);

          List<Post> posts = [];

          if (maps != null) {
            for (Map map in maps) {
              posts.add(Post(
                id: map['id'],
                imagePath: map['photo'],
                user: (await uc.getById(map['fk_profile']))!,
                likes: map['likes'],
              ));
            }
          }
          return Get.to(() => ProfileScreen(
                currentUser: widget.currentUser,
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
            child: widget.currentUser.profilePicture != ''
                ? Image.file(
                    File(widget.currentUser.profilePicture),
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
  }
}
