import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';

class WhatsNew extends StatelessWidget {
  const WhatsNew({super.key});

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(35, 100, 35, 0),
          height: 60,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(97, 0, 0, 0),
                  blurRadius: 20,
                )
              ]),
          child: const SizedBox.expand(),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(85, 110, 45, 0),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            border: Border.all(
              width: 1,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: GestureDetector(
            onTap: () => print("What's New!"),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.text_fields,
                    color: Colors.grey,
                  ),
                  Text(
                    'What\'s new?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result;
            try {
              result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );
            } catch (e) {
              e.printError();
            }

            if (result != null && result.files.isNotEmpty) {
              String? imagePath = result.files[0].path;

              if (imagePath != null) {
                final pc = Get.find<PostController>();

                Post post =
                    Post(imgPath: imagePath, userId: uc.currentUser!.id!);

                pc.addPost(post);
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(45, 113, 50, 0),
            child: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.blueGrey,
              size: 32,
            ),
          ),
        )
      ],
    );
  }
}
