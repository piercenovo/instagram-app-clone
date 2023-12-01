import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/comment/widgets/single_replay_widget.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:instagram_app/features/user/presentation/widgets/form_container_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity? currentUser;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    this.onLongPressListener,
    this.onLikeClickListener,
    this.currentUser,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController _replayDescriptionController =
      TextEditingController();

  bool _isUserReplaying = false;
  bool _isViewReplays = false;

  String _currentUid = '';

  @override
  void dispose() {
    _replayDescriptionController.dispose();
    super.dispose();
  }

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
      onLongPress: widget.comment.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profileWidget(imageUrl: widget.comment.userProfileUrl),
                ),
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isViewReplays = !_isViewReplays;
                            });
                            _isViewReplays
                                ? BlocProvider.of<ReplayCubit>(context)
                                    .getReplays(
                                        replay: ReplayEntity(
                                    postId: widget.comment.postId,
                                    commentId: widget.comment.commentId,
                                  ))
                                : null;
                          },
                          child: const Text(
                            'View Replays',
                            style: TextStyle(
                              color: tDarkGreyColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _isViewReplays
                        ? BlocConsumer<ReplayCubit, ReplayState>(
                            listener: (context, replayState) {
                              if (replayState is ReplayLoaded) {
                                final replays = replayState.replays;

                                replays.isEmpty ? toast('No replays') : null;
                              }
                            },
                            builder: (context, replayState) {
                              if (replayState is ReplayLoaded) {
                                final replays = replayState.replays
                                    .where((element) =>
                                        element.commentId ==
                                        widget.comment.commentId)
                                    .toList();

                                if (replays.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: replays.length,
                                  itemBuilder: (context, index) {
                                    return SingleReplayWidget(
                                      replay: replays[index],
                                      onLongPressListener: () {
                                        _openBottomModalSheet(
                                          context: context,
                                          replay: replays[index],
                                        );
                                      },
                                      onLikeClickListener: () {
                                        _likeReplay(replay: replays[index]);
                                      },
                                    );
                                  },
                                );
                              }
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: 40,
                                  height: 40,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    _isUserReplaying ? sizeVer(10) : sizeVer(0),
                    _isUserReplaying
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FormContainerWidget(
                                hintText: 'Post your replay...',
                                controller: _replayDescriptionController,
                              ),
                              sizeVer(10),
                              GestureDetector(
                                onTap: () {
                                  _createReplay();
                                },
                                child: const Text(
                                  'Post',
                                  style: TextStyle(color: tBlueColor),
                                ),
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

  _createReplay() {
    BlocProvider.of<ReplayCubit>(context)
        .createReplay(
      replay: ReplayEntity(
        replayId: const Uuid().v1(),
        createAt: Timestamp.now(),
        likes: const [],
        username: widget.currentUser!.username,
        userProfileUrl: widget.currentUser!.profileUrl,
        creatorUid: widget.currentUser!.uid,
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _replayDescriptionController.text,
      ),
    )
        .then((value) {
      setState(() {
        _replayDescriptionController.clear();
        _isUserReplaying = false;
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required ReplayEntity replay}) {
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
                        const Icon(Boxicons.bx_message_detail,
                            color: tPrimaryColor, size: 20),
                        sizeHor(10),
                        const Text(
                          'Update replay',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                      pushNamedToPage(
                        context,
                        PageConst.updateReplayPage,
                        arguments: replay,
                      );
                    },
                  ),
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
                          'Delete replay',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                      _deleteReplay(replay: replay);
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

  _deleteReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).deleteReplay(
        replay: ReplayEntity(
      postId: replay.postId,
      commentId: replay.commentId,
      replayId: replay.replayId,
    ));
  }

  _likeReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(
        replay: ReplayEntity(
      postId: replay.postId,
      commentId: replay.commentId,
      replayId: replay.replayId,
    ));
  }
}
