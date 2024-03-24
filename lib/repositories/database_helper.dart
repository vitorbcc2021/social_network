import 'package:social_network/controllers/user_controller.dart';
import 'package:social_network/models/generic_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/user.dart';

class DatabaseHelper {
  Database? _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  static get createScript {
    return '''CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- serial is replaced by AUTOINCREMENT
  name TEXT NOT NULL,
  profile_photo TEXT,
  profile_banner TEXT,
  followers INTEGER NOT NULL DEFAULT 0,
  email TEXT NOT NULL,
  --im_from TEXT,
  --phone TEXT,
  --fav_food TEXT,
  --fav_color TEXT,
  UNIQUE(email)
);

CREATE TABLE user_login (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_profile INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE ON UPDATE CASCADE, -- fk_profile references user_profile
  logged_in INTEGER, -- boolean is replaced by INTEGER (0/1)
  email TEXT NOT NULL,
  password TEXT NOT NULL,
  UNIQUE(id, fk_profile), -- UNIQUE constraint on both columns
  UNIQUE(email)
);

CREATE TABLE post (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_profile INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  photo TEXT,
  txt TEXT,
  likes INTEGER NOT NULL DEFAULT 0,
  UNIQUE(id, fk_profile) -- UNIQUE constraint on both columns
);

CREATE TABLE follows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_profile INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  fk_follower INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  UNIQUE(fk_profile, fk_follower) -- UNIQUE constraint on both columns
);
''';
  }

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  Future<Database?> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "picshare.db");

    try {
      return _db = await openDatabase(path,
          version: 1, onCreate: _onCreateDB, onUpgrade: _onUpgradeDB);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute(DatabaseHelper.createScript);
  }

  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute(
          "DROP TABLE ${DatabaseHelper};"); //futuramente terminar implementação!
      await _onCreateDB(db, newVersion);
    }
  }

  Future<T?> save<T extends GenericModel>(T model) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      model.id = await db.insert(model.tableName!, model.toMap()!);
      return model;
    }
    return null;
  }

  Future<T?> savePost<T extends GenericModel>(T model) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      await db.insert(model.tableName!, model.toMap()!);
      return model;
    }
    return null;
  }

  void saveLogin(String email, String password, int id) async {
    Database? db = await DatabaseHelper().db;

    if (db != null) {
      await db.insert(
        'user_login',
        {
          'fk_profile': id,
          'email': email,
          'password': password,
          'logged_in': 1,
        },
      );
    }
  }

  Future<int?> delete<T extends GenericModel>(T model) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      return await db
          .delete(model.tableName!, where: "id=?", whereArgs: [model.id]);
    }
    return null;
  }

  Future<int?> edit<T extends GenericModel>(
      T model, String where, List<Object?> whereArgs) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      return await db.update(
          model.tableName!, model.toMap() as Map<String, Object?>,
          where: where, whereArgs: whereArgs);
    }
    return null;
  }

  Future<List<T>?> getAll<T extends GenericModel>(String tableName) async {
    Database? db = await DatabaseHelper().db;
    List<T> models = [];
    if (db != null) {
      List<Map> returned = await db.query(tableName, columns: null);

      for (Map map in returned) {
        models.add(GenericModel.fromMap(map) as T);
      }
      return models;
    } else {
      return null;
    }
  }

  Future<T?> getById<T extends GenericModel>(T model) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      List<Map> returnedModel = await db.query(model.tableName!,
          columns: null, where: "id=?", whereArgs: [model.id]);

      return GenericModel.fromMap(returnedModel.first) as T;
    }
    return null;
  }
}
