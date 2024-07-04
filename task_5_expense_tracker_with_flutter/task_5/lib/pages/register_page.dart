import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_5/components/buttons.dart';
import 'package:task_5/components/textfields.dart';
import 'package:task_5/firebase_options.dart';
import 'package:task_5/helper/helper_function.dart';
import 'package:task_5/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controller
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmpasswordController =
      TextEditingController();

  void register() async {
    //loading
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //password match
    if (passwordController.text != confirmpasswordController.text) {
      //loading
      Navigator.pop(context);
      //error
      displayMessageToUser("Passwords don't match", context);
    }
    //create user
    else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
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
                  MyTextField(
                      hintText: "Confirm Password",
                      obscureText: true,
                      controller: confirmpasswordController),

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
                  //sign up button
                  MyButton(text: 'Register', onTap: register),
                  const SizedBox(
                    height: 25,
                  ),
                  //sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login here",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
