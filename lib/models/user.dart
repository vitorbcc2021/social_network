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
    followers,
  }) {
    this.followers = followers ?? 0;
    this.profilePicture = profilePicture ?? '';
    this.banner = banner ?? '';
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
    String? banner,
    int? followers,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      banner: banner ?? this.banner,
      followers: followers ?? this.followers,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'] ?? '',
      banner: json['banner'] ?? '',
      followers: json['followers'] ?? 0,
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
