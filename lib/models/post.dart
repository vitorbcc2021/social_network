import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'generic_model.dart';

class Post extends GenericModel<Post> {
  String userId;
  String imgPath;
  List<String> likes;

  Post({
    super.id,
    required this.userId,
    required this.imgPath,
    List<String>? likes,
  }) : likes = likes ?? [];

  @override
  Post copyWith({
    String? id,
    String? userId,
    String? imgPath,
    List<String>? likes,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imgPath: imgPath ?? this.imgPath,
      likes: likes ?? this.likes,
    );
  }

  bool get isLiked {
    final currentUserId = Get.find<UserController>().currentUser?.id;
    return currentUserId != null && likes.contains(currentUserId);
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['postID'],
      userId: json['userId'],
      imgPath: json['imagePath'],
      likes: json['likes'],
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imgPath': imgPath,
      'likes': likes,
    };
  }
}
