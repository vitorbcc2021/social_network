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

  Future<void> toggleLike(String postId) async {
    try {
      final userController = Get.find<UserController>();
      final currentUser = userController.currentUser;

      if (currentUser == null) {
        Get.snackbar('Atenção', 'Faça login para curtir posts');
        return;
      }

      final postIndex = allPosts.indexWhere((p) => p.id == postId);
      if (postIndex == -1) return;

      final updatedPost = allPosts[postIndex].copyWith(
        likes: () {
          final List<String> newLikes = List.from(allPosts[postIndex].likes);
          if (newLikes.contains(currentUser.id!)) {
            newLikes.remove(currentUser.id!);
          } else {
            newLikes.add(currentUser.id!);
          }
          return newLikes;
        }(),
      );

      await _postService.update(postId, updatedPost);
      allPosts[postIndex] = updatedPost;
      allPosts.refresh();
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao atualizar like');
    }
  }
}
