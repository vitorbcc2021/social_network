import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../widgets/homepage/floating_profile_button.dart';
import '../widgets/homepage/logo.dart';
import '../widgets/homepage/whats_new.dart';
import '../widgets/homepage/home_post_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final uc = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView(
                  children: [
                    WhatsNew(
                      currentUser: uc.currentUser!,
                    ),
                    const PostViewer(),
                  ],
                ),
                const Logo(),
                const FloatingProfileButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
