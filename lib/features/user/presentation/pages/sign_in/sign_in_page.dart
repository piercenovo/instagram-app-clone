// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/pages/main/main_screen.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/image_strings.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_app/features/user/presentation/widgets/button_container_widget.dart';
import 'package:instagram_app/features/user/presentation/widgets/form_container_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSigninIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }

          if (credentialState is CredentialFailure) {
            toast('Invalid Email and Password');
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return _bodyWidget();
                }
              },
            );
          }
          return _bodyWidget();
        },
      ),
    );
  }

  _bodyWidget() {
    final height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: SizedBox(
          height: height * 0.97,
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
              FormContainerWidget(
                hintText: tEmailLabel,
                controller: _emailController,
                inputAction: TextInputAction.next,
              ),
              sizeVer(tElementPadding),
              FormContainerWidget(
                hintText: tPasswordLabel,
                controller: _passwordController,
                isPasswordField: true,
                inputAction: TextInputAction.done,
              ),
              sizeVer(tElementPadding),
              ButtonContainerWidget(
                color: tBlueColor,
                text: tSignInButton,
                onTapListener: () {
                  _signInUser();
                },
              ),
              sizeVer(tCardPadding),
              _isSigninIn
                  ? SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            tPleaseWait,
                            style: TextStyle(
                              color: tPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          sizeHor(10),
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 30,
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
                      pushNamedAndRemoveUntilToPage(
                          context, PageConst.signUpPage);
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

  void _signInUser() {
    setState(() {
      _isSigninIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isSigninIn = false;
    });
  }
}
