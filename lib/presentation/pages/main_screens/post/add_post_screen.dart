import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/widgets/upload_post_main_widget.dart';

import '../../../../domin/entities/user/user_entity.dart';

import 'package:shoghlak/injection_container.dart' as di;

class AddPostScreen extends StatelessWidget {
  final UserEntity currentUser;
  const AddPostScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser), 
    );
  }
}
