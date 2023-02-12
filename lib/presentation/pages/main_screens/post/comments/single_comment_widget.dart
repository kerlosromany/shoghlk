import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/icon_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../../../consts.dart';
import '../../../../../domin/entities/comment/comment_entity.dart';
import '../../../../widgets/form_container_widget.dart';
import 'package:intl/intl.dart';

import '../../profile/widgets/profile_widget.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  const SingleCommentWidget({super.key, required this.comment , this.onLongPressListener});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
      child: ContainerWidget(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        widget: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerWidget(
              //////
              width: 40,
              height: 40,
              widget: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ProfileWidget(
                    imageUrl: "${widget.comment.userProfileUrl}",
                  )),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    Row(
                      children: [
                        TextWidget(
                          txt: DateFormat.yMMMMd()
                              .format(widget.comment.createAt!.toDate()),
                          fontsize: 12,
                          color: darkGreyColor,
                        ),
                        sizeHor(15),
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
                        sizeHor(15),
                        const TextWidget(
                          txt: "View Replays",
                          fontsize: 12,
                          color: darkGreyColor,
                        ),
                      ],
                    ),
                    _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                    _isUserReplaying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const FormContainerWidget(
                                  hintText: "Post your replay..."),
                              sizeVer(10),
                              const TextWidget(
                                txt: "Post",
                                color: blueColor,
                              )
                            ],
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
}
