import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: Text(
          'Activity',
          style: TextStyle(color: tPrimaryColor),
        ),
      ),
    );
  }
}
