import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

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
