import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: tSecondaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Iconsax.document_upload,
              color: tPrimaryColor,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
