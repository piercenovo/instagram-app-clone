import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/profile/presentation/screens/profile/widgets/profile_form_widget.dart';

class UpdatePostPage extends StatelessWidget {
  const UpdatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text('Edit Post'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Boxicons.bx_check, color: tBlueColor, size: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: tSecondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              sizeVer(10),
              const Text(
                'Username',
                style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              sizeVer(10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(color: tSecondaryColor),
              ),
              sizeVer(10),
              const ProfileFormWidget(
                title: 'Description',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
