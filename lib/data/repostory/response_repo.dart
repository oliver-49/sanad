import 'dart:io';

import 'package:text_to_or_from_speech_app/data/models/currency_model.dart';
import 'package:text_to_or_from_speech_app/data/web_service/api.dart';

class ResponseRepo {
  final Api api;

  ResponseRepo({required this.api});

  Future<CurrencyModel> postImage(String endPoint, File file) async {
    final json = await api.postImage(endPoint, file);
    return CurrencyModel.fromJson(json);
  }
}
