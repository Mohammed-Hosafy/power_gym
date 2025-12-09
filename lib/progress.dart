import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_scaffold.dart';

class ProgressPage extends StatefulWidget {
  final String username;

  const ProgressPage({super.key, required this.username});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Stopwatch _stopwatch;
  late Timer _stopwatchTimer;
  String stopwatchTime = "00:00:00";

  Timer? countdownTimer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool timerRunning = false;
  Duration remainingTime = Duration.zero;

  final List<String> miniGoals = List.generate(
      100,
          (i) =>
      "Goal : ${[
        "Drink more water",
        "Do 10 push-ups",
        "Walk 15 minutes",
        "Stretch your back",
        "Eat one fruit",
        "Breathe deeply for 1 min",
        "Avoid sugar today",
        "Take the stairs",
        "Sleep early tonight",
        "Smile more today"
      ][i % 10]}");
  late String todayGoal;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_stopwatch.isRunning) {
        setState(() {
          final d = _stopwatch.elapsed;
          stopwatchTime =
          "${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
        });
      }
    });

    todayGoal = (miniGoals..shuffle()).first;
  }

  @override
  void dispose() {
    _stopwatchTimer.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      stopwatchTime = "00:00:00";
    });
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    setState(() {
      remainingTime = Duration(hours: hours, minutes: minutes, seconds: seconds);
      timerRunning = true;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() {
          timerRunning = false;
        });
      }
    });
  }

  void _resetCountdown() {
    countdownTimer?.cancel();
    setState(() {
      remainingTime = Duration.zero;
      timerRunning = false;
    });
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Progress",
      selectedIndex: 3,
      username: widget.username,
      bodyContent: LayoutBuilder(
        builder: (context, constraints) {
          final double boxHeight = constraints.maxHeight / 2;
          final double boxWidth = constraints.maxWidth / 2;

          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: boxWidth / boxHeight,
            children: [
              _buildBox(
                title: "⏱ Stopwatch",
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(stopwatchTime,
                        style: GoogleFonts.robotoMono(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _button(_stopwatch.isRunning ? "Pause" : "Start",
                            _toggleStopwatch, Colors.orange),
                        const SizedBox(width: 10),
                        _button("Reset", _resetStopwatch, Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              ),
              _buildBox(
                title: "⌛ Timer",
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTime(remainingTime),
                      style: GoogleFonts.robotoMono(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _timeField("H", (v) => hours = int.tryParse(v) ?? 0),
                        const SizedBox(width: 5),
                        _timeField("M", (v) => minutes = int.tryParse(v) ?? 0),
                        const SizedBox(width: 5),
                        _timeField("S", (v) => seconds = int.tryParse(v) ?? 0),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _button("Start", _startCountdown, Colors.orange),
                        const SizedBox(width: 10),
                        _button("Reset", _resetCountdown, Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              ),
              _buildBox(
                title: "🎯 Mini Goal",
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      todayGoal,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              _buildBox(
                title: "🎵 Relax Music",
                child: _buildMusicPlayer(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBox({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(child: child),
        ],
      ),
    ).animate().fade(duration: 500.ms).scaleXY(begin: 0.95, end: 1);
  }

  Widget _timeField(String hint, Function(String) onChanged) {
    return SizedBox(
      width: 45,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.black45,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        ),
      ),
    );
  }

  Widget _button(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(label,
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

Widget _buildMusicPlayer() => const MusicPlayerBox();

class MusicPlayerBox extends StatefulWidget {
  const MusicPlayerBox({super.key});

  @override
  State<MusicPlayerBox> createState() => _MusicPlayerBoxState();
}

class _MusicPlayerBoxState extends State<MusicPlayerBox> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  String? selectedTrack;

  final List<Map<String, String>> tracks = [
    {"name": "Calm Ocean", "file": "sounds/Music1.mp3"},
    {"name": "Soft Piano", "file": "sounds/Music2.mp3"},
    {"name": "Rain Ambience", "file": "sounds/Music3.mp3"},
    {"name": "Morning Breeze", "file": "sounds/Music4.mp3"},
    {"name": "Night Forest", "file": "sounds/Music5.mp3"},
  ];

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Relax Music",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: tracks.any((t) => t["file"] == selectedTrack) ? selectedTrack : null,
          hint: const Text(
            "Choose a track",
            style: TextStyle(color: Colors.white70),
          ),
          dropdownColor: Colors.black87,
          items: tracks.map((t) {
            return DropdownMenuItem<String>(
              value: t["file"],
              child: Text(
                t["name"]!,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (value) async {
            if (isPlaying) {
              await player.stop();
              setState(() => isPlaying = false);
            }
            setState(() => selectedTrack = value);
          },
        ),
        const SizedBox(height: 20),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: Colors.orange,
            size: 70,
          ),
          onPressed: () async {
            if (selectedTrack == null) return;
            if (!isPlaying) {
              await player.play(AssetSource(selectedTrack!));
            } else {
              await player.stop();
            }
            setState(() => isPlaying = !isPlaying);
          },
        ),
        const SizedBox(height: 10),
        Text(
          selectedTrack == null
              ? "Select a track and press play"
              : (isPlaying
              ? "Now Playing: ${tracks.firstWhere((t) => t['file'] == selectedTrack)['name']}"
              : "Ready: ${tracks.firstWhere((t) => t['file'] == selectedTrack)['name']}"),
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
