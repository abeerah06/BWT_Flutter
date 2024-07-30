import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_6/service/LoginScreen.dart';

class Logoutscreen extends StatelessWidget {
  const Logoutscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Log Out',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(63, 26, 92, 1),
        ),
      ),
      content: Text('Are you sure you want to log out?'),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            // Implement logout functionality
            FirebaseAuth.instance.signOut().then((_) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            });
          },
        ),
      ],
    );
  }
}
