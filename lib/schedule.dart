import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app_scaffold.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String selectedGoal = 'Cutting';

  final Map<String, List<String>> goalWorkouts = {
    'Cutting': [
      'Full Body Cardio',
      'Legs Shred',
      'HIIT Burn',
      'Shoulders Cut',
      'Fat Blaster',
    ],
    'Bulking': [
      'Chest Power',
      'Back Builder',
      'Legs Strength',
      'Arms Pump',
      'Shoulders Press',
    ],
    'Maintenance': [
      'Core Stability',
      'Light Strength',
      'Mobility Flow',
      'Full Body Mix',
      'Cardio Balance',
    ],
  };

  final List<String> weekDays = const [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];


  int getSecondRestDay() {
    switch (selectedGoal) {
      case "Cutting":
        return 2; // Wednesday
      case "Bulking":
        return 1; // Tuesday
      case "Maintenance":
        return 3; // Thursday
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts = goalWorkouts[selectedGoal]!;

    return AppScaffold(
      title: "Schedule",
      selectedIndex: 2,
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔥 Your current goal: $selectedGoal",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ).animate().fade(duration: 500.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                goalButton("Cutting"),
                goalButton("Bulking"),
                goalButton("Maintenance"),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              selectedGoal == 'Cutting'
                  ? "Burn it to earn it 🔥"
                  : selectedGoal == 'Bulking'
                  ? "Lift heavy, grow strong 💪"
                  : "Stay consistent — balance is key ⚖️",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  bool isRestDay =
                      index == 4 || index == getSecondRestDay(); // Friday + second
                  String displayText =
                  isRestDay ? "Rest Day 😴" : workouts[index % workouts.length];

                  return dayCard(weekDays[index], displayText, isRestDay);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget goalButton(String goal) {
    bool isSelected = selectedGoal == goal;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: () {
        setState(() {
          selectedGoal = goal;
        });
      },
      child: Text(
        goal,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget dayCard(String day, String workout, bool isRestDay) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRestDay ? Colors.grey.shade700 : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(day, style: const TextStyle(color: Colors.white)),
        subtitle: Text(workout, style: const TextStyle(color: Colors.white70)),
        trailing: Icon(
          isRestDay ? Icons.hotel : Icons.fitness_center,
          color: Colors.orange,
        ),
      ),
    ).animate().fade(duration: 400.ms).slideX(begin: -0.2, end: 0);
  }
}
