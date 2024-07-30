// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_6/service/SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_6/module/seller/home_screen_dashboard.dart';
import 'package:task_6/module/buyer/homeScreen.dart';
import 'package:task_6/service/authService.dart';
import 'package:task_6/module/admin/adminScreen.dart'; //AdminScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = await _authService.signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        if (user != null) {
          // Check if the email is for admin
          if (_emailController.text == 'abeerasaleem06@gmail.com') {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      AdminScreen()), // Navigate to AdminScreen
              (Route<dynamic> route) => false,
            );
            return; // Exit the function to avoid further checks
          }

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          String role = userDoc['role'];

          if (role == 'Buyer') {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen(user)),
              (Route<dynamic> route) => false,
            );
          } else if (role == 'Seller') {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomeScreenDashboard(user)),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          // Handle login failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to log in')),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

//reset password
  Future<void> resetPassword(String email) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Notify user that email has been sent
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset email sent'),
      ));
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: Color.fromRGBO(63, 26, 92, 1),
                    size: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.inter(
                          color: Color.fromRGBO(63, 26, 92, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Card(
                    color: Colors.white,
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your email address",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Card(
                    color: Colors.white,
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your password",
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty) {
                            resetPassword(_emailController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please enter an email'),
                            ));
                          }
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(63, 26, 92, 1),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Adjust the height if needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.inter(
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(63, 26, 92, 1),
                          ),
                        ),
                      ),
                    ],
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
