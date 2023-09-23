import 'package:flutter/material.dart';
import 'package:flutterencryption/components/my_button.dart';
import 'package:flutterencryption/components/my_text_field.dart';
//import 'package:flutterencryption/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //signIN button
  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text);
      if (context.mounted) Navigator.pop(context);
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ex.toString(),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2EBF0),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                //logo
                const Icon(
                  Icons.message,
                  size: 80,
                ),

                const SizedBox(height: 50),
                //Welcome back
                const Text(
                  "Welcome to EncrypText!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                //email
                MyTextField(
                  controller: emailController,
                  hint: 'Email',
                  obscureText: false,
                  background: const Color(0xFFE2EBF0),
                ),

                const SizedBox(height: 10),
                //password
                MyTextField(
                  controller: passwordController,
                  hint: 'Password',
                  obscureText: true,
                  background: const Color(0xFFE2EBF0),
                ),

                const SizedBox(height: 25),
                //signin
                MyButton(onTap: signIn, text: "Sign In"),

                const SizedBox(height: 50),
                //register

                //SIGN UP ROW
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center-aligning the row content
                    children: [
                      const Text('Don' 't have an Account?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                //SIGN UP ROW
              ],
            ),
          ),
        ),
      ),
    );
  }
}
