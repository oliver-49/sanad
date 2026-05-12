import 'package:flutter/material.dart';
import '../../helper.dart/services/text_to_speach.dart';
import '../../helper.dart/services/speach_to_text.dart';
import '../../helper.dart/services/help_mode_service.dart';

class HelpSetupScreen extends StatefulWidget {
  final VoidCallback onSetupComplete;

  const HelpSetupScreen({super.key, required this.onSetupComplete});

  @override
  State<HelpSetupScreen> createState() => _HelpSetupScreenState();
}

class _HelpSetupScreenState extends State<HelpSetupScreen> {
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  String _recognizedNumber = "";
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _startSetup();
  }

  Future<void> _startSetup() async {
    await TextToSpeach.speak(
      "أنت الآن في شاشة إعداد وضع المساعدة لأول مرة. ما هو رقم الشخص الذي ترغب في التواصل معه؟ اضغط مطولاً على الشاشة وانطق الرقم، أو اضغط مرتين للإلغاء.",
      isImportant: true,
    );
    await _speechToTextService.init();
  }

  void _toggleListening() async {
    if (_isListening) {
      _speechToTextService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _recognizedNumber = "جاري الاستماع...";
      });
      
      await TextToSpeach.stop();
      
      await _speechToTextService.startListening((text) {
        setState(() {
          String digits = text.replaceAll(RegExp(r'[^\d]'), '');
          if (digits.isNotEmpty) {
             _recognizedNumber = digits;
          } else {
             _recognizedNumber = text;
          }
        });
        
        if (_recognizedNumber.replaceAll(RegExp(r'[^\d]'), '').length >= 10) {
          _speechToTextService.stopListening();
          setState(() => _isListening = false);
          _confirmNumber(_recognizedNumber.replaceAll(RegExp(r'[^\d]'), ''));
        }
      });
    }
  }

  void _confirmNumber(String number) async {
    await TextToSpeach.speak("الرقم الذي سمعته هو $number. جاري حفظ الرقم.", isImportant: true);
    await HelpModeService.savePhoneNumber(number);
    
    await Future.delayed(const Duration(seconds: 4));
    widget.onSetupComplete();
  }

  @override
  void dispose() {
    _speechToTextService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _toggleListening,
      onDoubleTap: () {
        widget.onSetupComplete();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.support_agent_rounded,
                size: 100,
                color: Color(0xFF1A237E),
              ),
              const SizedBox(height: 20),
              const Text(
                "إعداد وضع المساعدة",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "اضغط مطولاً لانطق الرقم",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _recognizedNumber.isEmpty ? "الرقم سيظهر هنا" : _recognizedNumber,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: _isListening ? Colors.red : const Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
