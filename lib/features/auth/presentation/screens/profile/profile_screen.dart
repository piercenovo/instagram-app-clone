import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: Text(
          'Profile',
          style: TextStyle(color: tPrimaryColor),
        ),
      ),
    );
  }
}
