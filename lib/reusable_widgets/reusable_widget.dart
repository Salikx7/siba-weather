import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

Image logoWidget(String imagePath) {
  return Image.asset(imagePath, fit: BoxFit.fitWidth, width: 240, height: 240);
}

Widget userInfo() {
  return SizedBox();
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
