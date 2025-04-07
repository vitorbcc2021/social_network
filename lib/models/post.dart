import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'generic_model.dart';

class Post extends GenericModel<Post> {
  String authorId;
  String imgPath;
  List<String> likes;

  Post({
    super.id,
    required this.authorId,
    required this.imgPath,
    List<String>? likes,
  }) : likes = likes ?? [];

  @override
  Post copyWith({
    String? id,
    String? authorId,
    String? imgPath,
    List<String>? likes,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      imgPath: imgPath ?? this.imgPath,
      likes: likes ?? this.likes,
    );
  }

  bool get isLiked {
    final currentAuthorId = Get.find<UserController>().currentUser!.id;
    return currentAuthorId != null && likes.contains(currentAuthorId);
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      authorId: json['author']['id'], // Acessa o ID dentro do objeto author
      imgPath: json['imgPath'],
      likes:
          List<String>.from(json['likes'] ?? []), // Converte a lista de likes
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'imgPath': imgPath,
      'likes': likes,
    };
  }
}
