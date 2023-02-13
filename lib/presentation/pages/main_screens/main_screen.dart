import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/consts.dart';

import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_states.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/add_post_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/home/home_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/profile_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/save_posts/save_posts_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/search_screen.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/icon_widget.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({super.key, required this.uid});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  changeScreen(index) {
    pageController.jumpToPage(index);
  }

  changeCurrentScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserStates>(
      builder: (context, getSingleUserState) {
        // if(getSingleUserState is GetSingleUserLoading){
        //   return const CircularProgressIndicatorWidget();
        // }
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: backGroundColor,
              items: const [
                BottomNavigationBarItem(
                    icon: IconWidget(icon: Icons.home), label: ""),
                BottomNavigationBarItem(
                    icon: IconWidget(icon: Icons.search), label: ""),
                BottomNavigationBarItem(
                    icon: IconWidget(icon: Icons.add_circle), label: ""),
                BottomNavigationBarItem(
                    icon: IconWidget(icon: Icons.bookmark), label: ""),
                BottomNavigationBarItem(
                    icon: IconWidget(icon: Icons.account_circle_outlined),
                    label: ""),
              ],
              onTap: changeScreen,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: changeCurrentScreen,
              children: [
                const HomeScreen(),
                const SearchScreen(),
                AddPostScreen(currentUser: currentUser),
                SavePostsScreen(currentUser: currentUser),
                ProfileScreen(currentUser: currentUser),
              ],
            ),
          );
        }
        return const CircularProgressIndicatorWidget();
      },
    );
  }
}
