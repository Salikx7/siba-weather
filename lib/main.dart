import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siba_weather/reusable_widgets/reusable_widget.dart';
import 'package:siba_weather/screens/signIn.dart';
import 'package:siba_weather/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is signed in
            return MaterialApp(
              home: HomeScreen(firstName: 'Agha'),
              title: 'Hi_Weather',
              theme: ThemeData(
                scaffoldBackgroundColor: Color(0xFFF4FFCD),
              ),
              initialRoute: '/home',
              routes: {
                '/signin': (context) => SignInScreen(),
                '/home': (context) => HomeScreen(firstName: 'Agha'),
              },
            );
          } else {
            // User is not signed in
            return MaterialApp(
              home: SignInScreen(),
              title: 'Hi_Weather',
              theme: ThemeData(
                scaffoldBackgroundColor: Color(0xFFF4FFCD),
              ),
              initialRoute: '/signin',
              routes: {
                '/signin': (context) => SignInScreen(),
                '/home': (context) => HomeScreen(firstName: 'Agha'),
              },
            );
          }
        } else {
          // Waiting for authentication state to be determined
          return MaterialApp(
            home: SplashScreen(),
            title: 'Hi_Weather',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xFFF4FFCD),
            ),
          );
        }
      },
    );
  }
}
