import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_to_or_from_speech_app/helper.dart/services/text_to_speach.dart';
import 'package:text_to_or_from_speech_app/presentation/screens/try_sound.dart';
import 'home_wrapper.dart';
import '../../helper.dart/services/inreview/tts_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAndSpeak();
    });
    // _initAndSpeak();
  }

  Future<void> _initAndSpeak() async {
    // await VoiceService.init();

    await TextToSpeach.speak(
      "أنا عينيك اللي بتشوف بالصوت. مع بعض هنخلي الدنيا أسهل",
    );

    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                // VoiceActionPage(),
                const HomeWrapper(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
