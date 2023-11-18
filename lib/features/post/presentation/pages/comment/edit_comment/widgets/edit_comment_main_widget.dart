// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_app/features/user/presentation/widgets/button_container_widget.dart';

class EditCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;

  const EditCommentMainWidget({
    super.key,
    required this.comment,
  });

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {
  TextEditingController? _descriptionController;

  bool _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Edit Comment',
          style: TextStyle(color: tPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {
            popBack(context);
          },
          icon: const Icon(Boxicons.bx_arrow_back, color: tPrimaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            ProfileFormWidget(
              title: 'Description',
              controller: _descriptionController,
            ),
            sizeVer(10),
            ButtonContainerWidget(
              color: tBlueColor,
              text: 'Save Changes',
              onTapListener: () {
                _editComment();
              },
            ),
            sizeVer(10),
            _isCommentUpdating
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
    );
  }

  _editComment() {
    setState(() {
      _isCommentUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
            comment: CommentEntity(
      commentId: widget.comment.commentId,
      postId: widget.comment.postId,
      description: _descriptionController!.text,
    ))
        .then((value) {
      setState(() {
        _isCommentUpdating = false;
        _descriptionController!.clear();
      });
      popBack(context);
    });
  }
}
