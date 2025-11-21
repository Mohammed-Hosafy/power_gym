import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  String goal = "Maintenance";
  String mode = "me";
  String result = "";

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


  void calculateDiet() {
    double weight = double.tryParse(weightCtrl.text) ?? 0;
    double height = double.tryParse(heightCtrl.text) ?? 0;
    double age = double.tryParse(ageCtrl.text) ?? 0;

    if (weight <= 0 || height <= 0 || age <= 0) {
      setState(() {
        result = "Please enter valid values!";
      });
      return;
    }


    double bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;

    double calories = bmr;

    if (goal == "Cutting") calories *= 0.80;
    else if (goal == "Bulking") calories *= 1.15;

    double protein = calories * 0.30 / 4;
    double carbs = calories * 0.45 / 4;
    double fats = calories * 0.25 / 9;

    setState(() {
      result =
      "Daily Calories: ${calories.toStringAsFixed(0)} kcal\n\n"
          "🥩 Protein: ${protein.toStringAsFixed(0)} g\n"
          "🍚 Carbs: ${carbs.toStringAsFixed(0)} g\n"
          "🥑 Fats: ${fats.toStringAsFixed(0)} g";
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
                    "DIET PLAN",
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

                        _buildDropdown(
                          "Goal",
                          goal,
                          ["Cutting", "Bulking", "Maintenance"],
                              (v) => setState(() => goal = v!),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: calculateDiet,
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
                            effects: [FadeEffect(duration: Duration(milliseconds: 800))],
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.redAccent, width: 1),
                              ),
                              child: Text(
                                result,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.white,
                                ),
                              ),
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

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent, width: 1),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.black,
        iconEnabledColor: Colors.white,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        onChanged: onChanged,
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
