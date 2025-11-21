import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home.dart';
import 'dart:math';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  String? selectedGoal;

  late AnimationController _controller;
  final Random _rand = Random();
  final int bubbleCount = 25;
  late List<Bubble> bubbles;

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
    dobController.dispose();
    usernameCtrl.dispose();
    nameCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
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
            borderSide: BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.orangeAccent, width: 2)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: dobController,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      onTap: () async {
        DateTime? d = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
        );
        if (d != null) {
          setState(() =>
          dobController.text = "${d.day}/${d.month}/${d.year}");
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade900,
        hintText: "Select Date of Birth",
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.orangeAccent, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  Widget _buildGoalDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(15)),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedGoal,
        hint: const Text("Select Goal", style: TextStyle(color: Colors.white38)),
        underline: const SizedBox(),
        dropdownColor: Colors.grey.shade900,
        style: const TextStyle(color: Colors.white),
        items: const [
          DropdownMenuItem(value: "Cutting", child: Text("Cutting")),
          DropdownMenuItem(value: "Bulking", child: Text("Bulking")),
          DropdownMenuItem(value: "Maintenance", child: Text("Maintenance")),
        ],
        onChanged: (v) => setState(() => selectedGoal = v),
      ),
    );
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ).animate().fade(duration: 500.ms).slideX(begin: -0.5, end: 0),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "CREATE ACCOUNT 💪",
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent),
                      ).animate().fade(duration: 700.ms).scaleXY(begin: 0.8, end: 1.0),
                      const SizedBox(height: 25),
                      _buildTextField(ctrl: usernameCtrl, hint: "Username")
                          .animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildTextField(ctrl: nameCtrl, hint: "Name")
                          .animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildDateField().animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildTextField(ctrl: heightCtrl, hint: "Height")
                          .animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildTextField(ctrl: weightCtrl, hint: "Weight")
                          .animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildGoalDropdown().animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildTextField(ctrl: passwordCtrl, hint: "Password", obscure: true)
                          .animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildTextField(ctrl: confirmCtrl, hint: "Confirm Password", obscure: true)
                          .animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        child: const Text("SIGN UP",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ).animate().fade(duration: 600.ms).slideY(begin: 0.5, end: 0),
                    ],
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
