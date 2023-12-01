import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:intl/intl.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class SingleReplayWidget extends StatefulWidget {
  final ReplayEntity replay;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;

  const SingleReplayWidget({
    super.key,
    required this.replay,
    this.onLongPressListener,
    this.onLikeClickListener,
  });

  @override
  State<SingleReplayWidget> createState() => _SingleReplayWidgetState();
}

class _SingleReplayWidgetState extends State<SingleReplayWidget> {
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
      onLongPress: widget.replay.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, top: 10.0),
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
                  child: profileWidget(imageUrl: widget.replay.userProfileUrl),
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
                          '${widget.replay.username}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: tPrimaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                              widget.replay.likes!.contains(_currentUid)
                                  ? Boxicons.bxs_heart
                                  : Boxicons.bx_heart,
                              size: 20,
                              color: widget.replay.likes!.contains(_currentUid)
                                  ? tHeartColor
                                  : tDarkGreyColor),
                        ),
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      '${widget.replay.description}',
                      style: const TextStyle(color: tPrimaryColor),
                    ),
                    sizeVer(4),
                    Text(
                      DateFormat('dd/MMM/yyy')
                          .format(widget.replay.createAt!.toDate()),
                      style: const TextStyle(
                        color: tDarkGreyColor,
                        fontSize: 12,
                      ),
                    ),
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
