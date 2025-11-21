import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final passwordController = TextEditingController();

  bool isEditing = false;
  String? selectedGoal;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.black;
    final Color cardColor = Colors.grey.shade900;
    final Color textColor = Colors.white;

    return AppScaffold(
      title: "Profile",
      selectedIndex: 4,
      bodyContent: Container(
        color: bgColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade800,
                child: ClipOval(
                  child: OctoImage(
                    image: const AssetImage('assets/images/LOGO.jpeg'),
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stack) => const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.9, end: 1.0),

              const SizedBox(height: 35),


              _buildField(Icons.person_outline, "Name", nameController,
                  "Enter your name", cardColor, textColor),
              _buildField(Icons.height, "Height (cm)", heightController,
                  "Enter your height", cardColor, textColor),
              _buildField(Icons.monitor_weight_outlined, "Weight (kg)",
                  weightController, "Enter your weight", cardColor, textColor),


              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flag_outlined,
                        color: Colors.orangeAccent, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGoal,
                        dropdownColor: Colors.grey.shade900,
                        decoration: InputDecoration(
                          labelText: "Goal",
                          labelStyle: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Cutting",
                            child: Text("Cutting",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: "Bulking",
                            child: Text("Bulking",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: "Maintenance",
                            child: Text("Maintenance",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                        onChanged: isEditing
                            ? (value) {
                          setState(() {
                            selectedGoal = value;
                          });
                        }
                            : null,
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              _buildField(Icons.lock_outline, "Password", passwordController,
                  "Enter new password", cardColor, textColor),

              const SizedBox(height: 25),


              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      debugPrint("✅ Saved Data:");
                      debugPrint("Name: ${nameController.text}");
                      debugPrint("Height: ${heightController.text}");
                      debugPrint("Weight: ${weightController.text}");
                      debugPrint("Goal: $selectedGoal");
                      debugPrint("Password: ${passwordController.text}");
                    }
                    isEditing = !isEditing;
                  });
                },
                child: Text(
                  isEditing ? "Save Changes" : "Edit Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(duration: 700.ms),
            ]
                .animate(interval: 120.ms)
                .fade(duration: 600.ms)
                .slide(begin: const Offset(0, 0.1)),
          ),
        ),
      ),
    );
  }


  Widget _buildField(
      IconData icon,
      String title,
      TextEditingController controller,
      String hint,
      Color cardColor,
      Color textColor,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEditing,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: title,
                labelStyle: GoogleFonts.poppins(
                    color: Colors.white70, fontWeight: FontWeight.w500),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
