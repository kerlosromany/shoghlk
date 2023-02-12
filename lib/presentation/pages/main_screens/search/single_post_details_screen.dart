// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';

import 'package:shoghlak/injection_container.dart' as di;
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/widgets/single_post_main_widget.dart';

class SinglePostDetailsScreen extends StatelessWidget {
  final PostEntity post;
  const SinglePostDetailsScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
        BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: SinglePostMainWidget(post: post),
    );
  }
}
