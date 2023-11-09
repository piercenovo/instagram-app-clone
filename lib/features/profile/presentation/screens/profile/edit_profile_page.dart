import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/profile/presentation/screens/profile/widgets/profile_form_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: tSecondaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              sizeVer(15),
              const Center(
                child: Text(
                  'Change profile photo',
                  style: TextStyle(
                    color: tBlueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              sizeVer(15),
              const ProfileFormWidget(
                title: 'Name',
              ),
              sizeVer(15),
              const ProfileFormWidget(
                title: 'Username',
              ),
              sizeVer(15),
              const ProfileFormWidget(
                title: 'Website',
              ),
              sizeVer(15),
              const ProfileFormWidget(
                title: 'Bio',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
