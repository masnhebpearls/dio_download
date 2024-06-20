import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'api_request_event.dart';
import 'api_request_state.dart';

class ApiRequestBloc extends Bloc<ApiRequestEvent, ApiRequestState> {
  ApiRequestBloc(): super(PreparingDownloadState()){
    on<DownloadPhotoEvent>(downloadPhotoEvent);
    on<UploadPhotoEvent>(uploadPhotoEvent);
    on<NavigateToUploadEvent>(navigateToUploadPage);
    on<ImageSelectionEvent>(selectImage);
    on<GetImageUrl>(getImageUrl);
    on<ExitToPhotoGrid>(exitToGrid);
    on<UploadCancelEvent>(uploadCancelEvent);
    on<ViewPhotoEvent>(viewPhotoEvent);
  }

  XFile? file;
  List<String> imageURLs = [];
  final Dio dio = Dio();
  FirebaseStorage storage = FirebaseStorage.instanceFor(
      bucket: 'apirequest-a666d.appspot.com'
  );
  static const databaseUrl = 'https://apirequest-a666d-default-rtdb.firebaseio.com/photos_url.json';
  final ImagePicker picker = ImagePicker();



  FutureOr<void> downloadPhotoEvent(DownloadPhotoEvent event, Emitter<ApiRequestState> emit) async {
    emit(PreparingDownloadState());
    try{
      final tempDir = await getApplicationDocumentsDirectory();
      final String path = "${tempDir.path}${DateTime.now()}demoapp.jpg";
      await dio.download(imageURLs[event.index], path,
          onReceiveProgress: (rec, total) {
            emit(DownloadingState(downloaded: rec, total: total));
          }
      );
      emit(DownloadedState(path: path));

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

  FutureOr<void> uploadPhotoEvent(UploadPhotoEvent event, Emitter<ApiRequestState> emit) async {
    emit(UploadingState(progress: 0));
    try{

      final String path = "images/${DateTime.now()}";
      Reference ref = storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(File(file!.path),);
      uploadTask.snapshotEvents.listen((event){
        emit(UploadingState(progress: ((event.bytesTransferred.toDouble()/ event.totalBytes.toDouble())* 100).toInt()));
      });
      await uploadTask.whenComplete(() => null);
      final imageUrl = await ref.getDownloadURL();
      try {
        final response = await dio.post(
          databaseUrl,
          data: {'image': imageUrl},
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );

        if (response.statusCode == 200) {
          emit(UploadedState());
        } else {
          emit(UploadFailure(errorMessage: 'Failed to upload image URL: ${response.statusCode}'));
        }
      } catch (e) {
        emit(UploadFailure(errorMessage: 'Failed to upload image URL: $e'));
      }
    }
    on FirebaseException catch(e){
      emit(UploadFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> navigateToUploadPage(NavigateToUploadEvent event, Emitter<ApiRequestState> emit) {
    emit(UploadInitialPageState());
  }

  FutureOr<void> selectImage(ImageSelectionEvent event, Emitter<ApiRequestState> emit) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = image;
    emit(ImageSelectedState());
  }

  FutureOr<void> getImageUrl(GetImageUrl event, Emitter<ApiRequestState> emit) async {

      try {
        final response = await dio.get(databaseUrl);

        if (response.statusCode == 200) {
          (response.data as Map<String, dynamic>).forEach((key, value) {
            if (value is Map<String, dynamic> && value.containsKey('image')) {
              imageURLs.add(value['image']);
            }
          });
          emit(ShowPhotosGridState());
        } else {
          print('Failed to load data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }




  }

  FutureOr<void> exitToGrid(ExitToPhotoGrid event, Emitter<ApiRequestState> emit) {
    if (imageURLs.isNotEmpty){
      emit(ShowPhotosGridState());
    }
  }

  FutureOr<void> uploadCancelEvent(UploadCancelEvent event, Emitter<ApiRequestState> emit) {
  file = null;
  emit(UploadInitialPageState());

  }

  FutureOr<void> viewPhotoEvent(ViewPhotoEvent event, Emitter<ApiRequestState> emit) {
    emit(ViewPhotoState(index: event.index));
  }
}
