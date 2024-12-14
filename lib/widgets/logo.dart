import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade900.withOpacity(1.0),
            Colors.grey.shade900.withOpacity(0.9),
            Colors.grey.shade900.withOpacity(0.9),
            Colors.grey.shade900.withOpacity(0.80),
            Colors.grey.shade900.withOpacity(0.35),
            Colors.transparent,
            Colors.transparent
          ],
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PicShare',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontFamily: 'GenshinFont',
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0, 3),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.group,
              color: Colors.white,
              size: 45,
              shadows: [
                Shadow(
                    color: Colors.black, offset: Offset(0, 3), blurRadius: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
