// ignore_for_file: avoid_print, unused_field

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
import 'package:instagram_app/core/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;
import 'package:instagram_app/features/user/domain/usecases/storage/upload_image_to_storage_usecase.dart';

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;

  const UpdatePostMainWidget({
    super.key,
    required this.post,
  });

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? _descriptionController;

  bool _updating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
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
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Edit Post',
          style: TextStyle(color: tPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {
            popBack(context);
          },
          icon: const Icon(Boxicons.bx_arrow_back, color: tPrimaryColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              _updatePost();
            },
            icon: const Icon(Boxicons.bx_check, color: tBlueColor, size: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                      imageUrl: widget.post.userProfileUrl,
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              Text(
                '${widget.post.username}',
                style: const TextStyle(
                    color: tPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              sizeVer(15),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: profileWidget(
                      imageUrl: widget.post.postImageUrl,
                      image: _image,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: tPrimaryColor,
                          ),
                          child: const Icon(
                            Boxicons.bxs_edit,
                            color: tBlueColor,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              sizeVer(10),
              ProfileFormWidget(
                title: 'Description',
                controller: _descriptionController,
              ),
              sizeVer(tCardPadding),
              _updating
                  ? SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            tUpdating,
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

  _updatePost() {
    setState(() {
      _updating = true;
    });
    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, true, 'posts')
          .then((imageUrl) {
        _submitUpdatePost(image: imageUrl);
      });
    }
  }

  _submitUpdatePost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .updatePost(
          post: PostEntity(
            creatorUid: widget.post.creatorUid,
            postId: widget.post.postId,
            postImageUrl: image,
            description: _descriptionController!.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _image = null;
      _descriptionController!.clear();
      _updating = false;
      popBack(context);
    });
  }
}
