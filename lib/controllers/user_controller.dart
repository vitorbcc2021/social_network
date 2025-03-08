import 'package:social_network/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  void changeProfilePicture(User user, String url) {
    update();
  }

  void changeUserName(int userId, String newUsername) {
    update();
  }

  void changeBanner(User user, String url) {
    update();
  }

  bool logout(User model) {
    return true;
  }
}
