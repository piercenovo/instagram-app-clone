import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: tSecondaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Boxicons.bx_upload, color: tPrimaryColor, size: 40),
          ),
        ),
      ),
    );
  }
}