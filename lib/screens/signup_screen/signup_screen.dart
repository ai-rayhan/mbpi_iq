import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbpi_iq/componants/colors.dart';
import 'package:mbpi_iq/componants/snakbar.dart';
import 'package:mbpi_iq/screens/live_exam_screen/live_exam_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController shiftController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  bool isLoading = false;
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    shiftController.dispose();
    rollController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        color: AppColors.primaryColor,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Get Started Now!",
                              style: TextStyle(
                                  fontSize: 27,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        )),
                    const SizedBox(height: 16),
                    const Text(
                        "Enter your details to sign up on MBPI IQ Profiler",
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
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                            hintText: "Your Name*",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            hintText: "Email address*",
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
                          controller: rollController,
                          decoration: const InputDecoration(
                            labelText: 'Enter roll number',
                            hintText: "Enter roll number*",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Enter roll number';
                            }
                            // You can add more email validation if needed.
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: semesterController,
                          decoration: const InputDecoration(
                            labelText: 'Enter semester',
                            hintText: "Enter semester*",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your semester';
                            }
                            // You can add more email validation if needed.
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: shiftController,
                          decoration: const InputDecoration(
                            labelText: 'Enter shift',
                            hintText: "Enter shift*",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your shift';
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
                            labelText: 'Password',
                            hintText: "Password*",
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
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            // You can add more password validation if needed.
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !showConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            hintText: "Confirm password*",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                              icon: showConfirmPassword
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                child: const Text("Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  _signUpWithEmailAndPassword();
                                },
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        // color: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;
  Future<void> _signUpWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (_formKey.currentState!.validate()) {
        final email = emailController.text;
        final password = passwordController.text;

        // Create user with email and password using Firebase Authentication
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
        _addUserData(userCredential.user);
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(
            message: 'The password provided is too weak.', context: context);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            message: 'The account already exists for that email.',
            context: context,
            haserror: true);
      }
    } catch (e) {
      showSnackBar(message: 'An error occur', context: context, haserror: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addUserData(User? user) async {
    try {
      if (user != null) {
        String userId = user.uid;
        String name = nameController.text.trim();
        String email = emailController.text.trim();

        // Create a reference to the document path using the user's ID
        DocumentReference userDocRef =
            firestore.collection('users').doc(userId);

        // Set user data in Firestore
        await userDocRef.set({
          'name': name,
          'email': email,
          'roll': rollController.text,
          'semester': semesterController.text,
          'shift': shiftController.text,
          'isadmin': false,
        });

        print('User data added successfully!');
      }
    } catch (e) {
      print('Error adding user data: $e');
      // Handle errors here
    }
  }
}
