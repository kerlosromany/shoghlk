import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_cubit.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_form_widget.dart';
import 'package:shoghlak/presentation/widgets/button_container_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

class EditReplyMainWidget extends StatefulWidget {
  final ReplyEntity reply;
  const EditReplyMainWidget({super.key, required this.reply});

  @override
  State<EditReplyMainWidget> createState() => _EditReplyMainWidgetState();
}

class _EditReplyMainWidgetState extends State<EditReplyMainWidget> {
  TextEditingController? _descriptionController;
  bool _isUpdating = false;
  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.reply.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: const TextWidget(txt: "Edit Reply"),
          backgroundColor: backGroundColor,
        ),
        body: Padding(
          padding:  EdgeInsets.all(0.03*screenWidth),
          child: Column(
            children: [
              ProfileFormWidget(
                controller: _descriptionController,
                title: "Description",
              ),
              sizeVer(0.036*screenHeight),
              _isUpdating
                  ? const CircularProgressIndicatorWidget()
                  : ButtonContainerWidget(
                      text: "Save changes",
                      height: 0.06*screenHeight,
                      width: double.infinity,
                      onTapListener: () {
                        _editReply();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _editReply() {
    setState(() {
      _isUpdating = true;
    });
    BlocProvider.of<ReplyCubit>(context)
        .updateReply(
          reply: ReplyEntity(
            postId: widget.reply.postId,
            commentId: widget.reply.commentId,
            replyId: widget.reply.replyId,
            description: _descriptionController!.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _descriptionController!.clear();
    });
    Navigator.pop(context);
  }
}
