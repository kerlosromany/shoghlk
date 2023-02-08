import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? userName;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final num? totalReplies;
  final List<String>? likes;

  CommentModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.userName,
    this.userProfileUrl,
    this.createAt,
    this.totalReplies,
    this.likes,
  }) : super(
          commentId: commentId,
          createAt: createAt,
          creatorUid: creatorUid,
          description: description,
          likes: likes,
          postId: postId,
          totalReplies: totalReplies,
          userName: userName,
          userProfileUrl: userProfileUrl,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      likes: List.from(snap.get("likes")),
      createAt: snapshot['createAt'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      totalReplies: snapshot['totalReplies'],
      userName: snapshot['userName'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "creatorUid": creatorUid,
        "description": description,
        "postId": postId,
        "totalReplies": totalReplies,
        "userName": userName,
        "userProfileUrl": userProfileUrl,
        "likes": likes,
        "commentId": commentId,
      };
}
