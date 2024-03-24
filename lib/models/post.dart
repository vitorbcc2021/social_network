import 'package:social_network/models/user.dart';

import 'generic_model.dart';

class Post extends GenericModel {
  User user;
  String imagePath;
  late int likes;

  Post(
      {required this.user,
      required this.imagePath,
      super.id,
      likes,
      super.tableName = 'post'}) {
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
      'photo': imagePath,
      'txt': '',
      "likes": likes,
    };
  }
}
