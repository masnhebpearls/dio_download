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


class DownloadErrorState extends ApiRequestState {}

class UnableToDownloadState extends ApiRequestState {}


