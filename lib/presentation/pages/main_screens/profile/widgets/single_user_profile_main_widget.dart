import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/on_generate_route.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';

import '../../../../../consts.dart';
import '../../../../widgets/text_widget.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  final String profileUrl;
  const SingleUserProfileMainWidget({Key? key, required this.otherUserId , required this.profileUrl})
      : super(key: key);

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState
    extends State<SingleUserProfileMainWidget> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.otherUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back_ground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BlocBuilder<GetSingleUserCubit, GetSingleUserStates>(
              builder: (context, userState) {
                if (userState is GetSingleUserLoaded) {
                  final singleUser = userState.user;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ContainerWidget(
                          alignment: Alignment.center,
                          color: backGroundColor.withOpacity(0.1),
                          height: 0.19 * screenHeight,
                          width: double.infinity,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(0.05 * screenWidth)),
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ContainerWidget(
                                        width: 0.25 * screenWidth,
                                        height: 0.12 * screenHeight,
                                        color: secondaryColor,
                                        boxShape: BoxShape.circle,
                                        widget: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    0.1 * screenWidth)),
                                            child: ProfileWidget(
                                                imageUrl:
                                                   widget.profileUrl)),
                                      ),
                                      TextWidget(
                                        txt:
                                            "${singleUser.name == "" ? singleUser.username : singleUser.name}",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  // const FittedBox(
                                  //   child: TextWidget(
                                  //     txt: "My Profile",
                                  //     fontWeight: FontWeight.bold,
                                  //     // fontsize: 30,
                                  //     textAlign: TextAlign.center,
                                  //   ),
                                  // ),
                                  // ContainerWidget(
                                  //   width: 0.1 * screenWidth,
                                  //   height: 0.048 * screenHeight,
                                  //   borderWidth: 1,
                                  //   borderColor: backGroundColor,
                                  //   borderRadius:
                                  //       BorderRadius.circular(0.1 * screenWidth),
                                  //   color: backGroundColor.withOpacity(0.1),
                                  //   widget:
                                  //       const Icon(Icons.menu, color: primaryColor),
                                  //   onTapListener: () {
                                  //     _openBottomModalSheet(
                                  //       context: context,
                                  //       screenHeight: screenHeight,
                                  //       screenWidth: screenWidth,
                                  //       currentUser: singleUser,
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 0.06 * screenWidth),
                                child: TextWidget(
                                  txt: "${singleUser.bio}",
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizeVer(0.024 * screenHeight),
                        sizeVer(0.024 * screenHeight),
                        BlocBuilder<PostCubit, PostStates>(
                          builder: (context, postState) {
                            if (postState is PostLoaded) {
                              final posts = postState.posts
                                  .where((post) =>
                                      post.creatorUid == singleUser.uid)
                                  .toList();

                              if (posts.isEmpty) {
                                return Center(
                                  child: ContainerWidget(
                                    color: backGroundColor.withOpacity(0.5),
                                    padding: EdgeInsets.all(0.05 * screenWidth),
                                    borderRadius: BorderRadius.circular(
                                        0.05 * screenWidth),
                                    widget: const FittedBox(
                                      child: TextWidget(
                                        txt: "You didn\'t upload any post",
                                        fontWeight: FontWeight.w900,
                                      ),
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
                                            width: 0.255 * screenWidth,
                                            height: 0.121 * screenHeight,
                                            widget: ProfileWidget(
                                                imageUrl:
                                                    posts[index].postImageUrl),
                                          )
                                        : ContainerWidget(
                                            width: 0.255 * screenWidth,
                                            height: 0.121 * screenHeight,
                                            color: darkGreyColor,
                                            padding: EdgeInsets.only(
                                                left: 0.02 * screenWidth,
                                                top: 0.02 * screenWidth),
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
                  );
                }
                return const CircularProgressIndicatorWidget();
              },
            ),
          ),
        ));
  }

  // _openBottomModalSheet(
  //     {required BuildContext context,
  //     required double screenHeight,
  //     required double screenWidth,
  //     required UserEntity currentUser}) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return ContainerWidget(
  //         //    height: 0.18 * screenHeight,
  //         color: backGroundColor.withOpacity(.2),
  //         widget: SingleChildScrollView(
  //           child: ContainerWidget(
  //             padding: EdgeInsets.symmetric(vertical: 0.0255 * screenWidth),
  //             widget: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 0.0255 * screenWidth),
  //                   child: const TextWidget(
  //                     txt: "More Options",
  //                     fontWeight: FontWeight.bold,
  //                     fontsize: 18,
  //                   ),
  //                 ),
  //                 sizeVer(0.0121 * screenHeight),
  //                 const Divider(thickness: 1, color: secondaryColor),
  //                 sizeVer(0.0121 * screenHeight),
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 0.0255 * screenWidth),
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Navigator.pushNamed(
  //                           context, ScreenName.editProfileScreen,
  //                           arguments: currentUser);
  //                     },
  //                     child: const TextWidget(
  //                       txt: "Edit Profile",
  //                       fontWeight: FontWeight.w500,
  //                       fontsize: 16,
  //                     ),
  //                   ),
  //                 ),
  //                 sizeVer(0.0121 * screenHeight),
  //                 const Divider(thickness: 1, color: secondaryColor),
  //                 sizeVer(0.0121 * screenHeight),
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 0.0255 * screenWidth),
  //                   child: InkWell(
  //                     onTap: () {
  //                       BlocProvider.of<AuthCubit>(context)
  //                           .logOut()
  //                           .then((value) {
  //                         CacheHelper.removeData(key: "token");
  //                       });
  //                       Navigator.pushNamedAndRemoveUntil(
  //                           context, ScreenName.signInScreen, (route) => false);
  //                     },
  //                     child: const TextWidget(
  //                       txt: "Logout",
  //                       fontWeight: FontWeight.w500,
  //                       fontsize: 16,
  //                     ),
  //                   ),
  //                 ),
  //                 sizeVer(0.0121 * screenHeight),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


}
