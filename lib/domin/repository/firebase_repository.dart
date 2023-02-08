import 'dart:io';

import 'package:shoghlak/domin/entities/post/post_entity.dart';

import '../entities/comment/comment_entity.dart';
import '../entities/user/user_entity.dart';

abstract class FirebaseRepository {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);

  // Cloud storage Feature
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  // Post Features
  Future<void> createPost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Future<void> likePost(PostEntity post);


  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> updateComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> likeComment(CommentEntity comment);
}
