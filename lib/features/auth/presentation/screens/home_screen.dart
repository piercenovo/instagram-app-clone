import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/image_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: SvgPicture.asset(
          tIcInstagramImage,
          colorFilter: const ColorFilter.mode(tPrimaryColor, BlendMode.srcIn),
          height: 32,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Iconsax.message, color: tPrimaryColor),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: tSecondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      sizeHor(10),
                      const Text(
                        'Username',
                        style: TextStyle(
                            color: tPrimaryColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Icon(Iconsax.more, color: tPrimaryColor)
                ],
              ),
            ),
            sizeVer(10.0),
            Container(
              width: double.infinity,
              height: height * 0.3,
              color: tSecondaryColor,
            ),
            sizeVer(10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.heart, color: tPrimaryColor),
                      sizeHor(10.0),
                      const Icon(Iconsax.message_2, color: tPrimaryColor),
                      sizeHor(10.0),
                      const Icon(Iconsax.send_2, color: tPrimaryColor),
                    ],
                  ),
                  const Icon(Iconsax.archive_1, color: tPrimaryColor),
                ],
              ),
            ),
            sizeVer(10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Text(
                    'Username',
                    style: TextStyle(
                        color: tPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeHor(10.0),
                  const Text(
                    'some description',
                    style: TextStyle(color: tPrimaryColor),
                  )
                ],
              ),
            ),
            sizeVer(5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View all 10 comments',
                    style: TextStyle(color: tDarkGreyColor),
                  ),
                  sizeVer(5.0),
                  const Text(
                    '08/5/2023',
                    style: TextStyle(color: tDarkGreyColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
