import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:text_to_or_from_speech_app/data/repostory/response_repo.dart';

part 'sanad_state.dart';

class SanadCubit extends Cubit<SanadState> {
  
      final ResponseRepo responseRepo;
  SanadCubit(this.responseRepo) : super(SanadInitial());



  void postImage(String endPoint, File file)async{
    try{
      emit(SanadPostImageLoading());
      
      final response =await responseRepo.postImage(endPoint,file);



      emit(SanadPostImageLoaded({
        endPoint:response
      }));
     
    }
    catch(e){
       emit(SanadPostImageError(e.toString()));
    }
  }
}
