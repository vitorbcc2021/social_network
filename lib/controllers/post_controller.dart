import 'package:social_network/repositories/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostController extends GetxController {
  late PostRepository _repository;
  late int length;

  PostController({required PostRepository repository}) {
    _repository = repository;
    length = 0;
    // addPost(Post(
    //   imagePath: 'assets/images/furinateste.jpg',
    //   user: User(
    //     id: 1,
    //     userName: 'Furina',
    //     email: 'a',
    //   ),
    // ));
    // addPost(
    //   Post(
    //     //imagePath: 'assets/images/furinateste.jpg', user: 'Furina', id: 1));
    //     imagePath: 'assets/images/fontaineteste.jpg',
    //     user: User(
    //       id: 2,
    //       userName: 'Furina2',
    //       email: 'b',
    //       profilePicture: 'assets/images/fontaineteste.jpg',
    //     ),
    //   ),
    // );
  }

  void addPost(Post post) {
    _repository.addPost(post);
    length += 1;
    update();
  }

  void removePost(Post post) {
    _repository.delete(post);
    length -= 1;
    update();
  }

  void removeById(int id) {
    _repository.deleteById(id);
    length -= 1;
    update();
  }

  Future<List<Post>> getAllPosts() {
    return _repository.getAllPosts();
  }

  Future<List<Map>?> getAllByUserID(int userID) {
    return _repository.getAllByUserID(userID);
  }

  Future<Post> getById(int id) {
    return _repository.getById(id);
  }

  void edit(Post oldPost, Post newPost) {
    _repository.update(oldPost, newPost);
    update();
  }
}
