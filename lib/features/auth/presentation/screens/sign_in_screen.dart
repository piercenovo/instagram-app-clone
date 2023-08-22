import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: tBackGroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: Text('Sign In Screen'),
        ),
      ),
    );
  }
}
