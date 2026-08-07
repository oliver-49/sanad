import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper.dart/services/text_to_speach.dart';

class HomePage extends StatefulWidget {
  final Function(int) onSelect;
  bool fromSplash;
  HomePage({super.key, required this.onSelect, this.fromSplash = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  static bool _welcomeSpokenGlobal = false;
  // bool _speechAvailable = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initAndStart();
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  // ============================ Toggle Listening ============================
  void _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    TextToSpeach.speak("أنا مستعد للاستماع");
    await Future.delayed(const Duration(seconds: 3), () {});
    await TextToSpeach.stop();

    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Status: $status');
        if (status == 'done') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        print('Error: $error');
        setState(() => _isListening = false);
      },
    );

    if (available) {
      if (mounted) {
        setState(() => _isListening = true);
      }

      _speech.listen(
        onResult: (val) {
          setState(() => _recognizedText = val.recognizedWords);
          print("Heard: $_recognizedText");
          _handleNavigation(_recognizedText);
        },
        localeId: "ar_EG",
        listenFor: const Duration(seconds: 100),
        pauseFor: const Duration(seconds: 10),
        partialResults: true,
        cancelOnError: false,
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  // ============================ Navigation Based on Speech ============================
  void _handleNavigation(String text) async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });

    if (text.contains("1") ||
        text.contains("عملات") ||
        text.contains("عمله") ||
        text.contains("١") ||
        text.contains("واحد")) {
      _goTo(1);
    } else if (text.contains("2") ||
        text.contains("٢") ||
        text.contains("اشياء") ||
        text.contains("اتنين") ||
        text.contains("اثنين")) {
      _goTo(2);
    } else if (text.contains("3") ||
        text.contains("٣") ||
        text.contains("نصوص") ||
        text.contains("تلاتة") ||
        text.contains("ثلاثة") ||
        text.contains("ثلاثه")) {
      _goTo(3);
    }
    //  else if (text.contains("4") ||
    //     text.contains("٤") ||
    //     text.contains("مساعدة") ||
    //     text.contains("مساعده") ||
    //     text.contains("خمسة") ||
    //     text.contains("خمسه")) {
    //   _goTo(4);
    // }
    else {
      TextToSpeach.speak(
        "لم أفهم، قول: تعرف على العملة، أو اقرأ النص، أو وصف الشيء، ",
        isImportant: true,
      );
      Future.delayed(const Duration(seconds: 4), () {
        _startListening();
      });
    }
  }

  Future<void> _initAndStart() async {
    // var status = await Permission.microphone.request();

    // if (status.isGranted) {
    // await VoiceService.init();
    // if (!widget.fromSplash && !_welcomeSpokenGlobal) {
    // _welcomeSpokenGlobal = true;
    await TextToSpeach.speak('''
      أهلاً بك في سند، أنا عينك اللي بتشوف بالصوت، مع بعض نخلي الدنيا أحلى.
       قل واحد للعملات، اثنان للأجسام، ثلاثة للنصوص، .
       ولتشغيل الميكروفون، اضغط مطولاً على الشاشة.
        ولتغيير وضع الصوت بين كامل و مهم فقط،  اضغط مرتين على الشاشة.
      ''');
    await TextToSpeach.speak('''
         انت الآن في الشاشة الرئيسية.
      ''', isImportant: true);
    // }

    // await Future.delayed(const Duration(seconds: 6));

    //   _startListening();
    // } else {
    //   await VoiceService.speak("يجب تفعيل صلاحية المايكروفون من الإعدادات.");
    // }
  }

  // void _startListening() async {
  //   _speechAvailable = await _speech.initialize(
  //     onStatus: (status) {
  //       if (status == 'listening') {
  //         setState(() => _isListening = true);
  //         HapticFeedback.mediumImpact();
  //       } else {
  //         setState(() => _isListening = false);
  //       }
  //     },
  //     onError: (error) {
  //       setState(() => _isListening = false);
  //       Future.delayed(const Duration(seconds: 2), () {
  //         _startListening();
  //       });
  //     },
  //   );

  //   if (_speechAvailable) {
  //     _speech.listen(
  //       localeId: "ar_EG",
  //       listenMode: stt.ListenMode.dictation,
  //       partialResults: false,
  //       listenFor: const Duration(seconds: 10),
  //       pauseFor: const Duration(seconds: 3),
  //       onResult: (result) {
  //         if (result.finalResult) {
  //           String text = result.recognizedWords
  //               .toLowerCase()
  //               .trim()
  //               .replaceAll(" ", "");

  //           print("Final Heard: $text");

  //           if (text.contains("1") ||
  //               text.contains("١") ||
  //               text.contains("واحد")) {
  //             _goTo(1);
  //           } else if (text.contains("2") ||
  //               text.contains("٢") ||
  //               text.contains("اتنين") ||
  //               text.contains("اثنين")) {
  //             _goTo(2);
  //           } else if (text.contains("3") ||
  //               text.contains("٣") ||
  //               text.contains("تلاتة") ||
  //               text.contains("ثلاثة") ||
  //               text.contains("ثلاثه")) {
  //             _goTo(3);
  //           } else {
  //             VoiceService.speak("لم أفهم، حاول مرة أخرى");
  //             Future.delayed(const Duration(seconds: 2), () {
  //               _startListening();
  //             });
  //           }
  //         }
  //       },
  //     );
  //   }
  // }

  void _goTo(int index) async {
    await _speech.stop();
    setState(() => _isListening = false);
    HapticFeedback.lightImpact();
    widget.onSelect(index);
  }

  void toggleVoiceMode() async {
    if (TextToSpeach.currentMode == VoiceMode.full) {
      TextToSpeach.currentMode = VoiceMode.important;

      await TextToSpeach.speak("تم تفعيل وضع المهم فقط", isImportant: true);
    } else {
      TextToSpeach.currentMode = VoiceMode.full;

      await TextToSpeach.speak("تم تفعيل الوضع الكامل", isImportant: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: _toggleListening,
      onDoubleTap: toggleVoiceMode,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  ).createShader(bounds),
                  child: const Text(
                    "Sanad",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your Intelligent Companion",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                _buildCard(
                  "Currency Mode",
                  Icons.money_rounded,
                  1,
                  const Color(0xFFE3F2FD),
                  const Color(0xFF1976D2),
                ),
                _buildCard(
                  "Object Mode",
                  Icons.category_rounded,
                  2,
                  const Color(0xFFF3E5F5),
                  const Color(0xFF7B1FA2),
                ),
                _buildCard(
                  "Read Text Mode",
                  Icons.text_snippet_rounded,
                  3,
                  const Color(0xFFFFF3E0),
                  const Color(0xFFF57C00),
                ),

                // _buildCard(
                //   "Help Mode",
                //   Icons.support_agent_rounded,
                //   4,
                //   const Color(0xFFFFEBEE),
                //   const Color(0xFFD32F2F),
                // ),
                const SizedBox(height: 40),

                GestureDetector(
                  onTap: _toggleListening,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: _isListening ? 1.2 : 1.0),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening
                                ? Colors.red.withOpacity(0.2)
                                : Colors.grey[100],
                            boxShadow: _isListening
                                ? [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.3),
                                      blurRadius: 25,
                                      spreadRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            size: 35,
                            color: _isListening
                                ? Colors.red
                                : const Color(0xFF1A237E),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  _isListening
                      ? "Listening..."
                      : "Long press to start listening",
                  style: TextStyle(
                    color: _isListening ? Colors.red : Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),
                _buildWaves(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    IconData icon,
    int index,
    Color bgColor,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: () => _goTo(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(icon, color: accentColor, size: 25),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    "Tap to enter",
                    style: TextStyle(
                      fontSize: 14,
                      color: accentColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: accentColor.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaves() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        10,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 4,
          height: _isListening ? (i.isEven ? 40 : 20) : 15,
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
