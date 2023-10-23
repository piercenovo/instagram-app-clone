import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/image_strings.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/auth/presentation/widgets/button_container_widget.dart';
import 'package:instagram_app/features/auth/presentation/widgets/form_container_widget.dart';

class SingUpPage extends StatelessWidget {
  const SingUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            sizeVer(tElementPadding),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: tSecondaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(tProfileDefaultImage),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_a_photo, color: tBlueColor),
                    ),
                  )
                ],
              ),
            ),
            sizeVer(tFinalPadding),
            const FormContainerWidget(
              hintText: tUsernameLabel,
              inputAction: TextInputAction.next,
            ),
            sizeVer(tElementPadding),
            const FormContainerWidget(
              hintText: tEmailLabel,
              inputAction: TextInputAction.next,
            ),
            sizeVer(tElementPadding),
            const FormContainerWidget(
              hintText: tPasswordLabel,
              isPasswordField: true,
              inputAction: TextInputAction.next,
            ),
            sizeVer(tElementPadding),
            const FormContainerWidget(
              hintText: tBioLabel,
              inputAction: TextInputAction.done,
            ),
            sizeVer(tElementPadding),
            ButtonContainerWidget(
              color: tBlueColor,
              text: tSignUpButton,
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
                  tAlreadyHaveAccountTitle,
                  style: TextStyle(
                    color: tPrimaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    pushNamedAndRemoveUntilToPage(
                        context, PageConst.signInPage);
                  },
                  child: const Text(
                    tSignInTitle,
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
    );
  }
}
