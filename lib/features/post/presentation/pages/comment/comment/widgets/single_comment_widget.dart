import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:instagram_app/features/user/presentation/widgets/form_container_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    this.onLongPressListener,
    this.onLikeClickListener,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;

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
    return InkWell(
      onLongPress: widget.onLongPressListener,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.comment.userProfileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.comment.username}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: tPrimaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                              widget.comment.likes!.contains(_currentUid)
                                  ? Boxicons.bxs_heart
                                  : Boxicons.bx_heart,
                              size: 20,
                              color: widget.comment.likes!.contains(_currentUid)
                                  ? tHeartColor
                                  : tDarkGreyColor),
                        ),
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      '${widget.comment.description}',
                      style: const TextStyle(color: tPrimaryColor),
                    ),
                    sizeVer(4),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd/MMM/yyy')
                              .format(widget.comment.createAt!.toDate()),
                          style: const TextStyle(
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
    );
  }
}
