import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:intl/intl.dart';

class SinglePostCardWidget extends StatelessWidget {
  final PostEntity post;

  const SinglePostCardWidget({
    super.key,
    required this.post,
  });

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
                          imageUrl: post.userProfileUrl,
                        ),
                      ),
                    ),
                    sizeHor(10),
                    Text(
                      '${post.username}',
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
          SizedBox(
            width: double.infinity,
            height: height * 0.3,
            child: profileWidget(imageUrl: post.postImageUrl),
          ),
          sizeVer(10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Boxicons.bx_heart, color: tPrimaryColor),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              '34 likes',
              style:
                  TextStyle(color: tPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          sizeVer(5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
                  '${post.username}',
                  style: const TextStyle(
                      color: tPrimaryColor, fontWeight: FontWeight.bold),
                ),
                sizeHor(8.0),
                Expanded(
                  child: Text(
                    '${post.description}',
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
                  'View all ${post.totalComments} comments',
                  style: const TextStyle(color: tDarkGreyColor),
                ),
                sizeVer(8.0),
                Text(
                  DateFormat('dd/MMM/yyy').format(post.createAt!.toDate()),
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
                        arguments: post,
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
}
