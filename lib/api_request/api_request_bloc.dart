import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'api_request_event.dart';
import 'api_request_state.dart';

class ApiRequestBloc extends Bloc<ApiRequestEvent, ApiRequestState> {
  ApiRequestBloc(): super(ShowPhotosGridState()){
    on<DownloadPhotoEvent>(downloadPhotoEvent);
  }


  FutureOr<void> downloadPhotoEvent(DownloadPhotoEvent event, Emitter<ApiRequestState> emit) async {
    emit(PreparingDownloadState());

    final Dio dio = Dio();

    try{
      // final dir = await getApplicationDocumentsDirectory();
      // final newDir =  await getExternalStorageDirectories();
      final tempDir = await getDownloadsDirectory();
      final String path = "${tempDir!.path}/${DateTime.now()}demoapp.jpg";
      await dio.download(event.downloadUrl, path,
          onReceiveProgress: (rec, total) {

            emit(DownloadingState(downloaded: rec, total: total));
          }
      );
      emit(DownloadedState(path: path));

      await Future.delayed(const Duration(seconds: 15));

      emit(ShowPhotosGridState());



    }
    on DioException catch (e){
      if (e.response!.statusCode == 400){
        emit(UnableToDownloadState());
      }
      else{
        emit(DownloadErrorState());
      }
    }


  }
}
