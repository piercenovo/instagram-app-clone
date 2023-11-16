import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/user/presentation/widgets/form_container_widget.dart';

class CommentPostPage extends StatefulWidget {
  const CommentPostPage({super.key});

  @override
  State<CommentPostPage> createState() => _CommentPostPageState();
}

class _CommentPostPageState extends State<CommentPostPage> {
  bool _isUserReplaying = false;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: tSecondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    sizeHor(10),
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: tPrimaryColor,
                      ),
                    ),
                  ],
                ),
                sizeVer(10),
                const Text(
                  'This is very beatiful place',
                  style: TextStyle(
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: tSecondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  sizeHor(10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: tPrimaryColor,
                                ),
                              ),
                              Icon(Boxicons.bx_heart,
                                  size: 20, color: tDarkGreyColor),
                            ],
                          ),
                          sizeVer(4),
                          const Text(
                            'This is comment',
                            style: TextStyle(color: tPrimaryColor),
                          ),
                          sizeVer(4),
                          Row(
                            children: [
                              const Text(
                                '08/07/2023',
                                style: TextStyle(
                                  color: tDarkGreyColor,
                                  fontSize: 12,
                                ),
                              ),
                              sizeHor(15),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isUserReplaying = !_isUserReplaying;
                                  });
                                },
                                child: const Text(
                                  'Replay',
                                  style: TextStyle(
                                    color: tDarkGreyColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              sizeHor(15),
                              const Text(
                                'View Replays',
                                style: TextStyle(
                                  color: tDarkGreyColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          _isUserReplaying ? sizeVer(10) : sizeVer(0),
                          _isUserReplaying
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const FormContainerWidget(
                                      hintText: 'Post your replay...',
                                    ),
                                    sizeVer(10),
                                    const Text(
                                      'Post',
                                      style: TextStyle(color: tBlueColor),
                                    ),
                                  ],
                                )
                              : const SizedBox(width: 0, height: 0),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _commentSection(),
        ],
      ),
    );
  }

  _commentSection() {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            sizeHor(10),
            const Expanded(
              child: TextField(
                style: TextStyle(color: tPrimaryColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Post your comment...',
                  hintStyle: TextStyle(color: tSecondaryColor),
                ),
              ),
            ),
            const Text(
              'Post',
              style: TextStyle(fontSize: 15, color: tBlueColor),
            ),
          ],
        ),
      ),
    );
  }
}
