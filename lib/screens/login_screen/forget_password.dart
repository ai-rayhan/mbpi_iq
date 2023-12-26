
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbpi_iq/componants/snakbar.dart';



class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
    bool  isloading = false;

  resetPassword(_email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email!);
      showSnackBar(message:
        "Sent! Please Check Your Email",context:
        context,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(message:
          'No user found with this email address',
         context: context,haserror: true
        );
      } else {
        showSnackBar(
        message:  e.message!,
         context: context,haserror: true
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
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
                    const SizedBox(height: 50),
                    Text(
                      "Forgot Your Password?",
                      style: TextStyle(fontSize: 21),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter the email associated with your account, we will send a verification Link.",
                      style:  TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(label: Text("Email Address"),border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                ),),
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:isloading?Center(child: CircularProgressIndicator()): ElevatedButton(
                  child:Text( "Send Link"),
                  onPressed: () async{
                    final email = emailController.text.trim();
                    if (email.isNotEmpty && email.contains('@')) {
                      setState(() {
                        isloading = true;
                      });
                     await resetPassword(email);
                      setState(() {
                        isloading = false;
                      });
                    } else {
                      showSnackBar(message:"Enter a valid Email",context: context,haserror: true);
                    }
                  },
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
