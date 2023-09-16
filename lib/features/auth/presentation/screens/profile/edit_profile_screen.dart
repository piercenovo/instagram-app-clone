import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: tPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {
            popBack(context);
          },
          icon: const Icon(Boxicons.bx_x, color: tPrimaryColor, size: 32),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Boxicons.bx_check, color: tBlueColor, size: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: tSecondaryColor,
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
