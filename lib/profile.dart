import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.username)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          nameController.text = data['name'] ?? '';
          heightController.text = (data['height'] ?? '').toString();
          weightController.text = (data['weight'] ?? '').toString();
          passwordController.text = data['password'] ?? '';
          selectedGoal = data['goal'] ?? 'Cutting';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> saveUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.username).set({
        'name': nameController.text,
        'height': double.tryParse(heightController.text) ?? 0,
        'weight': double.tryParse(weightController.text) ?? 0,
        'password': passwordController.text,
        'goal': selectedGoal ?? 'Cutting',
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      debugPrint("Error saving user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.black;
    final Color cardColor = Colors.grey.shade900;
    final Color textColor = Colors.white;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    return AppScaffold(
      title: "Profile",
      selectedIndex: 4,
      username: widget.username,
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
              ),
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
                onPressed: () async {
                  setState(() {
                    if (isEditing) {
                      saveUserData();
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
              ),
            ],
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
      Color textColor) {
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
