import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/core/helpers/on_generate_route.dart';
import 'package:instagram_app/core/pages/main/main_screen.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_app/features/user/presentation/pages/sign_in/sign_in_page.dart';
import 'package:instagram_app/core/helpers/firebase_options.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram App',
        theme: theme(),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: PageConst.initialRoute,
        routes: {
          PageConst.initialRoute: (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                }
                return const SignInPage();
              },
            );
          }
        },
      ),
    );
  }
}
