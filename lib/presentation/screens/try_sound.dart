// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class VoiceActionPage extends StatefulWidget {
//   @override
//   _VoiceActionPageState createState() => _VoiceActionPageState();
// }

// class _VoiceActionPageState extends State<VoiceActionPage> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _text = '';

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   void checkPermission() async {
//     if (await Permission.microphone.request().isGranted) {
//       print("Microphone permission granted");
//     } else {
//       print("Microphone permission denied");
//     }
//   }

//   void _listen() async {
//     if (!_isListening) {
//       print("Initializing speech recognition...");
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (val) {
//             _text = val.recognizedWords;
//             _handleCommand(_text);
//           },
//           localeId: "ar_SA", // عربي مصر
//           listenFor: Duration(seconds: 30), // بدل الافتراضي 5 ثواني
//           pauseFor: Duration(seconds: 10),
//         );
//       }

//       print("Speech recognition initialized: $available");
//     } else {
//       _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }

//   void _handleCommand(String command) {
//     // هنا تحط القواعد للكلمات والإجراءات
//     if (command.contains("واحد")) {
//       Navigator.push(context, MaterialPageRoute(builder: (_) => PageOne()));
//     } else if (command.contains("اتنين")) {
//       Navigator.push(context, MaterialPageRoute(builder: (_) => PageTwo()));
//     }
//     // ممكن تزود أي أوامر تانية
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Voice Action")),
//       body: Center(child: Text("كلامك: $_text")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _listen,
//         child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//       ),
//     );
//   }
// }

// // مثال صفحات
// class PageOne extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) =>
//       Scaffold(body: Center(child: Text("صفحة 1")));
// }

// class PageTwo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) =>
//       Scaffold(body: Center(child: Text("صفحة 2")));
// }

// //************************************** */
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() {
//   runApp(const MynewApp());
// }

// class MynewApp extends StatelessWidget {
//   const MynewApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'تطبيق المكفوفين',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const HomenewScreen(),
//       routes: {
//         '/page1': (context) => const Page1(),
//         '/page2': (context) => const Page2(),
//       },
//     );
//   }
// }

// class HomenewScreen extends StatefulWidget {
//   const HomenewScreen({super.key});

//   @override
//   State<HomenewScreen> createState() => _HomenewScreenState();
// }

// class _HomenewScreenState extends State<HomenewScreen> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _text = 'اضغط على الميكروفون وتكلم';

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (val) => print('Status: $val'),
//         onError: (val) => print('Error: $val'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (val) {
//             setState(() {
//               _text = val.recognizedWords;
//               print("Recognized: $_text");
//             });

//             // هنا نتحكم فى التنقل
//             if (_text.contains('واحد')) {
//               Navigator.pushNamed(context, '/page1');
//             } else if (_text.contains('اتنين')) {
//               Navigator.pushNamed(context, '/page2');
//             }
//           },
//           localeId: "ar-EG", // لضبط اللغة العربية
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('الصفحة الرئيسية')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _text,
//               style: const TextStyle(fontSize: 24),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             FloatingActionButton(
//               onPressed: _listen,
//               child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Page1 extends StatelessWidget {
//   const Page1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('صفحة واحد')),
//       body: const Center(child: Text('انت فى صفحة 1')),
//     );
//   }
// }

// class Page2 extends StatelessWidget {
//   const Page2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('صفحة اتنين')),
//       body: const Center(child: Text('انت فى صفحة 2')),
//     );
//   }
// }
//************************************** */

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_or_from_speech_app/helper.dart/services/text_to_speach.dart';

class VoiceActionPage extends StatefulWidget {
  const VoiceActionPage({super.key});

  @override
  State<VoiceActionPage> createState() => _VoiceActionPageState();
}

class _VoiceActionPageState extends State<VoiceActionPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = 'اضغط على الميكروفون وتكلم';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
    await TextToSpeach.stop(); // مهم جدا

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
      setState(() => _isListening = true);

      _speech.listen(
        onResult: (val) {
          setState(() => _recognizedText = val.recognizedWords);
          _handleNavigation(_recognizedText);
        },
        localeId: "ar_EG",
        listenFor: const Duration(seconds: 30),
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
    if (text.contains('واحد')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Page1()));
    } else if (text.contains('اتنين')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Page2()));
    }
    // ممكن تضيف كلمات اخرى و الصفحات الخاصة بيها هنا
  }

  // ============================ Build UI ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة الأوامر الصوتية')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _recognizedText,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _toggleListening,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================ Page 1 ============================
class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة واحد')),
      body: const Center(
        child: Text('انت فى صفحة 1', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// ============================ Page 2 ============================
class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة اتنين')),
      body: const Center(
        child: Text('انت فى صفحة 2', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
