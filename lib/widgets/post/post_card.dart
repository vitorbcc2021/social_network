import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../views/profile_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Stack(
        children: [
          _buildPostImage(),
          _buildUserHeader(),
          _buildLikeButton(),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 50, 6, 50),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: 300,
          width: 300,
          child: Image.network(
            post.imgPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Positioned(
      top: 5,
      left: 10,
      child: GestureDetector(
        onTap: () => _navigateToProfile(),
        child: FutureBuilder<User?>(
          future: Get.find<UserController>().getUserById(post.authorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                !snapshot.hasData) {
              return _buildProfilePlaceholder();
            }
            final user = snapshot.data!;
            return Container(
              width: 250,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Row(
                children: [
                  _buildProfilePicture(user),
                  const SizedBox(width: 10),
                  _buildUserName(user),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      width: 250,
      height: 40,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade500,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Container(
            width: 100,
            height: 16,
            color: Colors.blueGrey.shade500,
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(User user) {
    return ClipOval(
      child: user.profilePicture.isNotEmpty
          ? Image.network(
              user.profilePicture,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            )
          : Container(
              color: Colors.blueGrey.shade500,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 25,
              ),
            ),
    );
  }

  Widget _buildUserName(User user) {
    return Text(
      user.name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    );
  }

  Widget _buildLikeButton() {
    return Positioned(
      bottom: 15,
      left: 15,
      child: Obx(() {
        final isLiked = post.isLiked;
        return GestureDetector(
          onTap: () => Get.find<PostController>().toggleLike(post.id!),
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_outline,
            size: 30,
            color: isLiked ? Colors.red : Colors.blueGrey,
          ),
        );
      }),
    );
  }

  void _navigateToProfile() {
    final uc = Get.find<UserController>();
    final isCurrentUser = uc.currentUser?.id == post.authorId;
    Get.to(() => ProfileScreen(
          otherUserId: isCurrentUser ? null : post.authorId,
        ));
  }
}
