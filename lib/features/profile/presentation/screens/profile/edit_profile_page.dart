// ignore_for_file: unused_field, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/profile/presentation/screens/profile/widgets/profile_form_widget.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool _isUpdating = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentUser.name);
    _usernameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
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
            onPressed: _updateUserProfileData,
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
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: profileWidget(
                      imageUrl: widget.currentUser.profileUrl,
                      image: _image,
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              Center(
                child: GestureDetector(
                  onTap: selectImage,
                  child: const Text(
                    'Change profile photo',
                    style: TextStyle(
                      color: tBlueColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: 'Name',
                controller: _nameController,
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: 'Username',
                controller: _usernameController,
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: 'Website',
                controller: _websiteController,
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: 'Bio',
                controller: _bioController,
              ),
              sizeVer(10),
              _isUpdating
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
            ],
          ),
        ),
      ),
    );
  }

  _updateUserProfileData() {
    if (_image == null) {
      _updateUserProfile('');
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, "profileImages")
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) {
    setState(() => _isUpdating = true);

    BlocProvider.of<UserCubit>(context)
        .updateUser(
          user: UserEntity(
            uid: widget.currentUser.uid,
            name: _nameController!.text,
            username: _usernameController!.text,
            website: _websiteController!.text,
            bio: _bioController!.text,
            profileUrl: profileUrl,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _nameController!.clear();
      _usernameController!.clear();
      _websiteController!.clear();
      _bioController!.clear();
      _isUpdating = false;
    });
    popBack(context);
  }
}
