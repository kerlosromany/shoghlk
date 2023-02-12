import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/widgets/edit_comment_main_widget.dart';

import '../../../../../domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/injection_container.dart' as di;

class EditCommentScreen extends StatelessWidget {
  final CommentEntity comment;
  const EditCommentScreen({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentMainWidget(comment: comment),
    );
  }
}
