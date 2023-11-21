import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/entities/app_entity.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_app/features/post/presentation/cubit/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_app/features/post/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/comment/widgets/single_comment_widget.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({
    super.key,
    required this.appEntity,
  });

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(
      uid: widget.appEntity.uid!,
    );
    BlocProvider.of<CommentCubit>(context).getComments(
      postId: widget.appEntity.postId!,
    );
    BlocProvider.of<GetSinglePostCubit>(context).getSinglePost(
      postId: widget.appEntity.postId!,
    );
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Comments',
          style: TextStyle(color: tPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {
            popBack(context);
          },
          icon: const Icon(Boxicons.bx_arrow_back, color: tPrimaryColor),
        ),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
          builder: (context, singleUserState) {
        if (singleUserState is GetSingleUserLoaded) {
          final singleUser = singleUserState.user;
          return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
              builder: (context, singlePostState) {
            if (singlePostState is GetSinglePostLoaded) {
              final singlePost = singlePostState.post;
              return BlocBuilder<CommentCubit, CommentState>(
                builder: (context, commentState) {
                  if (commentState is CommentLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: profileWidget(
                                          imageUrl: singlePost.userProfileUrl),
                                    ),
                                  ),
                                  sizeHor(10),
                                  Text(
                                    '${singlePost.username}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: tPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              sizeVer(10),
                              Text(
                                '${singlePost.description}',
                                style: const TextStyle(
                                  color: tPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizeVer(10),
                        const Divider(
                          color: tSecondaryColor,
                        ),
                        sizeVer(10),
                        Expanded(
                          child: commentState.comments.isEmpty
                              ? _noCommentsYetWidget()
                              : ListView.builder(
                                  itemCount: commentState.comments.length,
                                  itemBuilder: ((context, index) {
                                    final singleComment =
                                        commentState.comments[index];
                                    return BlocProvider(
                                      create: (context) => di.sl<ReplayCubit>(),
                                      child: SingleCommentWidget(
                                        currentUser: singleUser,
                                        comment: singleComment,
                                        onLongPressListener: () {
                                          _openBottomModalSheet(
                                            context: context,
                                            comment: singleComment,
                                          );
                                        },
                                        onLikeClickListener: () {
                                          _likeComment(comment: singleComment);
                                        },
                                      ),
                                    );
                                  }),
                                ),
                        ),
                        _commentSection(currentUser: singleUser),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: currentUser.profileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: tPrimaryColor),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Post your comment...',
                  hintStyle: TextStyle(color: tSecondaryColor),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                _createComment(currentUser);
              },
              child: const Text(
                'Post',
                style: TextStyle(fontSize: 15, color: tBlueColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
      comment: CommentEntity(
        totalReplays: 0,
        commentId: const Uuid().v1(),
        createAt: Timestamp.now(),
        likes: const [],
        username: currentUser.username,
        userProfileUrl: currentUser.profileUrl,
        description: _descriptionController.text,
        creatorUid: currentUser.uid,
        postId: widget.appEntity.postId,
      ),
    )
        .then((value) {
      setState(() {
        _descriptionController.clear();
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required CommentEntity comment}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tDarkBlackColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: tDarkBlackColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: tDarkGreyColor,
                  ),
                ),
              ),
              sizeVer(10),
              Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Boxicons.bx_message_alt_x,
                            color: tPrimaryColor, size: 20),
                        sizeHor(10),
                        const Text(
                          'Delete comment',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                      _deleteComment(
                        commentId: comment.commentId!,
                        postId: comment.postId!,
                      );
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Boxicons.bx_message_detail,
                            color: tPrimaryColor, size: 20),
                        sizeHor(10),
                        const Text(
                          'Update comment',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                      pushNamedToPage(
                        context,
                        PageConst.updateCommentPage,
                        arguments: comment,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _noCommentsYetWidget() {
    return const Center(
      child: Text(
        'No Comments Yet',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  _deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
      comment: CommentEntity(commentId: commentId, postId: postId),
    );
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
      comment:
          CommentEntity(commentId: comment.commentId, postId: comment.postId),
    );
  }
}
