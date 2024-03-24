import 'package:get/get.dart';

import 'generic_model.dart';

class User extends GenericModel {
  late String userName;
  late String profilePicture;
  late int followers;
  late String email;
  late int logged;
  // late String imFrom;
  // late String phone;
  // late String favFood;
  // late String favColor;
  late String banner;

  User.fromModel(Map<String, dynamic> map) : super.fromMap(map) {}

  User(
      {required this.userName,
      profilePicture,
      required this.email,
      super.id,
      super.tableName = 'user_profile',
      banner}) {
    if (profilePicture != null) {
      this.profilePicture = profilePicture;
    } else {
      this.profilePicture = '';
    }

    followers = 0;
    logged = 1;
    // imFrom = '';
    // phone = '';
    // favFood = '';
    // favColor = '';
    if (banner != null) {
      this.banner = banner;
    } else {
      this.banner = '';
    }
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': userName,
      'profile_photo': profilePicture,
      'profile_banner': banner,
      'followers': followers,
      'email': email,
    };
  }
}
