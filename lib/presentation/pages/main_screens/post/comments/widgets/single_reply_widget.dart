import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';

import '../../../../../../consts.dart';
import '../../../../../../domin/use_cases/user/get_current_uid_usecase.dart';
import '../../../../../widgets/container_widget.dart';
import 'package:shoghlak/injection_container.dart' as di;
import '../../../../../widgets/text_widget.dart';
import '../../../profile/widgets/profile_widget.dart';

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final VoidCallback? onLongPressListener;
  const SingleReplyWidget(
      {super.key, required this.reply, this.onLongPressListener});

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  String _currentUid = "";
  @override
  void initState() {
    // TODO: implement initState

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
    return InkWell(
      onLongPress: widget.reply.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: ContainerWidget(
        margin: EdgeInsets.only(
            left: 0.0255 * screenWidth, top: 0.0255 * screenWidth),
        widget: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerWidget(
              width: 0.1 * screenWidth,
              height: 0.048 * screenHeight,
              widget: ClipRRect(
                  borderRadius: BorderRadius.circular(0.1 * screenWidth),
                  child: ProfileWidget(
                    imageUrl: "${widget.reply.userProfileUrl}",
                  )),
            ),
            sizeHor(0.0255 * screenWidth),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0.0255 * screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          txt: "${widget.reply.userName}",
                          fontsize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    sizeVer(4),
                    TextWidget(
                      txt: "${widget.reply.description}",
                    ),
                    sizeVer(4),
                    TextWidget(
                      txt: DateFormat.yMMMMd()
                          .format(widget.reply.createAt!.toDate()),
                      fontsize: 12,
                      color: darkGreyColor,
                    ),
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
