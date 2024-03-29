import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_cubit.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/widgets/single_reply_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/widgets/form_widget.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../consts.dart';
import '../../../../../../domin/entities/comment/comment_entity.dart';
import '../../../../../../domin/use_cases/user/get_current_uid_usecase.dart';
import '../../../../../../on_generate_route.dart';
import 'package:intl/intl.dart';

import '../../../profile/widgets/profile_widget.dart';
import 'package:shoghlak/injection_container.dart' as di;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final UserEntity? currentUser;
  const SingleCommentWidget(
      {super.key,
      required this.comment,
      this.onLongPressListener,
      this.currentUser});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String _currentUid = "";

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ReplyCubit>(context).getReplys(
        reply: ReplyEntity(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId));

    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isUserReplaying = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: ContainerWidget(
        margin: EdgeInsets.symmetric(horizontal: 0.0255 * screenWidth),
        widget: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerWidget(
              width: 0.1 * screenWidth,
              height: 0.048 * screenHeight,
              widget: ClipRRect(
                  borderRadius: BorderRadius.circular(0.1 * screenWidth),
                  child: ProfileWidget(
                    imageUrl: "${widget.comment.userProfileUrl}",
                  )),
            ),
            sizeHor(0.0255 * screenWidth),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0.02 * screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          txt: "${widget.comment.userName}",
                          fontsize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    sizeVer(4),
                    TextWidget(
                      txt: "${widget.comment.description}",
                    ),
                    sizeVer(4),
                    Padding(
                      padding: EdgeInsets.only(top: 0.025 * screenWidth),
                      child: FittedBox(
                        child: Row(
                          children: [
                            TextWidget(
                              txt: DateFormat.yMMMMd()
                                  .format(widget.comment.createAt!.toDate()),
                              fontsize: 12,
                              color: darkGreyColor,
                            ),
                            sizeHor(0.038 * screenWidth),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isUserReplaying = !_isUserReplaying;
                                  });
                                },
                                child: const TextWidget(
                                  txt: "Replay",
                                  color: darkGreyColor,
                                  fontsize: 12,
                                )),
                            sizeHor(0.038 * screenWidth),
                            GestureDetector(
                              onTap: () {
                                widget.comment.totalReplies == 0
                                    ? toast("No Replys")
                                    : BlocProvider.of<ReplyCubit>(context)
                                        .getReplys(
                                            reply: ReplyEntity(
                                                postId: widget.comment.postId,
                                                commentId:
                                                    widget.comment.commentId));
                              },
                              child: const TextWidget(
                                txt: "View Replays",
                                fontsize: 12,
                                color: darkGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<ReplyCubit, ReplyStates>(
                      builder: (context, replyState) {
                        if (replyState is ReplyLoaded) {
                          final replys = replyState.replys;
                          if (replys.isEmpty) {
                            return const ContainerWidget(width: 0, height: 0);
                          }
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return SingleReplyWidget(
                                reply: replys[index],
                                onLongPressListener: () {
                                  _openBottomModalSheet(
                                      context: context, reply: replys[index]);
                                },
                              );
                            },
                            itemCount: replyState.replys.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                          );
                        }
                        if (replyState is ReplyLoading) {
                          return const ContainerWidget(width: 0, height: 0);
                        }
                        return const ContainerWidget(width: 0, height: 0);
                      },
                    ),
                    _isUserReplaying == true
                        ? sizeVer(0.0121 * screenHeight)
                        : sizeVer(0),
                    _isUserReplaying == true
                        ? Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FormWidget(
                                  title: "",
                                  controller: _descriptionController,
                                  maxLines: 5,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "write a reply to post it";
                                    }
                                    return null;
                                  },
                                ),
                                sizeVer(0.0121 * screenHeight),
                                GestureDetector(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      _createReply();
                                    }
                                  },
                                  child: const TextWidget(
                                    txt: "Post",
                                    color: blueColor,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(width: 0, height: 0)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openBottomModalSheet(
      {required BuildContext context, required ReplyEntity reply}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
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
                        _deleteReply(reply: reply);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextWidget(
                          txt: "Delete Reply",
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
                                  context, ScreenName.editReplyScreen,
                                  arguments: reply)
                              .then((value) => setState(() {}));
                        },
                        child: const TextWidget(
                          txt: "Update Reply",
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

  _deleteReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).deleteReply(
      reply: ReplyEntity(
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId,
      ),
    );
  }

  _createReply() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
          reply: ReplyEntity(
            commentId: widget.comment.commentId,
            createAt: Timestamp.now(),
            creatorUid: widget.currentUser!.uid,
            postId: widget.comment.postId,
            replyId: const Uuid().v1(),
            userName: widget.currentUser!.username,
            userProfileUrl: widget.currentUser!.profileUrl,
            description: _descriptionController.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _descriptionController.clear();
      _isUserReplaying = false;
    });
  }
}
