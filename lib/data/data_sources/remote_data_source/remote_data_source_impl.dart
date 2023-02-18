import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:shoghlak/data/models/post/post_model.dart';
import 'package:shoghlak/data/models/reply/reply_model.dart';
import 'package:shoghlak/data/models/user/user_model.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:uuid/uuid.dart';

import '../../models/comment/comment_model.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.firebaseStorage});

  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConsts.users);
    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        bio: user.bio,
        email: user.email,
        followers: user.followers,
        following: user.following,
        name: user.name,
        profileUrl: profileUrl,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
        username: user.username,
        website: user.website,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      print("some errors happened while creating user${error.toString()}");
      toast("some errors happened while creating user${error.toString()}");
    });
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConsts.users);
    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        bio: user.bio,
        email: user.email,
        followers: user.followers,
        following: user.following,
        name: user.name,
        profileUrl: user.profileUrl,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
        username: user.username,
        website: user.website,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      print("some errors happened while creating user${error.toString()}");
      toast("some errors happened while creating user${error.toString()}");
    });
  }

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConsts.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConsts.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty && user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        toast("Fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("user not found");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      } else {
        toast(e.code);
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty &&
          user.password!.isNotEmpty &&
          user.confirmPassword!.isNotEmpty) {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: user.email!, password: user.password!)
            .then((value) {
          if (value.user?.uid != null) {
            if (user.imageFile != null) {
              uploadImageToStorage(user.imageFile, false,
                      FirebaseStorageConsts.profileImages)
                  .then((profileUrl) {
                createUserWithImage(user, profileUrl);
              });
            } else {
              createUserWithImage(user, "");
            }
          }
        });
      } else {
        toast("Fields cannot be empty");
      }
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("Email is already taken");
      } else if (e.code == "invalid-email") {
        toast(
            "Invalid email \n email must be written in a right way (example@gmail.com)");
      } else {
        toast(e.code);
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConsts.users);
    Map<String, dynamic> userInfo = {};
    if (user.bio != "" && user.bio != null) {
      userInfo["bio"] = user.bio;
    }
    if (user.website != "" && user.website != null) {
      userInfo["website"] = user.website;
    }
    if (user.profileUrl != "" && user.profileUrl != null) {
      userInfo["profileUrl"] = user.profileUrl;
    }
    if (user.username != "" && user.username != null) {
      userInfo["username"] = user.username;
    }
    if (user.name != "" && user.name != null) {
      userInfo["name"] = user.name;
    }
    if (user.totalFollowers != null) {
      userInfo["totalFollowers"] = user.totalFollowers;
    }
    if (user.totalFollowing != null) {
      userInfo["totalFollowing"] = user.totalFollowing;
    }
    if (user.totalPosts != null) {
      userInfo["totalPosts"] = user.totalPosts;
    }
    userCollection.doc(user.uid).update(userInfo);
  }

  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    final uploadTask = ref.putFile(file!);
    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConsts.posts);
    final newPost = PostModel(
      communicationLink: post.communicationLink,
      createAt: post.createAt,
      creatorUid: post.creatorUid,
      description: post.description,
      details: post.details,
      likes: const [],
      savedPosts: const [],
      phoneNo1: post.phoneNo1,
      phoneNo2: post.phoneNo2,
      postId: post.postId,
      postImageUrl: post.postImageUrl,
      totalComments: 0,
      totalLikes: 0,
      userName: post.userName,
      userProfileUrl: post.userProfileUrl,
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();
      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConsts.users)
              .doc(post.creatorUid);
          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get("totalPosts");
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      print("some errors occured while creating post $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConsts.posts);
    try {
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore
            .collection(FirebaseConsts.users)
            .doc(post.creatorUid);
        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get("totalPosts");
            userCollection.update({"totalPosts": totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some errors occured while deleting post $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConsts.posts);
    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();
    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1,
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1,
        });
      }
    }
  }

  @override
  Future<void> savePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConsts.posts);
    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();
    if (postRef.exists) {
      List savedPosts = postRef.get("savedPosts");
      if (savedPosts.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "savedPosts": FieldValue.arrayRemove([currentUid]),
        });
      } else {
        postCollection.doc(post.postId).update({
          "savedPosts": FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConsts.posts);
    Map<String, dynamic> postInfo = {};

    if (post.description != "" && post.description != null) {
      postInfo['description'] = post.description;
    }
    if (post.postImageUrl != "" && post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
    }
    if (post.details != "" && post.details != null) {
      postInfo['details'] = post.details;
    }
    if (post.phoneNo1 != "" && post.phoneNo1 != null) {
      postInfo['phoneNo1'] = post.phoneNo1;
    }
    if (post.phoneNo2 != "" && post.phoneNo2 != null) {
      postInfo['phoneNo2'] = post.phoneNo2;
    }
    if (post.communicationLink != "" && post.communicationLink != null) {
      postInfo['communicationLink'] = post.communicationLink;
    }

    postCollection.doc(post.postId).update(postInfo);
  }

  // comments

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(comment.postId)
        .collection(FirebaseConsts.comments);

    final newComment = CommentModel(
      createAt: comment.createAt,
      creatorUid: comment.creatorUid,
      description: comment.description,
      likes: const [],
      commentId: comment.commentId,
      userName: comment.userName,
      userProfileUrl: comment.userProfileUrl,
      postId: comment.postId,
      totalReplies: comment.totalReplies,
    ).toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();
      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final post = firebaseFirestore
              .collection(FirebaseConsts.posts)
              .doc(comment.postId);
          post.get().then((value) {
            if (value.exists) {
              final totalComments = value.get("totalComments");
              post.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      print("some errors occured while creating comment $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(comment.postId)
        .collection(FirebaseConsts.comments);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final post = firebaseFirestore
            .collection(FirebaseConsts.posts)
            .doc(comment.postId);
        post.get().then((value) {
          if (value.exists) {
            final totalComments = value.get("totalComments");
            post.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some errors occured while deleting comment $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(comment.postId)
        .collection(FirebaseConsts.comments);

    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();
    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(postId)
        .collection(FirebaseConsts.comments)
        .orderBy("createAt", descending: true);

    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(comment.postId)
        .collection(FirebaseConsts.comments);

    Map<String, dynamic> commentInfo = {};
    if (comment.description != "" && comment.description != null) {
      commentInfo['description'] = comment.description;
    }
    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  // reply

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(reply.postId)
        .collection(FirebaseConsts.comments)
        .doc(reply.commentId)
        .collection(FirebaseConsts.replies);

    final newReply = ReplyModel(
      createAt: reply.createAt,
      creatorUid: reply.creatorUid,
      description: reply.description,
      commentId: reply.commentId,
      userName: reply.userName,
      userProfileUrl: reply.userProfileUrl,
      postId: reply.postId,
      replyId: reply.replyId,
    ).toJson();

    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();
      if (!replyDocRef.exists) {
        replyCollection.doc(reply.replyId).set(newReply).then((value) {
          final comment = firebaseFirestore
              .collection(FirebaseConsts.posts)
              .doc(reply.postId)
              .collection(FirebaseConsts.comments)
              .doc(reply.commentId);
          comment.get().then((value) {
            if (value.exists) {
              final totalReplys = value.get("totalReplies");
              comment.update({"totalReplies": totalReplys + 1});
              return;
            }
          });
        });
      } else {
        replyCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      print("some errors occured while creating reply $e");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(reply.postId)
        .collection(FirebaseConsts.comments)
        .doc(reply.commentId)
        .collection(FirebaseConsts.replies);

    try {
      replyCollection.doc(reply.replyId).delete().then((value) {
        final comment = firebaseFirestore
            .collection(FirebaseConsts.posts)
            .doc(reply.postId)
            .collection(FirebaseConsts.comments)
            .doc(reply.commentId);
        comment.get().then((value) {
          if (value.exists) {
            final totalReplys = value.get("totalReplies");
            comment.update({"totalReplies": totalReplys - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some errors occured while deleting reply $e");
    }
  }

  @override
  Stream<List<ReplyEntity>> readReplys(ReplyEntity reply) {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(reply.postId)
        .collection(FirebaseConsts.comments)
        .doc(reply.commentId)
        .collection(FirebaseConsts.replies);

    return replyCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConsts.posts)
        .doc(reply.postId)
        .collection(FirebaseConsts.comments)
        .doc(reply.commentId)
        .collection(FirebaseConsts.replies);

    Map<String, dynamic> replyInfo = {};
    if (reply.description != "" && reply.description != null) {
      replyInfo['description'] = reply.description;
    }
    replyCollection.doc(reply.replyId).update(replyInfo);
  }
}
