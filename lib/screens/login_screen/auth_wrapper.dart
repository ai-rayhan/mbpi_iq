
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbpi_iq/screens/live_exam_screen/live_exam_screen.dart';
import 'package:mbpi_iq/screens/login_screen/login_screen.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}