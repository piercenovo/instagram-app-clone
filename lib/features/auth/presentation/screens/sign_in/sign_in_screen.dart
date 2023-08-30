import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/image_strings.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:instagram_app/features/auth/presentation/widgets/button_container_widget.dart';
import 'package:instagram_app/features/auth/presentation/widgets/form_container_widget.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Center(
                child: SvgPicture.asset(
                  tIcInstagramImage,
                  colorFilter:
                      const ColorFilter.mode(tPrimaryColor, BlendMode.srcIn),
                ),
              ),
              sizeVer(tFinalPadding),
              const FormContainerWidget(
                hintText: tEmailLabel,
                inputAction: TextInputAction.next,
              ),
              sizeVer(tElementPadding),
              const FormContainerWidget(
                hintText: tPasswordLabel,
                isPasswordField: true,
                inputAction: TextInputAction.done,
              ),
              sizeVer(tElementPadding),
              ButtonContainerWidget(
                color: tBlueColor,
                text: tSignInButton,
                onTapListener: () {},
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const Divider(
                color: tSecondaryColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    tDontHaveAccountTitle,
                    style: TextStyle(
                      color: tPrimaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SingUpScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      tSignUpTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tPrimaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}