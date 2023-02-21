// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:shoghlak/injection_container.dart' as di;
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_states.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/loading/post_loading_widget.dart';

import '../../../../../consts.dart';
import '../../../../../domin/entities/app_entity.dart';
import '../../../../../domin/entities/post/post_entity.dart';
import '../../../../../domin/use_cases/user/get_current_uid_usecase.dart';
import '../../../../../on_generate_route.dart';
import '../../../../cubits/post/post_cubit.dart';
import '../../../../widgets/container_widget.dart';
import '../../../../widgets/icon_widget.dart';
import '../../../../widgets/text_widget.dart';
import '../../profile/widgets/profile_widget.dart';

class SinglePostMainWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostMainWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<SinglePostMainWidget> createState() => _SinglePostMainWidgetState();
}

class _SinglePostMainWidgetState extends State<SinglePostMainWidget> {
  String _currentUid = "";
  bool isDeleted = false;

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.post.postId!);

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
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const TextWidget(txt: "Post Details"),
        backgroundColor: backGroundColor,
      ),
      body: isDeleted
          ? const Center(child: TextWidget(txt: "Element deleted succefully"))
          : BlocBuilder<GetSinglePostCubit, GetSinglePostStates>(
              builder: (context, getSinglePostState) {
                if (getSinglePostState is GetSinglePostLoaded) {
                  final singlePost = getSinglePostState.post;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(0.038 * screenWidth),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ContainerWidget(
                                              width: 0.13 * screenWidth,
                                              height: 0.06 * screenHeight,
                                              borderColor: backGroundColor
                                                  .withOpacity(0.2),
                                              widget: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: ProfileWidget(
                                                    imageUrl: singlePost
                                                        .userProfileUrl),
                                              ),
                                            ),
                                            sizeHor(0.0255 * screenWidth),
                                            TextWidget(
                                              txt: "${singlePost.userName}",
                                            ),
                                          ],
                                        ),
                                        singlePost.creatorUid == _currentUid
                                            ? GestureDetector(
                                                onTap: () {
                                                  _openBottomModalSheet(
                                                      context,
                                                      screenHeight,
                                                      screenWidth);
                                                },
                                                child: const IconWidget(
                                                    icon: Icons.more_vert,
                                                    color: primaryColor),
                                              )
                                            : const TextWidget(txt: ""),
                                      ],
                                    ),
                                    sizeVer(0.024 * screenHeight),
                                    if (singlePost.postImageUrl != "" &&
                                        singlePost.postImageUrl != null)
                                      ContainerWidget(
                                        width: double.infinity,
                                        widget: ProfileWidget(
                                            imageUrl: singlePost.postImageUrl),
                                      ),
                                    sizeVer(0.0145 * screenHeight),
                                    TextWidget(
                                        txt: "${singlePost.description}"),
                                    sizeVer(0.0145 * screenHeight),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          ScreenName.postDetailsScreen,
                                          arguments: singlePost,
                                        );
                                      },
                                      child: ContainerWidget(
                                        height: 0.06 * screenHeight,
                                        width: double.infinity,
                                        borderWidth: 2,
                                        borderColor:
                                            secondaryColor.withOpacity(0.3),
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const TextWidget(txt: "Details"),
                                            Row(
                                              children: const [
                                                IconWidget(
                                                    icon: Icons
                                                        .arrow_forward_ios_sharp),
                                                IconWidget(
                                                    icon: Icons
                                                        .arrow_forward_ios_sharp),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    sizeVer(0.018 * screenHeight),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: _likePost,
                                              child: IconWidget(
                                                  size: 35,
                                                  icon: (singlePost.likes!
                                                          .contains(
                                                              _currentUid))
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                                  color: (singlePost.likes!
                                                          .contains(
                                                              _currentUid))
                                                      ? redColor
                                                      : primaryColor),
                                            ),
                                            sizeHor(0.038 * screenWidth),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    ScreenName.commentsScreen,
                                                    arguments: AppEntity(
                                                      uid: _currentUid,
                                                      postId: singlePost.postId,
                                                    ));
                                              },
                                              child: const IconWidget(
                                                  size: 35,
                                                  icon: Icons
                                                      .comment_bank_outlined,
                                                  color: primaryColor),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: _savePost,
                                          child: IconWidget(
                                            size: 35,
                                            icon: (widget.post.savedPosts!
                                                    .contains(_currentUid))
                                                ? Icons.bookmark
                                                : Icons
                                                    .bookmark_border_outlined,
                                            color: (widget.post.savedPosts!
                                                    .contains(_currentUid))
                                                ? blueColor
                                                : primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    sizeVer(0.012 * screenHeight),
                                    TextWidget(
                                        txt: "${singlePost.totalLikes} Likes",
                                        color: primaryColor.withOpacity(0.8)),
                                    sizeVer(0.012 * screenHeight),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          ScreenName.commentsScreen,
                                          arguments: AppEntity(
                                            uid: _currentUid,
                                            postId: singlePost.postId,
                                          ),
                                        );
                                      },
                                      child: TextWidget(
                                          txt:
                                              "view all ${singlePost.totalComments} comments",
                                          color: primaryColor.withOpacity(0.8)),
                                    ),
                                    sizeVer(0.012 * screenHeight),
                                    TextWidget(
                                        txt: DateFormat.yMMMd().format(
                                            singlePost.createAt!.toDate()),
                                        color: primaryColor.withOpacity(0.8)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const PostLoadingWidget();
              },
            ),
    );
  }

  _savePost() {
    BlocProvider.of<PostCubit>(context).savePost(
      post: PostEntity(postId: widget.post.postId),
    );
  }

  _openBottomModalSheet(
      BuildContext context, double screenHeight, double screenWidth) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // height: 0.18 * screenHeight,
            decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0.0255 * screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.0255 * screenWidth),
                      child: const TextWidget(
                        txt: "More Options",
                        fontWeight: FontWeight.bold,
                        fontsize: 18,
                      ),
                    ),
                    sizeVer(0.0121 * screenHeight),
                    const Divider(thickness: 1, color: secondaryColor),
                    sizeVer(0.0121 * screenHeight),
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
                    sizeVer(0.0121 * screenHeight),
                    const Divider(thickness: 1, color: secondaryColor),
                    sizeVer(0.0121 * screenHeight),
                    Padding(
                      padding: EdgeInsets.only(left: 0.0255 * screenWidth),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ScreenName.updatePostScreen,
                            arguments: widget.post,
                          );
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
        .deletePost(post: PostEntity(postId: widget.post.postId))
        .then((value) {
      setState(() {
        isDeleted = true;
      });
      Navigator.pop(context);
    });
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
      post: PostEntity(postId: widget.post.postId),
    );
  }
}
