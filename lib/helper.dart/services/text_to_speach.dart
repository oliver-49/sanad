// import 'package:flutter_tts/flutter_tts.dart';

// class TextToSpeach {
//   static final FlutterTts _tts = FlutterTts();
//   static bool _isReady = false;

//   static Future<void> init() async {
//     await _tts.setLanguage("ar-EG");
//     await _tts.setPitch(1.0);
//     await _tts.setSpeechRate(0.5);
//     await _tts.awaitSpeakCompletion(true);
//     await Future.delayed(const Duration(milliseconds: 300));
//     _isReady = true;
//   }

//   static Future<void> speak(String text) async {
//     if (!_isReady) return;
//     if (text.isNotEmpty) {
//       await _tts.stop();
//       await _tts.speak(text);
//     }
//   }

//   static Future<void> stop() async {
//     await _tts.stop();
//   }
// }

import 'package:flutter_tts/flutter_tts.dart';

enum VoiceMode { full, important }

class TextToSpeach {
  static final FlutterTts _tts = FlutterTts();
  static bool _isReady = false;

  static VoiceMode currentMode = VoiceMode.full;

  static Future<void> init() async {
    await _tts.setLanguage("ar-EG");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
    await _tts.awaitSpeakCompletion(true);
    _isReady = true;
  }

  static Future<void> speak(String text, {bool isImportant = false}) async {
    if (!_isReady) return;
    if (text.isEmpty) return;

    // لو في وضع important ومش جملة مهمة → متتنطقش
    if (currentMode == VoiceMode.important && !isImportant) return;

    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
