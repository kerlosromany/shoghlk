import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';

class ReplyModel extends ReplyEntity {
  final String? creatorUid;
  final String? postId;
  final String? commentId;
  final String? replyId;
  final String? description;
  final String? userName;
  final String? userProfileUrl;
  final Timestamp? createAt;

  ReplyModel({
    this.creatorUid,
    this.postId,
    this.commentId,
    this.replyId,
    this.description,
    this.userName,
    this.userProfileUrl,
    this.createAt,
  }) : super(
          commentId: commentId,
          createAt: createAt,
          creatorUid: creatorUid,
          description: description,
          postId: postId,
          replyId: replyId,
          userName: userName,
          userProfileUrl: userProfileUrl,
        );

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return ReplyModel(
      createAt: snapshot['createAt'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      userName: snapshot['userName'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      replyId: snapshot['replyId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "creatorUid": creatorUid,
        "description": description,
        "postId": postId,
        "userName": userName,
        "userProfileUrl": userProfileUrl,
        "commentId": commentId,
        "replyId": replyId,
      };
}
