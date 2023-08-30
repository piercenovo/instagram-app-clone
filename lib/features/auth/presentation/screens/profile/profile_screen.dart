import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Username',
          style: TextStyle(color: tPrimaryColor),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Iconsax.menu_1, color: tPrimaryColor),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                        color: tSecondaryColor, shape: BoxShape.circle),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            '0',
                            style: TextStyle(
                                color: tPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          sizeVer(8),
                          const Text(
                            'Posts',
                            style: TextStyle(color: tPrimaryColor),
                          ),
                        ],
                      ),
                      sizeHor(25),
                      Column(
                        children: [
                          const Text(
                            '65',
                            style: TextStyle(
                                color: tPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          sizeVer(8),
                          const Text(
                            'Followers',
                            style: TextStyle(color: tPrimaryColor),
                          ),
                        ],
                      ),
                      sizeHor(25),
                      Column(
                        children: [
                          const Text(
                            '178',
                            style: TextStyle(
                                color: tPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          sizeVer(8),
                          const Text(
                            'Following',
                            style: TextStyle(color: tPrimaryColor),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              sizeVer(10),
              const Text(
                'Name',
                style: TextStyle(
                    color: tPrimaryColor, fontWeight: FontWeight.bold),
              ),
              sizeVer(5),
              const Text(
                'The bio of user',
                style: TextStyle(color: tPrimaryColor),
              ),
              sizeVer(10),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 32,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: tSecondaryColor,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
