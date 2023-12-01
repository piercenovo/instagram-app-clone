import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/core/pages/profile/widgets/single_user_profile_main_widget.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

class SingleUserProfilePage extends StatelessWidget {
  final String otherUserId;
  const SingleUserProfilePage({
    super.key,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: SingleUserProfileMainWidget(otherUserId: otherUserId),
    );
  }
}
