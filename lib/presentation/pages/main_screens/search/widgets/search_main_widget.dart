import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/on_generate_route.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/widgets/search_controller_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchWidget(controller: _searchController),
                sizeVer(20),
                BlocBuilder<PostCubit, PostStates>(
                  builder: (context, postState) {
                    if (postState is PostLoaded) {
                      final posts = postState.posts;
                      return GridView.builder(
                        itemCount: posts.length,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ScreenName.singlePostDetailsScreen,
                                arguments: posts[index],
                              );
                            },
                            child: ContainerWidget(
                              width: 100,
                              height: 100,
                              widget: ProfileWidget(
                                imageUrl: posts[index].postImageUrl,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicatorWidget();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
