import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/floating_profile_button.dart';
import '../widgets/logo.dart';
import '../widgets/whats_new.dart';
import '../widgets/home_page_post_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentUser});
  final User currentUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      currentUser: widget.currentUser,
                    ),
                    PostViewer(currentUser: widget.currentUser),
                  ],
                ),
                const Logo(),
                FloatingProfileButton(widget: widget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
