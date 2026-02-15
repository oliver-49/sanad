import 'dart:io';

import 'package:dio/dio.dart';
import 'package:text_to_or_from_speech_app/helper.dart/const/constant.dart';

class Api {
  // late String endPoint;
  late Dio dio ;
   Api(){
    BaseOptions options =BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    );
    dio =Dio(options);
  }

  Future <Map<String,dynamic>> postImage(String endPoint, File file)async{
   
   try{

    FormData formData = FormData.fromMap({
        "files": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });


    Response response = await dio.post(
        endPoint,
        data: formData,
    );
     if (response.statusCode==200){
    return response.data;}
     return {};

   }
  on DioException catch (e) {
      print("\n ********* Dio error: ${e.message}");
      return {};
    } 
    catch(e){
      print ("\n ****** Unexpected error: $e");
      return {};
    }
  
  }
}