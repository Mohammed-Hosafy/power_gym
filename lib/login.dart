import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _rand = Random();
  final int bubbleCount = 25;
  late List<Bubble> bubbles;

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    bubbles = List.generate(
        bubbleCount,
            (index) => Bubble(
            x: _rand.nextDouble(),
            y: _rand.nextDouble(),
            radius: _rand.nextDouble() * 6 + 2,
            speed: _rand.nextDouble() * 0.5 + 0.2));
  }

  @override
  void dispose() {
    _controller.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      {required TextEditingController ctrl,
        required String hint,
        bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, List<Color> colors) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onPressed,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= Firebase Login ===================
  Future<void> _login() async {
    String username = usernameCtrl.text.trim();
    String password = passwordCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    try {
      DocumentSnapshot userDoc =
      await firestore.collection('users').doc(username).get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found")),
        );
        return;
      }

      String storedPassword = userDoc.get('password');

      if (storedPassword != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect password")),
        );
        return;
      }

      // الدخول ناجح - تمرير username ديناميكياً
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: username)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          for (var b in bubbles) {
            b.y -= b.speed / 100;
            if (b.y < 0) b.y = 1;
          }

          return Stack(
            children: [
              Container(color: Colors.black),
              CustomPaint(
                painter: BubblePainter(bubbles),
                size: Size.infinite,
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "💪 POWER GYM",
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                            letterSpacing: 2,
                          ),
                        ).animate()
                            .fade(duration: 700.ms)
                            .scaleXY(begin: 0.8, end: 1.0, duration: 700.ms),
                        const SizedBox(height: 40),
                        _buildTextField(ctrl: usernameCtrl, hint: "Username")
                            .animate()
                            .fade(duration: 500.ms)
                            .slideX(begin: -0.3, end: 0),
                        const SizedBox(height: 20),
                        _buildTextField(
                            ctrl: passwordCtrl,
                            hint: "Password",
                            obscure: true)
                            .animate()
                            .fade(duration: 500.ms)
                            .slideX(begin: -0.3, end: 0),
                        const SizedBox(height: 30),
                        _buildButton(
                          "LOGIN",
                          _login,
                          [Colors.deepOrange.shade400, Colors.orange.shade300],
                        ).animate().fade(duration: 500.ms).slideY(begin: 0.5, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Bubble {
  double x;
  double y;
  double radius;
  double speed;
  Bubble(
      {required this.x, required this.y, required this.radius, required this.speed});
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);
    for (var b in bubbles) {
      canvas.drawCircle(
          Offset(b.x * size.width, b.y * size.height), b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
