import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: tSecondaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: tPrimaryColor),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Iconsax.search_normal),
          hintText: 'Search',
          hintStyle: TextStyle(color: tSecondaryColor, fontSize: 15),
        ),
      ),
    );
  }
}
