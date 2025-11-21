import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardioPage extends StatefulWidget {
  const CardioPage({super.key});

  @override
  State<CardioPage> createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  String goal = "Cutting";
  String result = "";
  String mode = "me";

  @override
  void initState() {
    super.initState();
    mode = "me";
  }

  void switchMode(String m) {
    if (mode == m) return;
    mode = m;
    result = "";
    weightCtrl.clear();
    heightCtrl.clear();
    ageCtrl.clear();
    setState(() {});
  }


  void calculateCardio() {
    double weight = double.tryParse(weightCtrl.text) ?? 0;
    double height = double.tryParse(heightCtrl.text) ?? 1;
    double age = double.tryParse(ageCtrl.text) ?? 0;

    if (weight <= 0 || height <= 0 || age <= 0) {
      setState(() {
        result = "Please enter valid values!";
      });
      return;
    }


    double bmi = weight / ((height / 100) * (height / 100));


    int duration = 0;
    int days = 0;

    if (goal == "Cutting") {
      if (bmi > 25) {
        duration = 45;
        days = 6;
      } else if (bmi >= 18 && bmi <= 25) {
        duration = 30;
        days = 5;
      } else {
        duration = 25;
        days = 4;
      }
    } else if (goal == "Bulking") {
      duration = 25;
      days = 3;
    } else {
      duration = 30;
      days = 4;
    }


    if (age < 25) {
      duration += 5;
      days += 1;
    } else if (age >= 25 && age <= 35) {

    } else if (age >= 36 && age <= 45) {
      duration -= 5;
    } else if (age > 45) {
      duration -= 10;
      days -= 1;
    }

    if (weight > 150) {
      duration += 10;
      days += 1;
    } else if (weight >= 120 && weight <= 150) {
      duration += 5;
    }


    double walk = duration * 0.40;
    double run = duration * 0.30;
    double cycle = duration * 0.30;


    setState(() {
      result =
      "BMI: ${bmi.toStringAsFixed(1)}\n\n"
          "1️⃣ Walking — ${walk.toStringAsFixed(0)} min — $days days/week\n"
          "2️⃣ Running — ${run.toStringAsFixed(0)} min — $days days/week\n"
          "3️⃣ Cycling — ${cycle.toStringAsFixed(0)} min — $days days/week";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1C1C1C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    "CARDIO PLAN",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => switchMode("me"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          mode == "me" ? Colors.redAccent : Colors.grey[800],
                        ),
                        child: const Text("For Me"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => switchMode("friend"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          mode == "friend" ? Colors.redAccent : Colors.grey[800],
                        ),
                        child: const Text("For Friend"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildField(weightCtrl, "Weight (kg)"),
                        _buildField(heightCtrl, "Height (cm)"),
                        _buildField(ageCtrl, "Age"),
                        const SizedBox(height: 10),
                        _buildDropdown(),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: calculateCardio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              mode == "me" ? "START (Me)" : "START (Friend)",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (result.isNotEmpty)
                          Animate(
                            effects: [
                              FadeEffect(duration: Duration(milliseconds: 800))
                            ],
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.redAccent, width: 1),
                              ),
                              child: Text(result,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[900],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent, width: 1),
      ),
      child: DropdownButton<String>(
        value: goal,
        dropdownColor: Colors.black,
        iconEnabledColor: Colors.white,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: "Cutting", child: Text("Cutting")),
          DropdownMenuItem(value: "Bulking", child: Text("Bulking")),
          DropdownMenuItem(value: "Maintenance", child: Text("Maintenance")),
        ],
        onChanged: (v) {
          goal = v!;
          result = "";
          setState(() {});
        },
        isExpanded: true,
      ),
    );
  }

  @override
  void dispose() {
    weightCtrl.dispose();
    heightCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }
}
