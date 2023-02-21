import 'package:flutter/material.dart';
import 'package:shoghlak/domin/entities/app_entity.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:shoghlak/presentation/pages/credentials/sign_in_page.dart';
import 'package:shoghlak/presentation/pages/credentials/sign_up_page.dart';
import 'package:shoghlak/presentation/pages/main_screens/home/post_details_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/comments_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/edit_comment_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/edit_reply_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/update_post_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/edit_profile_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/single_post_details_screen.dart';


class ScreenName {
  static const String editProfileScreen = 'editProfileScreen';
  static const String updatePostScreen = 'UpdatePostScreen';
  static const String commentsScreen = 'CommentsScreen';
  static const String signInScreen = 'SignInScreen';
  static const String signUpScreen = 'SignUpScreen';
  static const String postDetailsScreen = 'postDetailsScreen';
  static const String editCommentScreen = 'EditCommentScreen';
  static const String editReplyScreen = 'EditReplyScreen';
  static const String singlePostDetailsScreen = 'SinglePostDetailsScreen';
  static const String singleUserProfileScreen = 'singleUserProfileScreen';
}

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case ScreenName.editProfileScreen:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfileScreen(currentUser: args));
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      case ScreenName.editCommentScreen:
        {
          if (args is CommentEntity) {
            return routeBuilder(EditCommentScreen(comment: args));
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      case ScreenName.editReplyScreen:
        {
          if (args is ReplyEntity) {
            return routeBuilder(EditReplyScreen(reply: args));
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      case ScreenName.commentsScreen:
        {
          if (args is AppEntity) {
            return routeBuilder(
              CommentScreen(appEntity: args),
            );
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      case ScreenName.signInScreen:
        return routeBuilder(const SignInPage());
      case ScreenName.signUpScreen:
        return routeBuilder(const SignUpPage());

      case ScreenName.updatePostScreen:
        {
          if (args is PostEntity) {
            return routeBuilder(UpdatePostScreen(post: args));
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      case ScreenName.postDetailsScreen:
        {
          if (args is PostEntity) {
            return routeBuilder(PostDetailsScreen(post: args));
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      case ScreenName.singlePostDetailsScreen:
        {
          if (args is PostEntity) {
            return routeBuilder(SinglePostDetailsScreen(post: args));
          } else {
            return routeBuilder(const NoFoundScreen());
          }
        }

      // case ScreenName.singleUserProfileScreen:
      //   {
      //     if (args is String) {
      //       return routeBuilder(SingleUserProfileScreen(otherUserId: args));
      //     } else {
      //       return routeBuilder(const NoFoundScreen());
      //     }
      //   }

      default:
        return routeBuilder(const NoFoundScreen());
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoFoundScreen extends StatelessWidget {
  const NoFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Page Found"),
      ),
    );
  }
}
