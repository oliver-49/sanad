import 'package:flutter/material.dart';
import '../../helper.dart/services/text_to_speach.dart';

class MeetPage extends StatefulWidget {
  final Function(int) onSelect;

  const MeetPage({super.key, required this.onSelect});

  @override
  State<MeetPage> createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {
  @override
  void initState() {
    super.initState();
    _speakWelcomeMessage();
  }

  void _speakWelcomeMessage() {
    TextToSpeach.speak(
        "أنت في صفحة الميت للدردشة مع الأصدقاء، وإذا تريد الخروج أو الرجوع للصفحة الرئيسية اضغط مرتين",
        isImportant: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        widget.onSelect(0); // Return to home page
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9), // Meeting Mode color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.video_call_rounded,
                size: 100,
                color: Color(0xFF1A237E),
              ),
              const SizedBox(height: 20),
              const Text(
                "Meeting Mode",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "اضغط مرتين للرجوع للصفحة الرئيسية",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
