import 'package:flutter/material.dart';
import 'login.dart';
import 'SignUp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:octo_image/octo_image.dart';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _rand = Random();
  final int bubbleCount = 50;
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
    super.dispose();
  }

  Widget gradientButton(String text, List<Color> colors, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: SizedBox(
              width: 220,
              height: 60,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
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
      body: AnimatedBuilder(
        animation: _controller,   //repaint
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade900,
                          child: ClipOval(
                            child: OctoImage(
                              image: const AssetImage('assets/images/LOGO.jpeg'),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              errorBuilder: OctoError.icon(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          "💪 POWER GYM",
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(height: 20),

                        AnimatedTextKit(
                          animatedTexts: [
                            FadeAnimatedText(
                              'Welcome to Power Gym!',
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                              duration: const Duration(milliseconds: 2000),
                            ),
                            FadeAnimatedText(
                              'Your journey starts here.',
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                              duration: const Duration(milliseconds: 2000),
                            ),
                            FadeAnimatedText(
                              '🏋️‍♂️ Train Smart. Stay Strong. 💥',
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              duration: const Duration(milliseconds: 2000),
                            ),
                          ],
                          repeatForever: true,
                        ),
                        const SizedBox(height: 50),

                        gradientButton(
                          "LOGIN",
                          [Colors.deepOrange.shade400, Colors.orange.shade300],
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        gradientButton(
                          "SIGN UP",
                          [Colors.blue.shade400, Colors.purple.shade300],
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()),
                            );
                          },
                        ),
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
  Bubble({required this.x, required this.y, required this.radius, required this.speed});
}


class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);
    for (var b in bubbles) {
      canvas.drawCircle(Offset(b.x * size.width, b.y * size.height), b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
