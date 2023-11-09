import 'package:flutter/material.dart';
import 'package:instagram_app/core/helpers/on_generate_route.dart';
import 'package:instagram_app/core/utils/theme/theme.dart';
import 'package:instagram_app/features/home/presentation/pages/main/main_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram App',
      theme: theme(),
      darkTheme: ThemeData.dark(),
      onGenerateRoute: OnGenerateRoute.route,
      initialRoute: "/",
      routes: {
        "/": (context) {
          return const MainPage();
        }
      },
    );
  }
}
