import 'package:flutter/material.dart';
import 'package:instagram_app/features/auth/presentation/screens/main/main_screen.dart';

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
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
