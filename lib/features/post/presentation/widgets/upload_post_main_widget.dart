// ignore_for_file: avoid_print, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;

  const UploadPostMainWidget({
    super.key,
    required this.currentUser,
  });

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  final TextEditingController _descriptionController = TextEditingController();

  bool _uploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
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
    return _image == null ? _uploadPostWidget() : _uploadedPostWidget();
  }

  _uploadedPostWidget() {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        leading: IconButton(
          onPressed: () {
            setState(() {
              _image = null;
            });
          },
          icon: const Icon(Boxicons.bx_x, color: tPrimaryColor, size: 32),
        ),
        actions: [
          IconButton(
            onPressed: _submitPost,
            icon: const Icon(Boxicons.bx_arrow_to_right,
                color: tBlueColor, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: profileWidget(
                  imageUrl: widget.currentUser.profileUrl,
                ),
              ),
            ),
            sizeVer(10),
            Text(
              '${widget.currentUser.username}',
              style: const TextStyle(color: Colors.white),
            ),
            sizeVer(15),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: profileWidget(image: _image),
            ),
            sizeVer(15),
            ProfileFormWidget(
              title: 'Description',
              controller: _descriptionController,
            ),
            sizeVer(tCardPadding),
            _uploading
                ? SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          tUploading,
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
    );
  }

  _uploadPostWidget() {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      body: Center(
        child: GestureDetector(
          onTap: selectImage,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: tSecondaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Boxicons.bx_upload, color: tPrimaryColor, size: 40),
            ),
          ),
        ),
      ),
    );
  }

  _submitPost() {
    setState(() {
      _uploading = true;
    });
    di
        .sl<UploadImageToStorageUseCase>()
        .call(_image!, true, 'posts')
        .then((value) {
      _createSubmitPost(image: value);
    });
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
          post: PostEntity(
            description: _descriptionController.text,
            createAt: Timestamp.now(),
            creatorUid: widget.currentUser.uid,
            likes: const [],
            postId: const Uuid().v1(),
            postImageUrl: image,
            totalComments: 0,
            totalLikes: 0,
            username: widget.currentUser.username,
            userProfileUrl: widget.currentUser.profileUrl,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _descriptionController.clear();
      _image = null;
      _uploading = false;
    });
  }
}
