// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/features/activity/presentation/pages/activity/activity_page.dart';
import 'package:instagram_app/features/post/presentation/pages/post/post_page.dart';
import 'package:instagram_app/features/profile/presentation/screens/profile/profile_page.dart';
import 'package:instagram_app/features/search/presentation/screens/search/search_page.dart';
import 'package:instagram_app/features/home/presentation/pages/home/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: tBackGroundColor,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: tBackGroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_home_smile, color: tPrimaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_search, color: tPrimaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_plus, color: tPrimaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_heart, color: tPrimaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_user, color: tPrimaryColor),
          ),
        ],
        onTap: navigationTapped,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomePage(),
          SearchPage(),
          PostPage(),
          ActivityPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
