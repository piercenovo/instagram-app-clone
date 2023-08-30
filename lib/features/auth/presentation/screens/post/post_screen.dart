import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: Text(
          'Post',
          style: TextStyle(color: tPrimaryColor),
        ),
      ),
    );
  }
}
