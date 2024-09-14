import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:social_network/repositories/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';

import '../controllers/post_controller.dart';
import '../controllers/user_controller.dart';
import 'home_page.dart';
import 'login_screen.dart';
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
  final DatabaseHelper _helper = DatabaseHelper();

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
                    Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.greenAccent,
                      child: GestureDetector(
                        onTap: () async {
                          FilePickerResult? result;

                          try {
                            result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                          } catch (e) {
                            e.printError();
                          }

                          if (result != null && result.files.isNotEmpty) {
                            String? imagePath = result.files[0].path;

                            if (imagePath != null) {
                              if (widget.otherUser == null) {
                                UserController uc = Get.find<UserController>();

                                uc.changeBanner(widget.currentUser, imagePath);
                              }
                            }
                          }
                        },
                        child: (widget.otherUser != null)
                            ? (widget.otherUser!.banner != '')
                                ? Image.file(
                                    File(widget.otherUser!.banner),
                                    fit: BoxFit.cover,
                                  )
                                : fallbackBannerContainer()
                            : (widget.currentUser.banner != '')
                                ? Image.file(
                                    File(widget.currentUser.banner),
                                    fit: BoxFit.cover,
                                  )
                                : fallbackBannerContainer(),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 5,
                      child: Container(
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                          border: Border.all(width: 3, color: Colors.white),
                        ),
                        child: IconButton(
                          color: Colors.blueGrey[700],
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          onPressed: () {
                            if (controller.logout(widget.currentUser)) {
                              Get.offUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) =>
                                      route.currentResult == LoginScreen());
                            }
                          },
                          icon: const Icon(
                            Icons.power_settings_new,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.topLeft,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.off(
                            () => HomePage(currentUser: widget.currentUser));
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 43, vertical: 8),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
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
                    otherUser:
                        widget.otherUser != null ? widget.otherUser : null,
                    posts: widget.posts),
              ],
            );
          },
        ));
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

  Widget fallbackBannerContainer() {
    return Container(
      color: Colors.blueGrey.shade500,
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: const Icon(Icons.add_a_photo_outlined,
            color: Colors.white, size: 50),
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

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
  });

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

class PostViewer extends StatelessWidget {
  const PostViewer(
      {super.key,
      required this.currentUser,
      required this.otherUser,
      required this.posts});
  final List<Post> posts;
  final User currentUser;
  final User? otherUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) => GetBuilder<PostController>(
            builder: (controller) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 50, 6, 50),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.file(
                          File(posts[index].imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                    width: 250,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: (otherUser != null)
                              ? (otherUser!.profilePicture != '')
                                  ? Image.file(
                                      File(otherUser!.profilePicture),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.blueGrey.shade500,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    )
                              : (currentUser.profilePicture != '')
                                  ? Image.file(
                                      File(currentUser.profilePicture),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.blueGrey.shade500,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: (otherUser != null)
                              ? Text(
                                  otherUser!.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )
                              : Text(
                                  currentUser.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('curtida'),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 360, 0, 0),
                      child: const Icon(Icons.favorite_outline,
                          size: 30, color: Colors.blueGrey),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
