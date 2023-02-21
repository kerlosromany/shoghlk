import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/injection_container.dart' as di;
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/single_user_profile_main_widget.dart';

class SingleUserProfileScreen extends StatelessWidget {
  final String otherUserId;
  final String profileUrl;
  const SingleUserProfileScreen({super.key , required this.otherUserId ,  required this.profileUrl});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => di.sl<GetSingleUserCubit>(),
      child: SingleUserProfileMainWidget(otherUserId: otherUserId , profileUrl: profileUrl),
    );
  }
}