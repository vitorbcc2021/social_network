import 'package:social_network/models/user.dart';
import 'package:social_network/repositories/user_repository.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  late UserRepository _repository;

  UserController({required UserRepository repository}) {
    _repository = repository;
    // addUser(
    //   user: User(
    //     userName: 'Furina',
    //     email: 'a',
    //     profilePicture: 'assets/images/furinateste.jpg',
    //     banner: 'assets/images/fontaineteste.jpg',
    //     id: 1,
    //   ),
    //   email: 'a',
    //   password: '123',
    // );

    // addUser(
    //   user: User(
    //     userName: 'Furina2',
    //     email: 'b',
    //     profilePicture: 'assets/images/fontaineteste.jpg',
    //     id: 2,
    //   ),
    //   email: 'b',
    //   password: '123',
    // );
  }

  Future<bool> addUser(
      {required User user, required String email, required String password}) {
    return _repository.addUser(model: user, email: email, password: password);
  }

  void removeUser(User user) {
    _repository.delete(user);
    update();
  }

  void removeById(int id) {
    _repository.deleteById(id);
    update();
  }

  List<User> getAll() {
    return _repository.getAll();
  }

  Future<User?>? getById(int id) {
    return _repository.getById(id);
  }

  Future<User?> getByLogin(String email, String password) async {
    return await _repository.getByLogin(email, password);
  }

  void edit(User oldUser, User newUser) {
    _repository.update(oldUser, newUser);
    update();
  }

  void changeProfilePicture(User user, String url) {
    _repository.changeProfilePicture(user, url);
    update();
  }

  void changeUserName(int userId, String newUsername) {
    _repository.changeUserName(userId, newUsername);
    update();
  }

  void changeBanner(User user, String url) {
    _repository.changeBanner(user, url);
    update();
  }

  bool logout(User model) {
    return _repository.logout(model);
  }
}
