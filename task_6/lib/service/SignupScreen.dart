import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_6/service/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_6/service/authService.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  String _selectedRole = 'Buyer';

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = await _authService.signUpWithEmail(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _selectedRole,
        );
        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          // Handle sign up failure
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sign up')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildRoleButton(String role, String label) {
    bool isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = role;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? Color.fromRGBO(63, 26, 92, 1) : Colors.white,
            border: Border.all(
              color: Color.fromRGBO(63, 26, 92, 1),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color:
                    isSelected ? Colors.white : Color.fromRGBO(63, 26, 92, 1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
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
                  SizedBox(height: 60),
                  Icon(
                    Icons.person,
                    color: Color.fromRGBO(63, 26, 92, 1),
                    size: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "SIGNUP",
                      style: GoogleFonts.inter(
                          color: Color.fromRGBO(63, 26, 92, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Card(
                    color: Colors.white,
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your full name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
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
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoleButton('Buyer', 'Buyer'),
                      SizedBox(width: 10),
                      _buildRoleButton('Seller', 'Seller'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "By signing up you agree to our Terms, Privacy Policy and Cookie Use.",
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(63, 26, 92, 1),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                      ),
                      child: Text(
                        "Create an account",
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Adjust the height if needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Login",
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
