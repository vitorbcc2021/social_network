import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/widgets/profile/profile_post_viewer.dart';

import '../controllers/user_controller.dart';
import '../widgets/profile/follow_button.dart';
import '../widgets/profile/logout_button.dart';
import '../widgets/profile/profile_banner.dart';
import 'home_page.dart';
import '../models/post.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key,
      required this.currentUser,
      required this.posts,
      this.otherUser});
  final User currentUser;
  final List<Post> posts;
  final User? otherUser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: GetBuilder<UserController>(
        builder: (controller) {
          int followNumber = widget.currentUser.followers;
          return ListView(
            children: [
              Stack(
                children: [
                  ProfileBanner(
                    currentUser: widget.currentUser,
                    otherUser: widget.otherUser,
                  ),
                  widget.otherUser == null
                      ? LogoutButton(
                          currentUser: widget.currentUser,
                          controller: controller)
                      : const SizedBox(),
                  IconButton(
                    alignment: Alignment.topLeft,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.off(() => HomePage(currentUser: widget.currentUser));
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: GestureDetector(
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
                            if (widget.otherUser == null) {
                              UserController uc = Get.find<UserController>();

                              uc.changeProfilePicture(
                                  widget.currentUser, imagePath);
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.blueGrey.shade900, width: 8),
                        ),
                        child: ClipOval(
                          child: (widget.otherUser != null)
                              ? (widget.otherUser!.profilePicture != '')
                                  ? Image.file(
                                      File(widget.otherUser!.profilePicture),
                                      fit: BoxFit.cover,
                                    )
                                  : fallbackProfilePictureContainer()
                              : (widget.currentUser.profilePicture != '')
                                  ? Image.file(
                                      File(widget.currentUser.profilePicture),
                                      fit: BoxFit.cover,
                                    )
                                  : fallbackProfilePictureContainer(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: (widget.otherUser != null)
                        ? Text(
                            widget.otherUser!.userName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 30, color: Colors.white),
                          )
                        : Text(
                            widget.currentUser.userName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 30, color: Colors.white),
                          ),
                  ),
                  GestureDetector(
                    onTap: () => print('editando o nome'),
                    child: Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: const Icon(
                        Icons.edit_square,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 43, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const SizedBox(
                      height: 60,
                      width: 100,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(55, 25, 0, 0),
                    child: Text(
                      'Followers: $followNumber',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 35),
                          child: widget.otherUser != null
                              ? FollowButton()
                              : Container(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // Stack(
              //   children: [
              //     //aboutMe(),
              //     Container(
              //       margin: const EdgeInsets.fromLTRB(77, 48, 0, 0),
              //       child: const SizedBox(
              //         width: 118,
              //         child: Tooltip(
              //           message: 'Fontaine The Nation of the Hydro Arcon',
              //           child: Text(
              //             'Fontaine The Nation of the Hydro Arcon',
              //             maxLines: 1,
              //             textWidthBasis: TextWidthBasis.parent,
              //             overflow: TextOverflow.ellipsis,
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: const EdgeInsets.fromLTRB(77, 90, 0, 0),
              //       child: const SizedBox(
              //         width: 118,
              //         child: Tooltip(
              //           message: '(00)00000-0000',
              //           child: Text(
              //             '(00)00000-0000',
              //             maxLines: 1,
              //             textWidthBasis: TextWidthBasis.parent,
              //             overflow: TextOverflow.ellipsis,
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: const EdgeInsets.fromLTRB(227, 48, 0, 0),
              //       child: const SizedBox(
              //         width: 118,
              //         child: Tooltip(
              //           message: 'Bolo de chocolate',
              //           child: Text(
              //             'Bolo de chocolate',
              //             maxLines: 1,
              //             textWidthBasis: TextWidthBasis.parent,
              //             overflow: TextOverflow.ellipsis,
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: const EdgeInsets.fromLTRB(227, 90, 0, 0),
              //       child: const SizedBox(
              //         width: 118,
              //         child: Tooltip(
              //           message: 'Branco',
              //           child: Text(
              //             'Branco',
              //             maxLines: 1,
              //             textWidthBasis: TextWidthBasis.parent,
              //             overflow: TextOverflow.ellipsis,
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              PostViewer(
                  currentUser: widget.currentUser,
                  otherUser: widget.otherUser,
                  posts: widget.posts),
            ],
          );
        },
      ),
    );
  }

  Container fallbackProfilePictureContainer() {
    return Container(
      color: Colors.blueGrey.shade500,
      child: const Icon(
        Icons.add_a_photo_outlined,
        color: Colors.white,
        size: 50,
      ),
    );
  }

  Stack aboutMe() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 43, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade800,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const SizedBox(
            height: 120,
            width: 100,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(55, 13, 0, 0),
          child: const Text(
            'About me:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 17,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(55, 45, 0, 0),
          child: const Icon(
            Icons.house_outlined,
            color: Colors.white,
            size: 22,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(55, 90, 0, 0),
          child: const Icon(
            Icons.phone_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(205, 45, 0, 0),
          child: const Icon(
            Icons.fastfood_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(205, 90, 0, 0),
          child: const Icon(
            Icons.color_lens_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}
