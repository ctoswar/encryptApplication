import 'package:flutter/material.dart';
import 'package:flutterencryption/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repassController = TextEditingController();

//signUp button
  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (passwordController.text != repassController.text) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password Don't match!"),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpwtihEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (ex) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.toString()),
        ),
      );
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  //logo
                  //logo
                  Container(
                    height: 80,
                    child: Image.asset('assets/logo.png'),
                  ),
                  //logo

                  const SizedBox(height: 50),
                  //Welcome back
                  const Text(
                    "Let's create an Account for you!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  //input

                  //email
                  MyTextField(
                    controller: emailController,
                    hint: 'Email',
                    obscureText: false,
                    background: const Color(0xFFE2EBF0),
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(9.0),
                  ),

                  const SizedBox(height: 10),
                  //password
                  MyTextField(
                    controller: passwordController,
                    hint: 'Password',
                    obscureText: true,
                    background: const Color(0xFFE2EBF0),
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(9.0),
                  ),

                  const SizedBox(height: 10),
                  //repass
                  MyTextField(
                    controller: repassController,
                    hint: 'Confirm Password',
                    obscureText: true,
                    background: const Color(0xFFE2EBF0),
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  //input

                  const SizedBox(height: 25),
                  //signun
                  MyButton(
                    onTap: signUp,
                    text: "Sign Up",
                    backgroundColor: const Color(0xFFEB455F),
                  ),

                  const SizedBox(height: 50),
                  //register

                  //SIGN IN ROW
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 13), // Add bottom padding of 10
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  //SIGN IN ROW
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
