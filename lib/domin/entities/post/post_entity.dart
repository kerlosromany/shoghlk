import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? creatorUid;
  final String? postImageUrl;
  final String? userProfileUrl;
  final String? description;
  final num? totalLikes;
  final List<String>? likes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userName;
  final String? details;
  final String? phoneNo1;
  final String? phoneNo2;
  final String? communicationLink;

  PostEntity({
    this.postId,
    this.creatorUid,
    this.postImageUrl,
    this.userProfileUrl,
    this.description,
    this.totalLikes,
    this.likes,
    this.totalComments,
    this.createAt,
    this.userName,
    this.details,
    this.phoneNo1,
    this.phoneNo2,
    this.communicationLink,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        postId,
        creatorUid,
        postImageUrl,
        userProfileUrl,
        description,
        totalLikes,
        likes,
        totalComments,
        createAt,
        userName,
        details,
        phoneNo1,
        phoneNo2,
        communicationLink,
      ];
}
