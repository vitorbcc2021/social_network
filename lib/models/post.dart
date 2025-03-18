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
