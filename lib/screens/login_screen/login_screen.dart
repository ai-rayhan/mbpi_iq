import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbpi_iq/componants/colors.dart';
import 'package:mbpi_iq/componants/snakbar.dart';
import 'package:mbpi_iq/screens/live_exam_screen/live_exam_screen.dart';

import '../signup_screen/signup_screen.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      // If login is successful, you can navigate to the next screen or perform other actions.
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      );
      print('User logged in: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
            message: 'No user found for that email.', context: context);
      } else if (e.code == 'wrong-password') {
        showSnackBar(
            message: 'Wrong password provided for that user.',
            context: context);
      } else {
        showSnackBar(message: 'An error occur', context: context);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        color: AppColors.primaryColor,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:  Text(
                            "Welcome Back!",
                            style: TextStyle(
                                fontSize: 27,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Login to your MBPI IQ Profiler account",
                          style: TextStyle(
                              color: Color(0xF85A5A5A),
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email address",
                              hintText: "Email address",
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(
                              //       10.0), // Adjust the radius as needed
                              // ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter your email address';
                              }
                              // You can add more email validation if needed.
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: showPassword
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(
                              //       10.0), // Adjust the radius as needed
                              // ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              // You can add more password validation if needed.
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
                                  child: const Text("Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _signInWithEmailAndPassword();
                                    }
                                  },
                                ),
                          const SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Forgot Your Password?',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 155, 155, 155),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 70),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(color: Colors.grey),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
