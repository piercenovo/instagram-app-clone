import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/core/entities/app_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/comment/widgets/comment_main_widget.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;

  const CommentPage({
    super.key,
    required this.appEntity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.sl<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
