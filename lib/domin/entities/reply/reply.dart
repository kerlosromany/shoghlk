import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  // postCollection => postID => comments => commentID => replys => allReplysOfSpecificComment

  final String? creatorUid;
  final String? postId;
  final String? commentId;
  final String? replyId;
  final String? description;
  final String? userName;
  final String? userProfileUrl;
  final Timestamp? createAt;

  ReplyEntity({
    this.creatorUid,
    this.postId,
    this.commentId,
    this.replyId,
    this.description,
    this.userName,
    this.userProfileUrl,
    this.createAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        creatorUid,
        postId,
        commentId,
        replyId,
        description,
        userName,
        userProfileUrl,
        createAt,
      ];
}
