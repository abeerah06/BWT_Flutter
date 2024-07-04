import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_5/components/buttons.dart';
import 'package:task_5/components/textfields.dart';
import 'package:task_5/firebase_options.dart';
import 'package:task_5/helper/helper_function.dart';
import 'package:task_5/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controller
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.teal[700],
                ),
                const SizedBox(
                  height: 25,
                ),
                //app name
                Text(
                  'EXPENSE TRACKER',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 50,
                ),
                //email
                MyTextField(
                    hintText: "Enter your email",
                    obscureText: false,
                    controller: emailController),
                const SizedBox(
                  height: 10,
                ),
                //password
                MyTextField(
                    hintText: "Enter your Password",
                    obscureText: true,
                    controller: passwordController),

                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black45),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                //sign in button
                MyButton(text: 'Login', onTap: login),
                const SizedBox(
                  height: 25,
                ),
                //sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    //switch to sign up page
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
