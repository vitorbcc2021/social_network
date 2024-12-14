import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_controller.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostViewer extends StatelessWidget {
  const PostViewer(
      {super.key,
      required this.currentUser,
      required this.otherUser,
      required this.posts});
  final List<Post> posts;
  final User currentUser;
  final User? otherUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) => GetBuilder<PostController>(
            builder: (controller) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 50, 6, 50),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.file(
                          File(posts[index].imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                    width: 250,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: (otherUser != null)
                              ? (otherUser!.profilePicture != '')
                                  ? Image.file(
                                      File(otherUser!.profilePicture),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.blueGrey.shade500,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    )
                              : (currentUser.profilePicture != '')
                                  ? Image.file(
                                      File(currentUser.profilePicture),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.blueGrey.shade500,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: (otherUser != null)
                              ? Text(
                                  otherUser!.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )
                              : Text(
                                  currentUser.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('curtida'),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 360, 0, 0),
                      child: const Icon(Icons.favorite_outline,
                          size: 30, color: Colors.blueGrey),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
