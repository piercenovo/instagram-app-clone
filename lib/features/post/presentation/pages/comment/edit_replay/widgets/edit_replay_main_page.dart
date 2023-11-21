import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_app/features/user/presentation/widgets/button_container_widget.dart';

class EditReplayMainWidget extends StatefulWidget {
  final ReplayEntity replay;
  const EditReplayMainWidget({Key? key, required this.replay})
      : super(key: key);

  @override
  State<EditReplayMainWidget> createState() => _EditReplayMainWidgetState();
}

class _EditReplayMainWidgetState extends State<EditReplayMainWidget> {
  TextEditingController? _descriptionController;

  bool _isReplayUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.replay.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Edit Replay',
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
                _editReplay();
              },
            ),
            sizeVer(10),
            _isReplayUpdating
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

  _editReplay() {
    setState(() {
      _isReplayUpdating = true;
    });
    BlocProvider.of<ReplayCubit>(context)
        .updateReplay(
            replay: ReplayEntity(
                postId: widget.replay.postId,
                commentId: widget.replay.commentId,
                replayId: widget.replay.replayId,
                description: _descriptionController!.text))
        .then((value) {
      setState(() {
        _isReplayUpdating = false;
        _descriptionController!.clear();
      });
      popBack(context);
    });
  }
}
