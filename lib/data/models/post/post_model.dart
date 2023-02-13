import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';

class PostModel extends PostEntity {
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
  final List<String>? savedPosts;

  PostModel({
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
    this.communicationLink,
    this.details,
    this.phoneNo1,
    this.phoneNo2,
    this.savedPosts,
  }) : super(
          communicationLink: communicationLink,
          createAt: createAt,
          creatorUid: creatorUid,
          description: description,
          details: details,
          likes: likes,
          phoneNo1: phoneNo1,
          phoneNo2: phoneNo2,
          postId: postId,
          postImageUrl: postImageUrl,
          totalComments: totalComments,
          totalLikes: totalLikes,
          userName: userName,
          userProfileUrl: userProfileUrl,
          savedPosts: savedPosts,
        );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      communicationLink: snapshot['communicationLink'],
      likes: List.from(snap.get("likes")),
      savedPosts: List.from(snap.get("savedPosts")),
      createAt: snapshot['createAt'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      details: snapshot['details'],
      phoneNo1: snapshot['phoneNo1'],
      phoneNo2: snapshot['phoneNo2'],
      postId: snapshot['postId'],
      postImageUrl: snapshot['postImageUrl'],
      totalComments: snapshot['totalComments'],
      totalLikes: snapshot['totalLikes'],
      userName: snapshot['userName'],
      userProfileUrl: snapshot['userProfileUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "creatorUid": creatorUid,
        "description": description,
        "details": details,
        "phoneNo1": phoneNo1,
        "phoneNo2": phoneNo2,
        "postId": postId,
        "postImageUrl": postImageUrl,
        "totalComments": totalComments,
        "totalLikes": totalLikes,
        "userName": userName,
        "userProfileUrl": userProfileUrl,
        "communicationLink": communicationLink,
        "likes": likes,
        "savedPosts": savedPosts,
      };
}
