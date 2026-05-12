import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../helper.dart/services/help_mode_service.dart';
import '../../helper.dart/services/text_to_speach.dart';

class HelpPage extends StatefulWidget {
  final Function(int) onSelect;

  const HelpPage({super.key, required this.onSelect});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> with WidgetsBindingObserver {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  bool _isListening = false;
  bool _isWaitingForPostCallResponse = false;
  bool _isWaitingForFinalAction = false; // To decide between Home and Exit

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSpeech();
    _greetUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _speechToText.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User returned from WhatsApp/Jitsi
      Future.delayed(const Duration(seconds: 1), () {
        _askPostCallQuestion();
      });
    }
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => print('STT Error: $val'),
      onStatus: (val) => print('STT Status: $val'),
    );
    setState(() {});
  }

  void _greetUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    TextToSpeach.speak(
      "أهلاً بك في صفحة المساعدة. للتواصل مع الشخص يمكنك الضغط المطول وقول الرقم. اضغط مرتين على الشاشة للخروج.",
      isImportant: true,
    );
  }

  void _startListening() async {
    if (!_speechEnabled) return;
    
    await TextToSpeach.speak("جاري الاستماع", isImportant: true);
    
    setState(() {
      _isListening = true;
      _wordsSpoken = "";
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _wordsSpoken = result.recognizedWords;
          if (result.finalResult) {
            _handleVoiceInput(_wordsSpoken);
          }
        });
      },
      localeId: "ar-EG",
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _handleVoiceInput(String input) {
    _stopListening();
    
    if (_isWaitingForPostCallResponse) {
      _processPostCallResponse(input);
    } else if (_isWaitingForFinalAction) {
      _processFinalActionResponse(input);
    } else {
      // Capture number
      final number = input.replaceAll(RegExp(r'[^\d]'), '');
      if (number.length >= 8) {
        HelpModeService.triggerHelpMode(number);
      } else {
        TextToSpeach.speak("عذراً، لم أستطع فهم الرقم بشكل صحيح. يرجى المحاولة مرة أخرى.", isImportant: true);
      }
    }
  }

  void _askPostCallQuestion() {
    setState(() {
      _isWaitingForPostCallResponse = true;
      _isWaitingForFinalAction = false;
    });
    TextToSpeach.speak("حابب القيام بمكالمة مع شخص آخر؟ قل نعم أو لا.", isImportant: true);
    
    // Auto start listening for response after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isWaitingForPostCallResponse) {
         _startListeningForNavigation();
      }
    });
  }

  void _processPostCallResponse(String input) {
    setState(() => _isWaitingForPostCallResponse = false);
    
    if (input.contains("نعم") || input.contains("ايوه")) {
      TextToSpeach.speak("حسناً، اضغط مطولاً وقول الرقم الجديد.", isImportant: true);
    } else if (input.contains("لا")) {
      _askFinalActionQuestion();
    } else {
      TextToSpeach.speak("لم أفهم ردك. حابب مكالمة تانية؟", isImportant: true);
      _askPostCallQuestion();
    }
  }

  void _askFinalActionQuestion() {
    setState(() {
      _isWaitingForPostCallResponse = false;
      _isWaitingForFinalAction = true;
    });
    TextToSpeach.speak("حابب الرجوع للصفحة الرئيسية أم الخروج من التطبيق؟", isImportant: true);
    
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _isWaitingForFinalAction) {
        _startListeningForNavigation();
      }
    });
  }

  void _processFinalActionResponse(String input) {
    setState(() => _isWaitingForFinalAction = false);

    if (input.contains("رئيسية") || input.contains("رجوع") || input.contains("الرئيسية")) {
      widget.onSelect(0);
    } else if (input.contains("خروج") || input.contains("قفل")) {
      TextToSpeach.speak("شكراً لاستخدامك سند. مع السلامة.", isImportant: true).then((_) {
        SystemNavigator.pop();
      });
    } else {
      TextToSpeach.speak("قل الرئيسية للرجوع أو خروج لإغلاق التطبيق.", isImportant: true);
      _askFinalActionQuestion();
    }
  }

  void _startListeningForNavigation() async {
    if (!_speechEnabled) return;
    
    setState(() {
      _isListening = true;
    });

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          _handleVoiceInput(result.recognizedWords);
        }
      },
      localeId: "ar-EG",
      listenFor: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _startListening,
      onLongPressUp: _stopListening,
      onDoubleTap: () {
        TextToSpeach.speak("تم الرجوع للرئيسية", isImportant: true);
        widget.onSelect(0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEBEE),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFEBEE),
                const Color(0xFFFFCDD2),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: _isListening ? 1.2 : 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening 
                          ? Colors.red.withOpacity(0.3) 
                          : Colors.red.withOpacity(0.1),
                        boxShadow: _isListening ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 10,
                          )
                        ] : [],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.support_agent_rounded,
                        size: 100,
                        color: const Color(0xFFB71C1C),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                _isListening ? "Listening..." : "Help Mode",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _wordsSpoken.isEmpty 
                    ? "Long press to speak\nDouble tap to exit" 
                    : _wordsSpoken,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ),
              if (_isListening)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB71C1C)),
                    strokeWidth: 6,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
