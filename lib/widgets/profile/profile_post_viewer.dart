import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import 'other_user_profile_post_viewer.dart';
import 'own_profile_post_viewer.dart';

class PostViewer extends GetView<PostController> {
  const PostViewer(
      {super.key,
      required this.currentUser,
      this.otherUser,
      required this.posts});
  final User currentUser;
  final User? otherUser;
  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return otherUser == null
        ? OwnProfile(currentUser: currentUser, posts: posts)
        : OtherUserProfile(
            currentUser: currentUser,
            otherUser: otherUser!,
            posts: posts,
          );
  }
}
