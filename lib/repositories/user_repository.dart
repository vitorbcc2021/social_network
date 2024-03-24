import 'package:social_network/models/user.dart';
import 'package:social_network/repositories/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:sqflite/sqflite.dart';

import 'generic_repository.dart';

class UserRepository extends GenericRepository<User> {
  final DatabaseHelper _helper = DatabaseHelper();

  void changeProfilePicture(User user, String url) async {
    Database? db = await _helper.db;

    if (user != null) {
      user.profilePicture = url;

      await _helper.edit(user, 'email == ?', [user.email]);
    }
  }

  void changeUserName(int userId, String newUserName) async {
    User? user = await getById(userId);

    if (user != null) {
      user.userName = newUserName;
    }
  }

  void changeBanner(User user, String url) async {
    Database? db = await _helper.db;

    if (user != null) {
      user.banner = url;

      await _helper.edit(user, 'email == ?', [user.email]);
    }
  }

  Future<bool> addUser(
      {required User model,
      required String email,
      required String password}) async {
    final Database? db = await _helper.db;

    List<Map<String, Object?>> query = await db!.query('user_login',
        columns: [
          'email',
        ],
        where: 'email == ?',
        whereArgs: [email]);

    if (query.isEmpty) {
      add(model);

      User? u = await _helper.save(model);

      if (u != null) {
        _helper.saveLogin(email, password, u.id!);
      }

      return true;
    } else {
      return false;
    }
  }

  Future<User?> getByLogin(String email, String password) async {
    Database? db = await _helper.db;

    List<Map> user = await db!.query(
      'user_login',
      columns: ['email', 'password'],
      where: 'email == ?',
      whereArgs: [email],
    );

    if (user.isNotEmpty) {
      Map map = {
        'email': email,
        'password': password,
      };

      if (mapEquals(map, user[0])) {
        List<Map> userProfile = await db.query(
          'user_profile',
          columns: [
            'id',
            'name',
            'profile_photo',
            'profile_banner',
            'followers',
            'email'
          ],
          where: 'email == ?',
          whereArgs: [email],
        );

        User u = User(
            id: userProfile[0]['id'],
            email: userProfile[0]['email'],
            userName: userProfile[0]['name'],
            profilePicture: userProfile[0]['profile_photo'],
            banner: userProfile[0]['profile_banner']);

        Future<int?> validator = _helper.edit(u, 'email==?', [email]);

        // ignore: unnecessary_null_comparison
        if (validator != null) {
          return u;
        } else {
          return null;
        }
      }
    } else {
      print('ooooooooooooooo');
      return null;
    }
  }

  @override
  Future<User?>? getById(int id) async {
    Database? db = await _helper.db;

    List<Map> query = await db!.query('user_profile',
        columns: null, where: 'id == ?', whereArgs: [id]);

    User user = User(
      id: query[0]['id'],
      userName: query[0]['name'],
      email: query[0]['email'],
      banner: query[0]['profile_banner'],
      profilePicture: query[0]['profile_photo'],
    );

    return user;
  }

  bool logout(User model) {
    String email = model.email;
    model.logged = 0;
    Future<int?> validator = _helper.edit(model, 'email==?', [email]);

    // ignore: unnecessary_null_comparison
    if (validator != null) {
      return true;
    } else {
      model.logged = 1;
      return false;
    }
  }
}
