import 'package:firebase_core/firebase_core.dart';
import 'package:task_5/auth/auth.dart';
import 'package:task_5/auth/login_or_register.dart';
import 'package:task_5/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:task_5/pages/home_page.dart';
import 'package:task_5/pages/login_page.dart';
import 'package:task_5/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
