import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import 'user_controller.dart';

class PostController extends GetxController with StateMixin<List<Post>> {
  final PostService _postService;
  final RxList<Post> allPosts = <Post>[].obs;
  final RxList<Post> userPosts = <Post>[].obs;

  PostController(this._postService);

  Future<void> addPost(Post post) async {
    await _postService.addPost(post);
  }

  Future<void> loadPosts({User? user}) async {
    try {
      change(null, status: RxStatus.loading());

      if (user != null) {
        userPosts.value = await _postService.getAllFromUser(user.id!);
        change(userPosts, status: RxStatus.success());
      } else {
        allPosts.value = await _postService.getAll();
        change(allPosts, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> loadAllPosts() async {
    try {
      change(null, status: RxStatus.loading());
      final posts = await _postService.getAll();
      allPosts.assignAll(posts);
      change(allPosts, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> loadUserPosts(String userId) async {
    try {
      change(null, status: RxStatus.loading());
      final posts = await _postService.getAllFromUser(userId);
      userPosts.assignAll(posts);
      change(userPosts, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> refreshPosts() async {
    await loadAllPosts();
    final currentUser = Get.find<UserController>().currentUser;
    if (currentUser != null) {
      await loadUserPosts(currentUser.id!);
    }
  }

  Future<void> toggleLike(Post post) async {
    final uc = Get.find<UserController>();
    if (uc.currentUser!.email == 'recruiterzzz@gmail.com') {
      Get.snackbar('Failed', 'Recruiters cannot like posts');
      return;
    }

    try {
      final userController = Get.find<UserController>();
      final currentUser = userController.currentUser;

      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Make logout and login again to continue to like posts!',
          colorText: Colors.red,
        );
        return;
      }

      if (post.id == null) {
        Get.snackbar(
          'Error',
          'Post id is null!',
          colorText: Colors.red,
        );
        return;
      }

      final updatedPost = post.copyWith(
        likes: () {
          if (post.likes.contains(currentUser.id!)) {
            post.likes.remove(currentUser.id!);
          } else {
            post.likes.add(currentUser.id!);
          }
          return post.likes;
        }(),
      );

      await _postService.update(post.id!, updatedPost);
      post = updatedPost;
      allPosts.refresh();
      userPosts.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like');
    }
  }
}
