import 'package:flutter/material.dart';
import 'welcome.dart';

void main() {
  runApp(const PowerGymApp());
}

class PowerGymApp extends StatelessWidget {
  const PowerGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Power Gym',
      theme: ThemeData.dark(),
      home: const WelcomeScreen(),
    );
  }
}


