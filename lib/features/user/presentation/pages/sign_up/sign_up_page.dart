// ignore_for_file: unused_field, invalid_use_of_visible_for_testing_member, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/image_strings.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/home/presentation/pages/main/main_page.dart';
import 'package:instagram_app/features/home/presentation/widgets/button_container_widget.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_app/features/user/presentation/widgets/form_container_widget.dart';
import 'package:image_picker/image_picker.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSigninUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('no image has been selected');
        }
      });
    } catch (e) {
      toast('Some error occurred $e');
    }
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
                  return MainPage(uid: authState.uid);
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
              sizeVer(tElementPadding),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profileWidget(
                          image: _image,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -12,
                      bottom: -12,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Boxicons.bxs_image_alt,
                          color: tBlueColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              sizeVer(tFinalPadding),
              FormContainerWidget(
                hintText: tUsernameLabel,
                controller: _usernameController,
                inputAction: TextInputAction.next,
              ),
              sizeVer(tElementPadding),
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
                inputAction: TextInputAction.next,
              ),
              sizeVer(tElementPadding),
              FormContainerWidget(
                hintText: tBioLabel,
                controller: _bioController,
                inputAction: TextInputAction.done,
              ),
              sizeVer(tElementPadding),
              ButtonContainerWidget(
                color: tBlueColor,
                text: tSignUpButton,
                onTapListener: () {
                  _signUpUser();
                },
              ),
              sizeVer(tCardPadding),
              _isSigninUp
                  ? SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Please wait',
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
      ),
    );
  }

  Future<void> _signUpUser() async {
    setState(() {
      _isSigninUp = true;
    });

    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
            email: _emailController.text,
            password: _passwordController.text,
            bio: _bioController.text,
            username: _usernameController.text,
            totalPosts: 0,
            totalFollowing: 0,
            followers: const [],
            totalFollowers: 0,
            website: '',
            following: const [],
            name: '',
            imageFile: _image,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _bioController.clear();
      _emailController.clear();
      _passwordController.clear();
      _isSigninUp = false;
    });
  }
}
