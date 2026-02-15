// import 'package:flutter_tts/flutter_tts.dart';

// class TtsService {
//   static final FlutterTts _tts = FlutterTts();

//   static bool _initialized = false;

//   static Future<void> init() async {
//     if (_initialized) return;

//     var languages = await _tts.getLanguages;

//     String? arabicLang;

//     for (var lang in languages) {
//       print("Available language: $lang\n");
//       if (lang.toString().toLowerCase().contains("ar")) {
//         arabicLang = lang;
//         break;
//       }
//     }

//     if (arabicLang != null) {
//       await _tts.setLanguage(arabicLang);
//       print("Arabic language selected: $arabicLang");
//     } else {
//       await _tts.setLanguage("en-US");
//       print("Arabic not found, fallback to English");
//     }

//     await _tts.setPitch(1.0);
//     await _tts.setSpeechRate(0.5);

//     _initialized = true;
//   }

//   static Future<void> speak(String text) async {
//     await _tts.stop();
//     await _tts.speak(text);
//   }

//   static Future<void> stop() async {
//     await _tts.stop();
//   }
// }
