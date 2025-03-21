import 'package:get/get.dart';

import '../services/post_service.dart';

class PostController extends GetxController {
  final PostService _postService;

  late int length;

  PostController(this._postService) {
    length = 0;
  }
}
