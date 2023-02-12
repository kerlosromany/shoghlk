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
  const SingleReplyWidget({super.key, required this.reply , this.onLongPressListener});

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
    return InkWell(
      onLongPress: widget.reply.creatorUid == _currentUid ? widget.onLongPressListener : null,
      child: ContainerWidget(
        margin: const EdgeInsets.only(left: 10, top: 10),
        widget: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerWidget(
              width: 40,
              height: 40,
              widget: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ProfileWidget(
                    imageUrl: "${widget.reply.userProfileUrl}",
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
