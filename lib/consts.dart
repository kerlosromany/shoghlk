import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backGroundColor = Color.fromRGBO(0, 0, 0, 1.0);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1);
const tealColor = Colors.tealAccent;
const redColor = Colors.red;

Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}

class FirebaseConsts {
  static const String users = "users";
  static const String posts = "posts";
  static const String comments = "comments";
  static const String replies = "replies";
}

class FirebaseStorageConsts {
  static const String profileImages = "profileImages";
  static const String postImages = "postImages";

}

void toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      backgroundColor: backGroundColor,
      textColor: blueColor,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 1);
}
