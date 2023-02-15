import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/domin/use_cases/user/get_current_uid_usecase.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/ui/ui_cubit.dart';
import 'package:shoghlak/presentation/cubits/ui/ui_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/icon_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../../../consts.dart';
import '../../../../../domin/entities/app_entity.dart';
import '../../../../../on_generate_route.dart';
import '../../../../widgets/container_widget.dart';

import 'package:shoghlak/injection_container.dart' as di;

class PostCardWidget extends StatefulWidget {
  final PostEntity post;
  const PostCardWidget({super.key, required this.post});

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(0.04 * screenWidth),
      child: Card(
        elevation: 10,
        color: backGroundColor.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(0.02 * screenWidth),
          child: ContainerWidget(
            borderColor: backGroundColor.withOpacity(0.2),
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ContainerWidget(
                          width: 0.13 * screenWidth,
                          height: 0.06 * screenHeight,
                          borderColor: backGroundColor.withOpacity(0.2),
                          widget: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(0.08 * screenWidth),
                            child: ProfileWidget(
                                imageUrl: widget.post.userProfileUrl),
                          ),
                        ),
                        sizeHor(0.026 * screenWidth),
                        TextWidget(
                          txt: "${widget.post.userName}",
                        ),
                      ],
                    ),
                    widget.post.creatorUid == _currentUid
                        ? GestureDetector(
                            onTap: () {
                              _openBottomModalSheet(
                                  context, screenHeight, screenWidth);
                            },
                            child: const IconWidget(
                                icon: Icons.more_vert, color: primaryColor),
                          )
                        : const TextWidget(txt: ""),
                  ],
                ),
                sizeVer(0.02 * screenHeight),
                if (widget.post.postImageUrl != "" &&
                    widget.post.postImageUrl != null)
                  ContainerWidget(
                    width: double.infinity,
                    widget: ProfileWidget(imageUrl: widget.post.postImageUrl),
                  ),
                sizeVer(0.015 * screenHeight),
                TextWidget(txt: "${widget.post.description}"),
                sizeVer(0.015 * screenHeight),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenName.postDetailsScreen,
                        arguments: widget.post);
                  },
                  child: ContainerWidget(
                    height: 50,
                    width: double.infinity,
                    borderWidth: 2,
                    borderColor: secondaryColor.withOpacity(0.3),
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const TextWidget(txt: "Details"),
                        Row(
                          children: const [
                            IconWidget(icon: Icons.arrow_forward_ios_sharp),
                            IconWidget(icon: Icons.arrow_forward_ios_sharp),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                sizeVer(0.018 * screenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _likePost,
                          child: IconWidget(
                            size: 35,
                            icon: (widget.post.likes!.contains(_currentUid))
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: (widget.post.likes!.contains(_currentUid))
                                ? redColor
                                : primaryColor,
                          ),
                        ),
                        sizeHor(0.038 * screenWidth),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ScreenName.commentsScreen,
                              arguments: AppEntity(
                                uid: _currentUid,
                                postId: widget.post.postId,
                              ),
                            );
                          },
                          child: const IconWidget(
                              size: 35,
                              icon: Icons.comment_bank_outlined,
                              color: primaryColor),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _savePost,
                      child: IconWidget(
                        size: 35,
                        icon: (widget.post.savedPosts!.contains(_currentUid))
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        color: (widget.post.savedPosts!.contains(_currentUid))
                            ? blueColor
                            : primaryColor,
                      ),
                    ),
                  ],
                ),
                sizeVer(0.012 * screenHeight),
                TextWidget(
                  txt: "${widget.post.totalLikes} Likes",
                  color: primaryColor.withOpacity(0.8),
                ),
                sizeVer(0.012 * screenHeight),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ScreenName.commentsScreen,
                      arguments: AppEntity(
                        uid: _currentUid,
                        postId: widget.post.postId,
                      ),
                    );
                  },
                  child: TextWidget(
                    txt: "view all ${widget.post.totalComments} comments",
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
                sizeVer(5),
                TextWidget(
                  txt: DateFormat.yMMMd().format(
                    widget.post.createAt!.toDate(),
                  ),
                  color: primaryColor.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _openBottomModalSheet(
      BuildContext context, double screenHeight, double screenWidth) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 0.18 * screenHeight,
            decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0.02 * screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.02 * screenWidth),
                      child: const Text(
                        "More Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                    sizeVer(0.0121 * screenHeight),
                    const Divider(thickness: 1, color: secondaryColor),
                    sizeVer(0.0121 * screenHeight),
                    GestureDetector(
                      onTap: () {
                        _deletePost();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.02 * screenWidth),
                        child: const TextWidget(
                          txt: "Delete Post",
                          fontWeight: FontWeight.w500,
                          fontsize: 16,
                        ),
                      ),
                    ),
                    sizeVer(0.0121 * screenHeight),
                    const Divider(thickness: 1, color: secondaryColor),
                    sizeVer(0.0121 * screenHeight),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ScreenName.updatePostScreen,
                              arguments: widget.post);
                        },
                        child: const Text(
                          "Update Post",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(0.0121 * screenHeight),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
      post: PostEntity(postId: widget.post.postId),
    );
  }

  _savePost() {
    BlocProvider.of<PostCubit>(context).savePost(
      post: PostEntity(postId: widget.post.postId),
    );
  }
}
