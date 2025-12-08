import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app_scaffold.dart';
import 'cardio.dart';
import 'diet.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // يحافظ على الحالة

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppScaffold(
      title: "Home",
      selectedIndex: 0,
      username: widget.username,
      bodyContent: Stack(
        children: [
          OctoImage(
            image: const AssetImage('assets/images/P3.png'),
            placeholderBuilder: (_) => const Center(child: CircularProgressIndicator()),
            errorBuilder: OctoError.icon(color: Colors.red),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Stay strong!",
                  style: GoogleFonts.poppins(
                      fontSize: 48,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ).animate().fade(duration: 500.ms).scaleXY(begin: 0.8, end: 1.0),
                const SizedBox(height: 10),
                Text(
                  "Start your journey to a stronger, healthier you! 💪",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _homeCard(context, "Cardio", Icons.directions_run, Colors.orange, Colors.red),
                    const SizedBox(width: 20),
                    _homeCard(context, "Diet", Icons.restaurant_menu, Colors.blue, Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeCard(BuildContext context, String title, IconData icon, Color start, Color end) {
    return GestureDetector(
      onTap: () {
        if (title == "Cardio") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CardioPage(username: widget.username)),
          );
        } else if (title == "Diet") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DietPage(username: widget.username)),
          );
        }
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [start, end]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ).animate().fade(duration: 500.ms).scaleXY(begin: 0.8, end: 1.0),
    );
  }
}
