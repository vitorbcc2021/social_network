import 'generic_model.dart';

class User extends GenericModel {
  late String name;
  late String email;
  late String profilePicture;
  late String banner;
  late int followers;

  User({
    super.id,
    required this.name,
    required this.email,
    profilePicture,
    banner,
  }) {
    followers = 0;

    if (profilePicture != null) {
      this.profilePicture = profilePicture;
    } else {
      this.profilePicture = '';
    }

    if (banner != null) {
      this.banner = banner;
    } else {
      this.banner = '';
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'] ?? '',
      banner: json['banner'] ?? '',
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'profile_photo': profilePicture,
      'profile_banner': banner,
      'followers': followers,
      'email': email,
    };
  }
}
