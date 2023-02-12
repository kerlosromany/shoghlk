import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_cubit.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/widgets/edit_comment_main_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/comments/widgets/edit_reply_main_widget.dart';

import '../../../../../domin/entities/comment/comment_entity.dart';
import 'package:shoghlak/injection_container.dart' as di;

class EditReplyScreen extends StatelessWidget {
  final ReplyEntity reply;
  const EditReplyScreen({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplyCubit>(
      create: (context) => di.sl<ReplyCubit>(),
      child: EditReplyMainWidget(reply: reply),
    );
  }
}
