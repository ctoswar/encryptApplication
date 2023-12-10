import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterencryption/components/my_button.dart';

import '../components/my_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password link send! check on your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2EBF0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'Enter your email to reset password',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 50),
                  MyTextField(
                    // Use MyTextField widget here
                    controller: emailController,
                    hint: 'Email',
                    obscureText: false,
                    background: const Color(0xFFE2EBF0),
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    // Use MyButton widget here
                    backgroundColor: const Color(0xFFEB455F),
                    onTap: passwordReset,
                    text: 'Reset Password',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
