import 'generic_model.dart';
import 'user.dart';

class Post extends GenericModel {
  User user;
  String imgPath;
  late int likes;

  Post({required this.user, required this.imgPath, super.id, likes}) {
    if (likes != null) {
      this.likes = likes;
    } else {
      this.likes = 0;
    }
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['postID'],
      user: User(
        id: json['userId'],
        name: json['userName'] ?? '',
        email: json['email'],
      ),
      imgPath: json['imagePath'],
      likes: json['likes'],
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'fk_profile': user.id,
      'photo': imgPath,
      'likes': likes,
    };
  }
}
