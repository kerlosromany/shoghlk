import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/widgets/update_post_main_widget.dart';

import '../../../../domin/entities/user/user_entity.dart';

import 'package:shoghlak/injection_container.dart' as di;

class UpdatePostScreen extends StatelessWidget {
  final PostEntity post;
  const UpdatePostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: UpdatePostMainWidget(post: post), 
    );
  }
}
