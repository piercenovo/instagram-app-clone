import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Activity',
          style: TextStyle(color: tPrimaryColor),
        ),
      ),
    );
  }
}
