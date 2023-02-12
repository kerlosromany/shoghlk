

import 'dart:io';

import '../../../domin/entities/comment/comment_entity.dart';
import '../../../domin/entities/post/post_entity.dart';
import '../../../domin/entities/reply/reply.dart';
import '../../../domin/entities/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  // Credential
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);

  // cloud storage
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName);

  // Post Features
  Future<void> createPost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> likePost(PostEntity post);

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> updateComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> likeComment(CommentEntity comment);

  // Reply Features
  Future<void> createReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReplys(ReplyEntity reply);
}