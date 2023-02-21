import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/home/widgets/post_card_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/injection_container.dart' as di;
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/loading/post_loading_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shoghlak"),
        backgroundColor: backGroundColor.withOpacity(0.1),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back_ground.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BlocBuilder<PostCubit, PostStates>(
              builder: (context, postState) {
                if (postState is PostLoading) {
                  return ListView.separated(
                    itemBuilder: (context, index) => const PostLoadingWidget(),
                    itemCount: 5,
                    separatorBuilder: (context, index) => sizeVer(10),
                  );
                }
                if (postState is PostFailure) {
                  toast("Some errors occured while creating posts");
                }
                if (postState is PostLoaded) {
                  if (postState.posts.isEmpty) {
                    return const ContainerWidget(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      color: backGroundColor,
                      widget: TextWidget(
                        txt: "No Posts yet",
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final post = postState.posts[index];
                      return BlocProvider<PostCubit>(
                          create: (context) => di.sl<PostCubit>(),
                          child: PostCardWidget(post: post));
                    },
                    itemCount: postState.posts.length,
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) => const PostLoadingWidget(),
                  itemCount: 5,
                  separatorBuilder: (context, index) => sizeVer(10),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
