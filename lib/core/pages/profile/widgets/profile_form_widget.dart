import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({
    super.key,
    this.controller,
    this.title,
  });

  final TextEditingController? controller;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: const TextStyle(color: tPrimaryColor, fontSize: 16),
        ),
        sizeVer(10),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: tPrimaryColor),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(color: tPrimaryColor),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: tSecondaryColor,
        ),
      ],
    );
  }
}
