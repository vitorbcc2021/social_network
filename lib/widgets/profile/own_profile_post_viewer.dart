import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';

class OwnProfile extends GetView<PostController> {
  const OwnProfile({
    super.key,
    required this.currentUser,
    required this.posts,
  });

  final User currentUser;
  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: FutureBuilder<List<Post>>(
                      //Aqui e aonde é mostrado as fotos principais dos posts
                      future: controller
                          .getAllByUserID(currentUser.id!)
                          .then((maps) {
                        List<Post> posts = [];
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
                        return posts;
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          }
                          List<Post> posts = snapshot.data!;
                          if (posts.isEmpty) {
                            return const Text('Nenhuma postagem encontrada');
                          }
                          String imagePath = posts[index].imagePath;
                          return Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
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
