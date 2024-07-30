import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_6/service/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(63, 26, 92, 1),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 300,
            ),
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              weight: 200,
              size: 200,
            ),
            SizedBox(
              height: 250,
            ),
            Text('Abeerah Saleem | @code.abby',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 25),
          ]),
        ));
  }
}
