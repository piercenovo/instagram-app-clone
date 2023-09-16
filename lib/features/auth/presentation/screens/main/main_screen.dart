// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/features/auth/presentation/screens/activity/activity_screen.dart';
import 'package:instagram_app/features/auth/presentation/screens/home/home_screen.dart';
import 'package:instagram_app/features/auth/presentation/screens/post/post_screen.dart';
import 'package:instagram_app/features/auth/presentation/screens/profile/profile_screen.dart';
import 'package:instagram_app/features/auth/presentation/screens/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
          HomeScreen(),
          SearchScreen(),
          PostScreen(),
          ActivityScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
