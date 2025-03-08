import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/post_controller.dart';
import 'controllers/user_controller.dart';
import 'views/login_screen.dart';

Future<void> main() async {
  Get.put(UserController());
  Get.put(PostController());

  PostController pc = Get.find<PostController>();

  pc.length = (await pc.getAllPosts()).length;

  runApp(
    GetMaterialApp(
      title: 'PicShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade900),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    ),
  );
}
