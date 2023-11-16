import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/features/post/presentation/widgets/upload_post_main_widget.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class UploadPostPage extends StatelessWidget {
  final UserEntity currentUser;

  const UploadPostPage({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),
    );
  }
}
