// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/features/post/presentation/widgets/like_animation_widget.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:intl/intl.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;

  const SinglePostCardWidget({
    super.key,
    required this.post,
  });

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  bool _isLikeAnimating = false;

  String _currentUid = '';

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profileWidget(
                          imageUrl: widget.post.userProfileUrl,
                        ),
                      ),
                    ),
                    sizeHor(10),
                    Text(
                      '${widget.post.username}',
                      style: const TextStyle(
                          color: tPrimaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _openBottomModalSheet(context);
                  },
                  child: const Icon(Boxicons.bx_dots_horizontal,
                      color: tPrimaryColor),
                ),
              ],
            ),
          ),
          sizeVer(10.0),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height * 0.3,
                  child: profileWidget(imageUrl: widget.post.postImageUrl),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
                  child: LikeAnimationWidget(
                    duration: const Duration(milliseconds: 200),
                    isLikeAnimating: _isLikeAnimating,
                    onLikeFinish: () {
                      setState(() {
                        _isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Boxicons.bxs_heart,
                      size: 100,
                      color: tHeartColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          sizeVer(10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _likePost,
                      child: Icon(
                        widget.post.likes!.contains(_currentUid)
                            ? Boxicons.bxs_heart
                            : Boxicons.bx_heart,
                        color: widget.post.likes!.contains(_currentUid)
                            ? tHeartColor
                            : tPrimaryColor,
                      ),
                    ),
                    sizeHor(10.0),
                    GestureDetector(
                      onTap: () {
                        pushNamedToPage(context, PageConst.commentPage);
                      },
                      child: const Icon(Boxicons.bx_message_square_detail,
                          color: tPrimaryColor),
                    ),
                    sizeHor(10.0),
                    const Icon(Boxicons.bx_send, color: tPrimaryColor),
                  ],
                ),
                const Icon(Boxicons.bx_bookmark, color: tPrimaryColor),
              ],
            ),
          ),
          sizeVer(10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              '${widget.post.totalLikes} likes',
              style: const TextStyle(
                  color: tPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          sizeVer(5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
                  '${widget.post.username}',
                  style: const TextStyle(
                      color: tPrimaryColor, fontWeight: FontWeight.bold),
                ),
                sizeHor(8.0),
                Expanded(
                  child: Text(
                    '${widget.post.description}',
                    style: const TextStyle(color: tPrimaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          sizeVer(5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View all ${widget.post.totalComments} comments',
                  style: const TextStyle(color: tDarkGreyColor),
                ),
                sizeVer(8.0),
                Text(
                  DateFormat('dd/MMM/yyy')
                      .format(widget.post.createAt!.toDate()),
                  style: const TextStyle(color: tDarkGreyColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _openBottomModalSheet(BuildContext context) {
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
                          'Delete post',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: _deletePost,
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
                          'Update Post',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                      pushNamedToPage(
                        context,
                        PageConst.updatePostPage,
                        arguments: widget.post,
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

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
    popBack(context);
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
        post: PostEntity(
      postId: widget.post.postId,
    ));
  }
}
