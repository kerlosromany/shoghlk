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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ContainerWidget(
                                        width: 50,
                                        height: 50,
                                        borderColor:
                                            backGroundColor.withOpacity(0.2),
                                        widget: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: ProfileWidget(
                                              imageUrl:
                                                  singlePost.userProfileUrl),
                                        ),
                                      ),
                                      sizeHor(10),
                                      TextWidget(
                                        txt: "${singlePost.userName}",
                                      ),
                                    ],
                                  ),
                                  singlePost.creatorUid == _currentUid
                                      ? GestureDetector(
                                          onTap: () {
                                            _openBottomModalSheet(context);
                                          },
                                          child: const IconWidget(
                                              icon: Icons.more_vert,
                                              color: primaryColor),
                                        )
                                      : const TextWidget(txt: ""),
                                ],
                              ),
                              sizeVer(20),
                              if (singlePost.postImageUrl != "" &&
                                  singlePost.postImageUrl != null)
                                ContainerWidget(
                                  width: double.infinity,
                                  height: 200,
                                  widget: ProfileWidget(
                                      imageUrl: singlePost.postImageUrl),
                                ),
                              sizeVer(12),
                              TextWidget(txt: "${singlePost.description}"),
                              sizeVer(12),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ScreenName.postDetailsScreen,
                                    arguments: singlePost,
                                  );
                                },
                                child: ContainerWidget(
                                  height: 50,
                                  width: double.infinity,
                                  borderWidth: 2,
                                  borderColor: secondaryColor.withOpacity(0.3),
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
                              sizeVer(15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: _likePost,
                                        child: IconWidget(
                                            icon: (singlePost.likes!
                                                    .contains(_currentUid))
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: (singlePost.likes!
                                                    .contains(_currentUid))
                                                ? redColor
                                                : primaryColor),
                                      ),
                                      sizeHor(15),
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
                                            icon: Icons.comment_bank_outlined,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  const IconWidget(
                                      icon: Icons.bookmark_border_outlined,
                                      color: primaryColor),
                                ],
                              ),
                              sizeVer(10),
                              TextWidget(
                                  txt: "${singlePost.totalLikes} Likes",
                                  color: primaryColor.withOpacity(0.8)),
                              sizeVer(5),
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
                              sizeVer(5),
                              TextWidget(
                                  txt: DateFormat.yMMMd()
                                      .format(singlePost.createAt!.toDate()),
                                  color: primaryColor.withOpacity(0.8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicatorWidget();
              },
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
