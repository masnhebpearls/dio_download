sealed class ApiRequestState {}


class PreparingDownloadState extends ApiRequestState{}


class DownloadingState extends ApiRequestState {
  final int downloaded;
  final int total;

  DownloadingState({required this.downloaded, required this.total});

}

class DownloadedState extends ApiRequestState {
  final String path;

  DownloadedState({required this.path});

}

class ShowPhotosGridState extends ApiRequestState {}


class ViewPhotoState extends ApiRequestState{
  final int index;

  ViewPhotoState({required this.index});

}


class DownloadErrorState extends ApiRequestState {}

class UnableToDownloadState extends ApiRequestState {}

class ImageSelectedState extends ApiRequestState{}

class UploadInitialPageState extends ApiRequestState{}

class UploadingState extends ApiRequestState{
  final int progress;

  UploadingState({required this.progress});


}

class UploadedState extends ApiRequestState {}

class UploadFailure extends ApiRequestState {
  final String errorMessage;

  UploadFailure({required this.errorMessage});
}

