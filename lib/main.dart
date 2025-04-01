import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/user_controller.dart';
import 'controllers/post_controller.dart';
import 'services/user_service.dart';
import 'services/post_service.dart';
import 'views/login_screen.dart';

Future<void> main() async {
  runApp(
    GetMaterialApp(
      title: 'PicShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade900),
        useMaterial3: true,
      ),
      initialBinding: AppBindings(),
      home: const LoginScreen(),
    ),
  );
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final userService = Get.put(UserService());
    final postService = Get.put(PostService());
    Get.put(UserController(userService));
    Get.put(PostController(postService));
  }
}
