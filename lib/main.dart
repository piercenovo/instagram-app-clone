import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/theme/theme.dart';
import 'package:instagram_app/features/home/presentation/screens/main/main_screen.dart';

void main() {
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
      home: const MainScreen(),
    );
  }
}
