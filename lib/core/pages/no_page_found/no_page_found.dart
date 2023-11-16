import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        title: const Text('Page not Found'),
        backgroundColor: tBackGroundColor,
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
