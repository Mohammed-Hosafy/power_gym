import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'home.dart';
import 'workouts.dart';
import 'schedule.dart';
import 'progress.dart';
import 'profile.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget bodyContent;
  final int selectedIndex;

  const AppScaffold({
    super.key,
    required this.title,
    required this.bodyContent,
    required this.selectedIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const HomePage();
        break;
      case 1:
        nextPage = const WorkoutsPage();
        break;
      case 2:
        nextPage = const SchedulePage();
        break;
      case 3:
        nextPage = const ProgressPage();
        break;
      case 4:
        nextPage = const ProfilePage();
        break;
      default:
        nextPage = const HomePage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextPage,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),

      // Drawer
      drawer: Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
              ),
              child: Center(
                child: Text(
                  "MENU",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            _drawerItem(context, "Home", Icons.home, 0),
            _drawerItem(context, "Workouts", Icons.fitness_center, 1),
            _drawerItem(context, "Schedule", Icons.schedule, 2),
            _drawerItem(context, "Progress", Icons.bar_chart, 3),
            _drawerItem(context, "Profile", Icons.person, 4),
          ],
        ),
      ),

      body: bodyContent,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _navigate(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Workouts"),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, IconData icon, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _navigate(context, index);
      },
    ).animate().fade(duration: 500.ms).slideX(begin: -0.3, end: 0);
  }
}
