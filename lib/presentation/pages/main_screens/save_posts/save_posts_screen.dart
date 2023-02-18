import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:shoghlak/on_generate_route.dart';
import 'package:shoghlak/presentation/cubits/auth/auth_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';

import '../../../../../consts.dart';
import '../../../../../domin/entities/post/post_entity.dart';
import '../../../widgets/text_widget.dart';
import '../home/widgets/post_card_widget.dart';

class SavePostsScreen extends StatefulWidget {
  final UserEntity currentUser;
  const SavePostsScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<SavePostsScreen> createState() => _SavePostsScreenState();
}

class _SavePostsScreenState extends State<SavePostsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back_ground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<PostCubit, PostStates>(
              builder: (context, postState) {
                if (postState is PostLoaded) {
                  final posts = postState.posts
                      .where((post) =>
                          post.savedPosts!.contains(widget.currentUser.uid))
                      .toList();

                  if (posts.isEmpty) {
                    return Center(
                      child: ContainerWidget(
                        color: backGroundColor.withOpacity(0.5),
                        padding:  EdgeInsets.all(0.05 * screenWidth),
                        borderRadius: BorderRadius.circular(0.05 * screenWidth),
                        widget: const TextWidget(
                          txt: "You didn\'t save any post",
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCardWidget(post: posts[index] );
                      },
                    ),
                  );
                }
                return const CircularProgressIndicatorWidget();
              },
            ),
          ],
        ),
      ),
    ));
  }

}
