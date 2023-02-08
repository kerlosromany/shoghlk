import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? name;
  final String? bio;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;

  // will not going to store in DB
  final String? password;
  final String? confirmPassword;
  final String? otherUid;

  UserModel({
    this.uid,
    this.username,
    this.name,
    this.bio,
    this.website,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.password,
    this.otherUid,
    this.totalPosts,
    this.confirmPassword,
  }) : super(
          bio: bio,
          email: email,
          followers: followers,
          following: following,
          name: name,
          otherUid: otherUid,
          password: password,
          profileUrl: profileUrl,
          totalFollowers: totalFollowers,
          totalFollowing: totalFollowing,
          uid: uid,
          username: username,
          website: website,
          totalPosts: totalPosts,
          confirmPassword: confirmPassword,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      bio: snapshot['bio'],
      email: snapshot['email'],
      followers: List.from(snap.get("followers")),
      following: List.from(snap.get("following")),
      name: snapshot['name'],
      profileUrl: snapshot['profileUrl'],
      totalFollowers: snapshot['totalFollowers'],
      totalFollowing: snapshot['totalFollowing'],
      totalPosts: snapshot['totalPosts'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      website: snapshot['website'],
    );
  }

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "email": email,
        "followers": followers,
        "following": following, 
        "name": name,
        "profileUrl": profileUrl,
        "totalFollowers": totalFollowers,
        "totalFollowing": totalFollowing,
        "totalPosts": totalPosts,
        "uid": uid,
        "username": username,
        "website": website,
      };
}
