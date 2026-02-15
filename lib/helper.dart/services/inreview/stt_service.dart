// import 'package:speech_to_text/speech_to_text.dart';

// class SttService {
//   static final SpeechToText _speech = SpeechToText();

//   // تهيئة المايكروفون
//   static Future<bool> initialize() async {
//     return await _speech.initialize();
//   }

//   // البدء في الاستماع للأوامر
//   static void listen({required Function(String) onCommandReceived}) async {
//     bool available = await _speech.initialize();
//     if (available) {
//       _speech.listen(
//         localeId: "ar_SA", // يدعم العربية (يمكنك تغييرها لـ en_US)
//         onResult: (result) {
//           // نرسل الكلمات التي سمعها التطبيق للـ UI لنتحقق منها
//           onCommandReceived(result.recognizedWords.toLowerCase());
//         },
//       );
//     }
//   }

//   // إيقاف الاستماع
//   static void stop() {
//     _speech.stop();
//   }

//   static bool get isListening => _speech.isListening;
// }
