import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 90,
      margin: const EdgeInsets.fromLTRB(220, 18, 20, 0),
      decoration: BoxDecoration(
          color: Colors.blue[700],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12)),
      child: Container(
        alignment: Alignment.center,
        child: const Text(
          '+Follow',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
