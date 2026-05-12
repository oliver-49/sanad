import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'text_to_speach.dart';
import 'dart:math';

class HelpModeService {
  static const String _phoneNumberKey = 'help_phone_number';

  static Future<String?> getSavedPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  static Future<void> savePhoneNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, number);
  }

  static Future<void> triggerHelpMode([String? phoneNumber]) async {
    final targetNumber = phoneNumber ?? await getSavedPhoneNumber();
    if (targetNumber == null || targetNumber.isEmpty) {
      TextToSpeach.speak("لم يتم العثور على رقم للتواصل", isImportant: true);
      return;
    }

    TextToSpeach.speak("جاري إرسال اللينك... يرجى الانتظار", isImportant: true);

    final randomStr = Random().nextInt(999999).toString();
    final roomId = 'SanadHelp_$randomStr';
    final meetLink = 'https://meet.jit.si/$roomId';

    final message = 'الرجاء مساعدتي، انضم إلى هذه المكالمة: $meetLink';
    
    var cleanedNumber = targetNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedNumber.startsWith('0')) {
      cleanedNumber = '2$cleanedNumber'; 
    }

    final waUrl = 'https://wa.me/$cleanedNumber?text=${Uri.encodeComponent(message)}';
    
    try {
      await launchUrl(Uri.parse(waUrl), mode: LaunchMode.externalApplication);
      
      await Future.delayed(const Duration(seconds: 4));
      await launchUrl(Uri.parse(meetLink), mode: LaunchMode.externalApplication);
      
    } catch (e) {
      TextToSpeach.speak("حدث خطأ أثناء فتح الواتساب", isImportant: true);
    }
  }
}
