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
import '../../../../widgets/text_widget.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const ProfileMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ContainerWidget(
                alignment: Alignment.center,
                color: backGroundColor.withOpacity(0.1),
                height: 160,
                width: double.infinity,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ContainerWidget(
                              width: 60,
                              height: 60,
                              color: secondaryColor,
                              boxShape: BoxShape.circle,
                              widget: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(40)),
                                  child: ProfileWidget(
                                      imageUrl: widget.currentUser.profileUrl)),
                            ),
                            TextWidget(
                              txt:
                                  "${widget.currentUser.name == "" ? widget.currentUser.username : widget.currentUser.name}",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const TextWidget(
                          txt: "My Profile",
                          fontWeight: FontWeight.bold,
                          fontsize: 30,
                          textAlign: TextAlign.center,
                        ),
                        ContainerWidget(
                          width: 40,
                          height: 40,
                          borderWidth: 1,
                          borderColor: backGroundColor,
                          borderRadius: BorderRadius.circular(40),
                          color: backGroundColor.withOpacity(0.1),
                          widget: const Icon(Icons.menu, color: primaryColor),
                          onTapListener: () {
                            _openBottomModalSheet(context);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextWidget(
                        txt: "${widget.currentUser.bio}",
                      ),
                    ),
                  ],
                ),
              ),
              sizeVer(20),
              sizeVer(20),
              BlocBuilder<PostCubit, PostStates>(
                builder: (context, postState) {
                  if (postState is PostLoaded) {
                    final posts = postState.posts
                        .where(
                            (post) => post.creatorUid == widget.currentUser.uid)
                        .toList();

                    if (posts.isEmpty) {
                      return Center(
                        child: ContainerWidget(
                          color: backGroundColor.withOpacity(0.5),
                          padding: const EdgeInsets.all(20),
                          borderRadius: BorderRadius.circular(20),
                          widget: const TextWidget(
                            txt: "You didn\'t upload any post",
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      );
                    }
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ScreenName.singlePostDetailsScreen,
                              arguments: posts[index],
                            );
                          },
                          child: (posts[index].postImageUrl != "" &&
                                  posts[index].postImageUrl != null)
                              ? ContainerWidget(
                                  width: 100,
                                  height: 100,
                                  widget: ProfileWidget(
                                      imageUrl: posts[index].postImageUrl),
                                )
                              : ContainerWidget(
                                  width: 100,
                                  height: 100,
                                  color: darkGreyColor,
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 8),
                                  widget: TextWidget(
                                    txt: posts[index].description,
                                  ),
                                ),
                        );
                      },
                    );
                  }
                  return const CircularProgressIndicatorWidget();
                },
              )
            ],
          ),
        ),
      ),
    ));
  }

  _openBottomModalSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ContainerWidget(
          height: 150,
          color: backGroundColor.withOpacity(.2),
          widget: SingleChildScrollView(
            child: ContainerWidget(
              padding: const EdgeInsets.symmetric(vertical: 10),
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextWidget(
                      txt: "More Options",
                      fontWeight: FontWeight.bold,
                      fontsize: 18,
                    ),
                  ),
                  sizeVer(8),
                  const Divider(thickness: 1, color: secondaryColor),
                  sizeVer(8),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ScreenName.editProfileScreen,
                            arguments: widget.currentUser);
                      },
                      child: const TextWidget(
                        txt: "Edit Profile",
                        fontWeight: FontWeight.w500,
                        fontsize: 16,
                      ),
                    ),
                  ),
                  sizeVer(7),
                  const Divider(thickness: 1, color: secondaryColor),
                  sizeVer(7),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).logOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, ScreenName.signInScreen, (route) => false);
                      },
                      child: const TextWidget(
                        txt: "Logout",
                        fontWeight: FontWeight.w500,
                        fontsize: 16,
                      ),
                    ),
                  ),
                  sizeVer(7),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
