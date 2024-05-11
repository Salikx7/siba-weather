import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:siba_weather/firebase_options.dart';
import 'package:siba_weather/screens/signIn.dart';
import 'package:siba_weather/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi_Weather',
      theme: ThemeData(
          // Your theme configuration goes here
          ),
      initialRoute: '/home',
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
        // Add more routes here if needed
      },
    );
  }
}
