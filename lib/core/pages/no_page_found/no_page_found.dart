import 'package:flutter/material.dart';

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page not Found'),
      ),
      body: const Center(
        child: Text("Page not found"),
      ),
    );
  }
}
