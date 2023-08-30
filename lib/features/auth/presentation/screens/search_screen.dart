import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: Text(
          'Search',
          style: TextStyle(color: tPrimaryColor),
        ),
      ),
    );
  }
}
