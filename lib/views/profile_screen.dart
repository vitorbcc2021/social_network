import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_controller.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../widgets/post/post_viewer.dart';
import '../widgets/profile/follow_button.dart';
import '../widgets/profile/logout_button.dart';
import '../widgets/profile/profile_banner.dart';
import '../widgets/profile/profile_picture.dart';
import 'home_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.otherUserId});
  final String? otherUserId;

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: FutureBuilder<User?>(
        future: otherUserId != null
            ? uc.getUserById(otherUserId!)
            : Future.value(uc.currentUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Usuário não encontrado'));
          }

          final user = snapshot.data!;

          return GetBuilder<UserController>(
            builder: (controller) {
              return ListView(
                children: [
                  Stack(
                    children: [
                      ProfileBanner(otherUserId: otherUserId),
                      otherUserId == null
                          ? const LogoutButton()
                          : const SizedBox(),
                      IconButton(
                        alignment: Alignment.topLeft,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          final pc = Get.find<PostController>();
                          pc.userPosts.clear();
                          Get.off(() => const HomePage());
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                        child: ProfilePicture(otherUserId: otherUserId),
                      ),
                    ],
                  ),
                  _buildUserName(user),
                  _buildFollowersSection(user),
                  PostViewer(user: user),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserName(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            user.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        if (otherUserId == null)
          GestureDetector(
            onTap: () => print('editando o nome'),
            child: Container(
              padding: const EdgeInsets.only(top: 3),
              child: const Icon(Icons.edit_square, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildFollowersSection(User user) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 43, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const SizedBox(height: 60, width: 100),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(55, 25, 0, 0),
          child: Text(
            'Followers: ${user.followers}',
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 35),
                child: otherUserId != null ? const FollowButton() : Container(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
