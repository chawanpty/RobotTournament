import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔥 พื้นหลัง Gradient Sci-Fi
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // 🏆 เนื้อหาหลัก
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎬 Logo Animation (ใช้แทนโลโก้)
                Hero(
                  tag: 'logo',
                  child: Icon(
                    Icons.android_rounded,
                    size: 100,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                // 🔥 Animated Text Title
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'ROBOT TOURNAMENT',
                      textStyle: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true,
                ),
                const SizedBox(height: 30),
                // 🚀 ปุ่มเริ่มต้นการแข่งขัน (Gradient Button)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent],
                    ).createShader(bounds),
                    child: const Text(
                      "🚀 เริ่มต้นการแข่งขัน",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
