import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/app_entity.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/on_generate_route.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_cubit.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_states.dart';
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_states.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/widgets/single_comment_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../consts.dart';
import '../../../../../../domin/entities/user/user_entity.dart';

import 'package:shoghlak/injection_container.dart' as di;

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const CommentMainWidget({Key? key, required this.appEntity})
      : super(key: key);

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);

    BlocProvider.of<GetSinglePostCubit>(context).getSinglePost(postId: widget.appEntity.postId!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);


    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Comments"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserStates>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singleUser = singleUserState.user;
            return BlocBuilder<GetSinglePostCubit, GetSinglePostStates>(
              builder: (context, singlePostState) {
                if (singlePostState is GetSinglePostLoaded) {
                  final singlePost = singlePostState.post;
                  return BlocBuilder<CommentCubit, CommentStates>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ContainerWidget(
                                        width: 40,
                                        height: 40,
                                        widget: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: ProfileWidget(imageUrl: singlePost.userProfileUrl)),
                                      ),
                                      sizeHor(10),
                                      TextWidget(
                                        txt: singlePost.userName,
                                        fontsize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  sizeVer(10),
                                  TextWidget(
                                    txt: singlePost.description, 
                                  ),
                                ],
                              ),
                            ),
                            sizeVer(10),
                            const Divider(color: secondaryColor),
                            sizeVer(10),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  if (commentState.comments.isEmpty) {
                                    return const Center(
                                        child: TextWidget(
                                            txt: "No Comments yet",
                                            color: primaryColor));
                                  }
                                  final singelComment =
                                      commentState.comments[index];
                                  return BlocProvider(
                                    create: (context) => di.sl<ReplyCubit>(),
                                    child: SingleCommentWidget(
                                      comment: singelComment,
                                      onLongPressListener: () {
                                        _openBottomModalSheet(
                                            context: context,
                                            comment:
                                                commentState.comments[index]);
                                      },
                                      currentUser: singleUser,
                                    ),
                                  );
                                },
                                itemCount: commentState.comments.length,
                              ),
                            ),
                            _commentSection(currentUser: singleUser),
                          ],
                        );
                      }
                      return const CircularProgressIndicatorWidget();
                    },
                  );
                }
                if (singlePostState is GetSinglePostLoading) {
                  return const CircularProgressIndicatorWidget();
                }
                return const CircularProgressIndicatorWidget();
              },
            );
          }
          return const CircularProgressIndicatorWidget();
        },
      ),
    );
  }

  _openBottomModalSheet(
      {required BuildContext context, required CommentEntity comment}) {
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
                        _deleteComment(
                            commentID: comment.commentId!,
                            postID: comment.postId!);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextWidget(
                          txt: "Delete Comment",
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
                                  context, ScreenName.editCommentScreen,
                                  arguments: comment)
                              .then((value) => setState(() {}));
                        },
                        child: const TextWidget(
                          txt: "Update Comment",
                          fontWeight: FontWeight.w500,
                          fontsize: 16,
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

  _deleteComment({required String commentID, required String postID}) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
        comment: CommentEntity(commentId: commentID, postId: postID));
  }

  _commentSection({required UserEntity currentUser}) {
    return ContainerWidget(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            ContainerWidget(
              width: 40,
              height: 40,
              widget: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ProfileWidget(imageUrl: currentUser.profileUrl)),
            ),
            sizeHor(10),
            Expanded(
                child: TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              style: const TextStyle(color: primaryColor),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Post your comment...",
                  hintStyle: TextStyle(color: secondaryColor)),
            )),
            GestureDetector(
              onTap: () {
                _createComment(currentUser: currentUser);
              },
              child: const TextWidget(
                txt: "Post",
                fontsize: 15,
                color: blueColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  _createComment({required UserEntity currentUser}) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
          comment: CommentEntity(
            commentId: const Uuid().v1(),
            createAt: Timestamp.now(),
            description: _descriptionController.text,
            likes: const [],
            totalReplies: 0,
            userName: currentUser.username,
            userProfileUrl: currentUser.profileUrl,
            creatorUid: currentUser.uid,
            postId: widget.appEntity.postId,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _descriptionController.clear();
    });
  }
}
