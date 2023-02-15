import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/on_generate_route.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/widgets/search_controller_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../../../consts.dart';
import '../../../../../domin/entities/post/post_entity.dart';
import '../../../../cubits/post/post_cubit.dart';
import '../../home/widgets/post_card_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocBuilder<PostCubit, PostStates>(
          builder: (context, postState) {
            if (postState is PostLoaded) {
              final filterAllPosts = postState.posts
                  .where(
                    (post) =>
                        post.description!.startsWith(_searchController.text) ||
                        post.description!
                            .toLowerCase()
                            .startsWith(_searchController.text.toLowerCase()) ||
                        post.description!.contains(_searchController.text) ||
                        post.description!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        post.details!.startsWith(_searchController.text) ||
                        post.details!
                            .toLowerCase()
                            .startsWith(_searchController.text.toLowerCase()) ||
                        post.details!.contains(_searchController.text) ||
                        post.details!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()),
                  )
                  .toList();
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 0.0255 * screenWidth,
                    vertical: 0.0255 * screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(controller: _searchController),
                    sizeVer(0.0121 * screenHeight),
                    _searchController.text.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: filterAllPosts.length,
                                itemBuilder: (context, index) {
                                  return PostCardWidget(
                                      post: filterAllPosts[index]);
                                }),
                          )
                        : BlocBuilder<PostCubit, PostStates>(
                            builder: (context, postState) {
                              if (postState is PostLoaded) {
                                final posts = postState.posts;
                                return Expanded(
                                  child: GridView.builder(
                                      itemCount: posts.length,
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                ScreenName
                                                    .singlePostDetailsScreen,
                                                arguments: posts[index]);
                                          },
                                          child: (posts[index].postImageUrl !=
                                                      "" &&
                                                  posts[index].postImageUrl !=
                                                      null)
                                              ? ContainerWidget(
                                                  width: 0.255 * screenWidth,
                                                  height: 0.121 * screenHeight,
                                                  widget: ProfileWidget(
                                                      imageUrl: posts[index]
                                                          .postImageUrl),
                                                )
                                              : ContainerWidget(
                                                  width: 0.255 * screenWidth,
                                                  height: 0.121 * screenHeight,
                                                  color: darkGreyColor,
                                                  padding: EdgeInsets.only(
                                                      left: 0.02 * screenWidth,
                                                      top: 0.02 * screenWidth),
                                                  widget: TextWidget(
                                                    txt: posts[index]
                                                        .description,
                                                  ),
                                                ),
                                        );
                                      }),
                                );
                              }
                              return const CircularProgressIndicatorWidget();
                            },
                          )
                  ],
                ),
              );
            }
            return const CircularProgressIndicatorWidget();
          },
        ),
      ),
    );
  }
}




/*


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/on_generate_route.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/widgets/search_controller_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../../../consts.dart';
import '../../../../../domin/entities/post/post_entity.dart';
import '../../../../cubits/post/post_cubit.dart';
import '../../home/widgets/post_card_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocBuilder<PostCubit, PostStates>(
          builder: (context, postState) {
            if (postState is PostLoaded) {
              final filterAllPosts = postState.posts
                  .where((post) =>
                      post.description!.startsWith(_searchController.text) ||
                      post.description!
                          .toLowerCase()
                          .startsWith(_searchController.text.toLowerCase()) ||
                      post.description!.contains(_searchController.text) ||
                      post.description!
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                  .toList();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(
                      controller: _searchController,
                    ),
                    sizeVer(10),
                    _searchController.text.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: filterAllPosts.length,
                                itemBuilder: (context, index) {
                                  return PostCardWidget(
                                      post: filterAllPosts[index]);
                                }),
                          )
                        : BlocBuilder<PostCubit, PostStates>(
                            builder: (context, postState) {
                              if (postState is PostLoaded) {
                                final posts = postState.posts;
                                return Expanded(
                                  child: GridView.builder(
                                      itemCount: posts.length,
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                ScreenName
                                                    .singlePostDetailsScreen,
                                                arguments: posts[index]);
                                          },
                                          child: (posts[index].postImageUrl !=
                                                      "" &&
                                                  posts[index].postImageUrl !=
                                                      null)
                                              ? ContainerWidget(
                                                  width: 100,
                                                  height: 100,
                                                  widget: ProfileWidget(
                                                      imageUrl: posts[index]
                                                          .postImageUrl),
                                                )
                                              : ContainerWidget(
                                                  width: 100,
                                                  height: 100,
                                                  color: darkGreyColor,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, top: 8),
                                                  widget: TextWidget(
                                                    txt: posts[index]
                                                        .description,
                                                  ),
                                                ),
                                        );
                                      }),
                                );
                              }
                              return const CircularProgressIndicatorWidget();
                            },
                          )
                  ],
                ),
              );
            }
            return const CircularProgressIndicatorWidget();
          },
        ),
      ),
    );
  }
}



 */