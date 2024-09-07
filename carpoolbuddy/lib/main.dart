import 'package:carpoolbuddy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/landing_page.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CarpoolBuddyApp());
}

class CarpoolBuddyApp extends StatelessWidget {
  const CarpoolBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: const MaterialApp(
        title: 'CarpoolBuddy',
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
      ),
    );
  }
}
