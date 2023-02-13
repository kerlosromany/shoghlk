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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10,
        color: backGroundColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          width: 50,
                          height: 50,
                          borderColor: backGroundColor.withOpacity(0.2),
                          widget: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ProfileWidget(
                                imageUrl: widget.post.userProfileUrl),
                          ),
                        ),
                        sizeHor(10),
                        TextWidget(
                          txt: "${widget.post.userName}",
                        ),
                      ],
                    ),
                    widget.post.creatorUid == _currentUid
                        ? GestureDetector(
                            onTap: () {
                              _openBottomModalSheet(context);
                            },
                            child: const IconWidget(
                                icon: Icons.more_vert, color: primaryColor),
                          )
                        : const TextWidget(txt: ""),
                  ],
                ),
                sizeVer(20),
                if (widget.post.postImageUrl != "" &&
                    widget.post.postImageUrl != null)
                  ContainerWidget(
                    width: double.infinity,
                    widget: ProfileWidget(imageUrl: widget.post.postImageUrl),
                  ),
                sizeVer(12),
                TextWidget(txt: "${widget.post.description}"),
                sizeVer(12),
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
                sizeVer(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _likePost,
                          child: IconWidget(
                            icon: (widget.post.likes!.contains(_currentUid))
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: (widget.post.likes!.contains(_currentUid))
                                ? redColor
                                : primaryColor,
                          ),
                        ),
                        sizeHor(15),
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
                              icon: Icons.comment_bank_outlined,
                              color: primaryColor),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _savePost,
                      child: IconWidget(
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
                sizeVer(10),
                TextWidget(
                  txt: "${widget.post.totalLikes} Likes",
                  color: primaryColor.withOpacity(0.8),
                ),
                sizeVer(5),
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

  _openBottomModalSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "More Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                    sizeVer(8),
                    const Divider(thickness: 1, color: secondaryColor),
                    sizeVer(8),
                    GestureDetector(
                      onTap: () {
                        _deletePost();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextWidget(
                          txt: "Delete Post",
                          fontWeight: FontWeight.w500,
                          fontsize: 16,
                        ),
                      ),
                    ),
                    sizeVer(7),
                    const Divider(thickness: 1, color: secondaryColor),
                    sizeVer(7),
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
                    sizeVer(7),
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
