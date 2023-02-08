import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? userName;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final num? totalReplies;
  final List<String>? likes;

  CommentEntity({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.userName,
    this.userProfileUrl,
    this.createAt,
    this.totalReplies,
    this.likes,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        commentId,
        postId,
        creatorUid,
        description,
        userName,
        userProfileUrl,
        createAt,
        totalReplies,
        likes,
      ];
}
