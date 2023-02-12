// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_main_widget.dart';
import 'package:shoghlak/injection_container.dart' as di;

class ProfileScreen extends StatelessWidget {
  final UserEntity currentUser;
  const ProfileScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: ProfileMainWidget(currentUser: currentUser),
    );
  }
}
