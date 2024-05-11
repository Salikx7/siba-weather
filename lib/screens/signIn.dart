import 'package:flutter/material.dart';
import 'package:siba_weather/reusable_widgets/reusable_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    firebaseAuth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(245, 250, 224, 186), // Apply background color here
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              70, MediaQuery.of(context).size.height * 0.2, 70, 0),
          child: Column(
            children: <Widget>[
              logoWidget("assets/images/logo.png"),
              Text(
                "SIBA Weather",
                style: GoogleFonts.zenDots(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Column(
                children: <Widget>[
                  googleSignInButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget googleSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // Adjust the padding as needed
      child: SizedBox(
        height: 50, // Set the height to 50
        child: SignInButton(
          Buttons.google,
          text: "Sign Up with Google",
          onPressed: HandleGoogleSignIn,
        ),
      ),
    );
  }

  void HandleGoogleSignIn() async {
    await Firebase.initializeApp();
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      firebaseAuth.signInWithProvider(googleProvider);
    } catch (e) {
      print(e);
    }
  }
}
