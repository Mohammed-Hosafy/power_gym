import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';
import 'app_scaffold.dart';


class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  String selectedGoal = 'Cutting';

  final Map<String, List<Map<String, String>>> goalWorkouts = {
    'Cutting': [
      {'title': 'Full Body Cardio', 'video': 'assets/videos/FullBodyCardio.mp4'},
      {'title': 'Legs Shred', 'video': 'assets/videos/LegsShred.mp4'},
      {'title': 'HIIT Burn', 'video': 'assets/videos/HIITBurn.mp4'},
      {'title': 'Shoulders Cut', 'video': 'assets/videos/ShouldersCut.mp4'},
      {'title': 'Fat Blaster', 'video': 'assets/videos/FatBlaster.mp4'},
    ],
    'Bulking': [
      {'title': 'Chest Power', 'video': 'assets/videos/ChestPower.mp4'},
      {'title': 'Back Builder', 'video': 'assets/videos/BackBuilder.mp4'},
      {'title': 'Legs Strength', 'video': 'assets/videos/LegsStrength.mp4'},
      {'title': 'Arms Pump', 'video': 'assets/videos/ArmsPump.mp4'},
      {'title': 'Shoulders Press', 'video': 'assets/videos/ShouldersPress.mp4'},
    ],
    'Maintenance': [
      {'title': 'Core Stability', 'video': 'assets/videos/CoreStability.mp4'},
      {'title': 'Light Strength', 'video': 'assets/videos/LightStrength.mp4'},
      {'title': 'Mobility Flow', 'video': 'assets/videos/MobilityFlow.mp4'},
      {'title': 'Full Body Mix', 'video': 'assets/videos/FullBodyMix.mp4'},
      {'title': 'Cardio Balance', 'video': 'assets/videos/CardioBalance.mp4'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentWorkouts = goalWorkouts[selectedGoal]!;

    return AppScaffold(
      title: "Workouts",
      selectedIndex: 1,
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
              "🏋️ Recommended Workouts for You:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: currentWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = currentWorkouts[index];
                  return workoutCard(workout['title']!, workout['video']!);
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                selectedGoal == 'Cutting'
                    ? "Burn it to earn it 🔥"
                    : selectedGoal == 'Bulking'
                    ? "Lift heavy, grow strong 💪"
                    : "Stay consistent — balance is key ⚖️",
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.orangeAccent),
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

  Widget workoutCard(String title, String videoUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerPage(
              videoUrl: videoUrl,
              title: title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.play_circle_fill, color: Colors.orange),
        ),
      ),
    ).animate().fade(duration: 400.ms).slideX(begin: -0.2, end: 0);
  }
}

// ========================== VideoPlayerPage ==========================
class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({super.key, required this.videoUrl, required this.title});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : const CircularProgressIndicator(color: Colors.orange),
      ),
      floatingActionButton: _controller != null
          ? FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        onPressed: () {
          setState(() {
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              _controller!.play();
            }
          });
        },
      )
          : null,
    );
  }
}
