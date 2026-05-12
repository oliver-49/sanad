import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_or_from_speech_app/helper.dart/services/text_to_speach.dart';

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  bool get isListening => _isListening;

  Future<void> init() async {
    await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
  }

  Future<void> startListening(Function(String) onResult) async {
    await TextToSpeach.stop();
    if (_isListening) return;

    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      _speech.listen(
        onResult: (val) => onResult(val.recognizedWords),
        localeId: "ar_EG",
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 20),
        partialResults: true,
        cancelOnError: false,
      );
    }
  }

  void stopListening() {
    if (!_isListening) return;
    _speech.stop();
    _isListening = false;
  }

  Future<void> toggleListening(Function(String) onResult) async {
    if (_isListening) {
      stopListening();
    } else {
      await startListening(onResult);
    }
  }
}
