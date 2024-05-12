import 'package:flutter/material.dart';

Image logoWidget(String imagePath) {
  return Image.asset(imagePath, fit: BoxFit.fitWidth, width: 240, height: 240);
}

Widget userInfo() {
  return const SizedBox();
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
