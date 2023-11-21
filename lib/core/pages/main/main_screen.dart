// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/pages/home/home_page.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/pages/activity/activity_page.dart';
import 'package:instagram_app/features/post/presentation/pages/post/upload_post/upload_post_page.dart';
import 'package:instagram_app/core/pages/profile/profile_page.dart';
import 'package:instagram_app/core/pages/search/search_page.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

class MainScreen extends StatefulWidget {
  final String uid;

  const MainScreen({
    super.key,
    required this.uid,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;

          return Scaffold(
            backgroundColor: tBackGroundColor,
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: tBackGroundColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_home_smile,
                    color: tPrimaryColor,
                    size: 28,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_search,
                    color: tPrimaryColor,
                    size: 28,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_plus,
                    color: tPrimaryColor,
                    size: 28,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_heart,
                    color: tPrimaryColor,
                    size: 28,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_user,
                    color: tPrimaryColor,
                    size: 28,
                  ),
                ),
              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                const HomePage(),
                const SearchPage(),
                UploadPostPage(currentUser: currentUser),
                const ActivityPage(),
                ProfilePage(currentUser: currentUser),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
