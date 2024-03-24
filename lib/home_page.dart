import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:social_network/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'controllers/post_controller.dart';
import 'controllers/user_controller.dart';
import 'models/user.dart';
import 'models/post.dart';

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
                Container(
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
                                color: Colors.black,
                                offset: Offset(0, 3),
                                blurRadius: 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  left: 7.0,
                  child: GestureDetector(
                    onTap: () async {
                      PostController pc = Get.find<PostController>();
                      UserController uc = Get.find<UserController>();

                      List<Map>? maps =
                          await pc.getAllByUserID(widget.currentUser.id!);

                      List<Post> posts = [];

                      if (maps != null) {
                        for (Map map in maps) {
                          posts.add(Post(
                            id: map['id'],
                            imagePath: map['photo'],
                            user: (await uc.getById(map['fk_profile']))!,
                            likes: map['likes'],
                          ));
                        }
                      }
                      return Get.to(() => ProfileScreen(
                            currentUser: widget.currentUser,
                            posts: posts,
                          ));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: widget.currentUser.profilePicture != ''
                            ? Image.file(
                                File(widget.currentUser.profilePicture),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.blueGrey.shade500,
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsNew extends StatelessWidget {
  const WhatsNew({super.key, required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(35, 100, 35, 0),
          height: 60,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(64)),
          child: const SizedBox.expand(),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(100, 110, 65, 0),
          height: 40,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade400,
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(64)),
          child: GestureDetector(
            onTap: () => print("What's New!"),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text(
                'What\'s new?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            // Abre o diálogo para escolher um arquivo
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
                PostController pc = Get.find<PostController>();

                Post post = Post(imagePath: imagePath, user: currentUser);

                pc.addPost(post);
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(55, 115, 50, 0),
            child: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.blueGrey,
              size: 30,
            ),
          ),
        )
      ],
    );
  }
}

class PostViewer extends StatelessWidget {
  const PostViewer({super.key, required this.currentUser});
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    PostController controller = Get.find<PostController>();
    print('tamanho do controller ${controller.length}');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.length,
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
                    child: FutureBuilder<String>(
                      future: controller
                          .getById(index + 1)
                          .then((post) => post.imagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            // Tratar erro, se necessário
                            print(index + 1);
                            return Text('Erro: ${snapshot.error}');
                          }
                          String imagePath = snapshot.data!;
                          return Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          );
                        } else {
                          // Pode mostrar um indicador de carregamento aqui, se necessário
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  UserController uc = Get.find<UserController>();

                  List<Map>? maps = [];
                  List<Post> posts = [];

                  User otherUser = (await controller.getById(index + 1)).user;

                  if (otherUser.id != currentUser.id) {
                    maps = await controller.getAllByUserID(otherUser.id!);

                    if (maps != null) {
                      for (Map map in maps) {
                        if (otherUser.id == map['fk_profile']) {
                          posts.add(Post(
                            id: map['id'],
                            imagePath: map['photo'],
                            user: otherUser,
                            likes: map['likes'],
                          ));
                        }
                      }
                    }

                    Get.to(() => ProfileScreen(
                          currentUser: currentUser,
                          posts: posts,
                          otherUser: otherUser,
                        ));
                  } else {
                    maps = await controller.getAllByUserID(currentUser.id!);

                    if (maps != null) {
                      for (Map map in maps) {
                        if (currentUser.id == map['fk_profile']) {
                          posts.add(Post(
                            id: map['id'],
                            imagePath: map['photo'],
                            user: currentUser,
                            likes: map['likes'],
                          ));
                        }
                      }
                    }

                    Get.to(() => ProfileScreen(
                          currentUser: currentUser,
                          posts: posts,
                        ));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                  width: 250,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: FutureBuilder<String>(
                          future: controller
                              .getById(index + 1)
                              .then((post) => post.user.profilePicture),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                // Tratar erro, se necessário
                                return Text('Erro: ${snapshot.error}');
                              }

                              if (snapshot.data == '') {
                                return Container(
                                  color: Colors.blueGrey.shade500,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                );
                              }

                              String profilePicture = snapshot.data!;
                              return Image.file(
                                File(profilePicture),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              );
                            } else {
                              // Pode mostrar um indicador de carregamento aqui, se necessário
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: FutureBuilder<String>(
                          future: controller
                              .getById(index + 1)
                              .then((post) => post.user.userName),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                // Tratar erro, se necessário
                                return Text('Erro: ${snapshot.error}');
                              }
                              String userName = snapshot.data!;

                              return Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              );
                            } else {
                              // Pode mostrar um indicador de carregamento aqui, se necessário
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
