import 'generic_model.dart';

class User extends GenericModel<User> {
  late final String name;
  late final String email;
  late final String profilePicture;
  late final String banner;
  late final List<String> followers;

  User({
    super.id,
    required this.name,
    required this.email,
    profilePicture,
    banner,
    followers,
  }) {
    this.followers = followers ?? [];
    this.profilePicture = profilePicture ?? '';
    this.banner = banner ?? '';
  }

  @override
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
    String? banner,
    List<String>? followers,
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
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'] ?? '',
      banner: json['banner'] ?? '',
      followers: List<String>.from(json['followers']),
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
