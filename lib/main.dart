import 'dart:io';

import 'package:social_network/home_page.dart';
import 'package:social_network/login_screen.dart';
import 'package:social_network/controllers/post_controller.dart';
import 'package:social_network/profile_screen.dart';
import 'package:social_network/registration_screen.dart';
import 'package:social_network/repositories/post_repository.dart';
import 'package:social_network/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/user_controller.dart';
import 'models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'repositories/database_helper.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Get.put(UserRepository());
  Get.put(PostRepository());

  Get.put(UserController(repository: Get.find<UserRepository>()));
  Get.put(PostController(repository: Get.find<PostRepository>()));

  PostController pc = Get.find<PostController>();

  pc.length = (await pc.getAllPosts()).length;

  runApp(
    GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade900),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    ),
  );
}
