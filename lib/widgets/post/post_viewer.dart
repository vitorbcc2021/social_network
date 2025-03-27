import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import 'post_card.dart';

class PostViewer extends StatelessWidget {
  const PostViewer({super.key, this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<PostController>();

    pc.loadPosts(user: user);

    return Obx(() {
      final RxList<Post> posts = user != null ? pc.userPosts : pc.allPosts;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      );
    });
  }
}
