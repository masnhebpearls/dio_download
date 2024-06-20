
import 'dart:io';

sealed class ApiRequestEvent{}

class DownloadPhotoEvent extends ApiRequestEvent {

  final int index;

  DownloadPhotoEvent(this.index);

}

class ViewPhotoEvent extends ApiRequestEvent{
  final int index;

  ViewPhotoEvent({required this.index});

}


class UploadPhotoEvent extends ApiRequestEvent{}


class NavigateToUploadEvent extends ApiRequestEvent{}


class ImageSelectionEvent extends ApiRequestEvent{}


class GetImageUrl extends ApiRequestEvent {}


class ExitToPhotoGrid extends ApiRequestEvent {}

class UploadCancelEvent extends ApiRequestEvent {}

