import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/edit_comment/widgets/edit_comment_main_widget.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;

  const EditCommentPage({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentMainWidget(
        comment: comment,
      ),
    );
  }
}
