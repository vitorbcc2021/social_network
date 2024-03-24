import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../controllers/user_controller.dart';
import '../models/post.dart';
import 'generic_repository.dart';
import 'package:social_network/repositories/database_helper.dart';

class PostRepository extends GenericRepository<Post> {
  final DatabaseHelper _helper = DatabaseHelper();

  @override
  Future<Post> getById(int id) async {
    Database? db = await _helper.db;
    UserController uc = Get.find<UserController>();

    List<Map> query = await db!.query('post',
        columns: ['id', 'fk_profile', 'photo', 'likes'],
        where: 'id == ?',
        whereArgs: [id]);

    Post post = Post(
      id: query[0]['id'],
      imagePath: query[0]['photo'],
      user: (await uc.getById(query[0]['fk_profile'])!)!,
      likes: query[0]['likes'],
    );

    return post;
  }

  void addPost(Post post) async {
    final Database? db = await _helper.db;

    Post? p = await _helper.save(post);
    add(p!);
  }

  Future<List<Map>?> getAllByUserID(int userID) async {
    Database? db = await _helper.db;

    List<Map> query =
        await db!.query('post', where: 'fk_profile == ?', whereArgs: [userID]);
    if (query.isNotEmpty) {
      return query;
    } else {
      return null;
    }
  }

  Future<List<Post>> getAllPosts() async {
    Database? db = await _helper.db;
    UserController uc = Get.find<UserController>();

    List<Map> query = await db!.query('post');

    List<Post> posts = [];

    for (Map map in query) {
      posts.add(Post(
        id: map['id'],
        user: (await uc.getById(map['fk_profile']))!,
        imagePath: map['photo'],
        likes: map['likes'],
      ));
    }

    return posts;
  }
}
