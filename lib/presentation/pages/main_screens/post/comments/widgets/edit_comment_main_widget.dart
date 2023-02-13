import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/widgets/form_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_form_widget.dart';
import 'package:shoghlak/presentation/widgets/button_container_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

class EditCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentMainWidget({super.key, required this.comment});

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {
  TextEditingController? _descriptionController;
  bool _isUpdating = false;
  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: const TextWidget(txt: "Edit Comment"),
          backgroundColor: backGroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              FormWidget(
                controller: _descriptionController,
                title: "Description",
                maxLines: 5,
              ),
              sizeVer(30),
              _isUpdating
                  ? const CircularProgressIndicatorWidget()
                  : ButtonContainerWidget(
                      text: "Save changes",
                      height: 50,
                      width: double.infinity,
                      onTapListener: () {
                        _editComment();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
          comment: CommentEntity(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId,
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
