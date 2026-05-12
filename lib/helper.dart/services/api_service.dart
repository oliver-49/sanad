import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:text_to_or_from_speech_app/helper.dart/const/constant.dart';

class ApiService {
  // static const String currencyUrl = detectCurrency;
  static const String currencyUrl = detectCurrencyNew;
  static const String objectUrl = Detect;
  static const String textUrl = extractText;

  static Future<String> processImage(String imagePath, String mode) async {
    try {
      String url = baseUrl;
      url =
          url +
          (mode == "Currency"
              ? currencyUrl
              : (mode == "Object" ? objectUrl : textUrl));

      // var request = http.MultipartRequest('POST', Uri.parse("https://mervin-superdelicate-incapably.ngrok-free.dev/detect-currency"));
      // request.files.add(await http.MultipartFile.fromPath('files', imagePath));
      // var response = await http.Response.fromStream(await request.send());

      // print("*****\n the response is     $response");
      //       if (response.statusCode == 200) {
      //         return json.decode(response.body)['result'];
      //       }
      //       return "خطأ في الاتصال بالخادم";

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('file', '$imagePath'),
      );

      http.StreamedResponse streamedResponse = await request.send();

      http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String imageResponse = 'حاول مجدداً';
        print("data $data");
        print("mode $mode ");

        switch (mode) {
          case "Currency":
            {
              // List currencies = data['currencies'] ?? [];
              String currencies = data['detected_text_ar'] ?? '';

              print("currencies $currencies");

              if (currencies.isNotEmpty) {
                // imageResponse = currencies[0]['denomination_en'];
                imageResponse = currencies;
                // imageResponse.substring(0, imageResponse.length - 3) +
                // " من الجنيهات";
                print(imageResponse);
              }
            }
          case "Object":
            {
              List objects = data['objects'] ?? [];

              print("objects $objects");

              // if (objects.isNotEmpty) {
              //   imageResponse = objects[0]['label_ar'];
              //   print(imageResponse);
              // }
              if (objects.isNotEmpty) {
                List<String> labels = [];

                for (var obj in objects) {
                  if (obj['label_ar'] != null) {
                    labels.add(obj['label_ar']);
                  }
                }

                imageResponse = labels.join(" ، ");
                print(imageResponse);
              }
              break;
            }

          case "Read Text":
            {
              // String Text = data['text'] ?? '';

              // print("Text $Text");

              // if (Text.isNotEmpty) {
              //   imageResponse = Text;
              //   print(imageResponse);
              // }

              var request = http.MultipartRequest(
                'POST',
                Uri.parse('https://api.ocr.space/parse/image'),
              );

              request.headers['apikey'] = 'K81007905988957';

              request.fields['language'] = 'auto';
              request.fields['OCREngine'] = '2';

              request.files.add(
                await http.MultipartFile.fromPath('file', imagePath),
              );

              http.StreamedResponse streamedResponse = await request.send();
              http.Response response = await http.Response.fromStream(
                streamedResponse,
              );

              if (response.statusCode == 200) {
                final result = json.decode(response.body);

                print("OCR RESULT: $result");

                if (result['ParsedResults'] != null &&
                    result['ParsedResults'].isNotEmpty) {
                  String extractedText =
                      result['ParsedResults'][0]['ParsedText'] ?? '';

                  if (extractedText.isNotEmpty) {
                    imageResponse = extractedText;
                  }
                }
              } else {
                print(response.reasonPhrase);
              }

              break;
            }
        }

        return imageResponse;
      } else {
        print(response.reasonPhrase);
      }

      return "خطأ في الاتصال بالخادم";
    } catch (e) {
      print("********* the error : $e");
      return "تأكد من اتصالك بالإنترنت";
    }
  }
}
