import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;
import 'package:instagram_app/features/post/presentation/pages/comment/edit_replay/widgets/edit_replay_main_page.dart';

class EditReplayPage extends StatelessWidget {
  final ReplayEntity replay;

  const EditReplayPage({Key? key, required this.replay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplayCubit>(
      create: (context) => di.sl<ReplayCubit>(),
      child: EditReplayMainWidget(replay: replay),
    );
  }
}
