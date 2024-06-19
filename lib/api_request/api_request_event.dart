
sealed class ApiRequestEvent{}

class DownloadPhotoEvent extends ApiRequestEvent {

  final String downloadUrl;

  DownloadPhotoEvent(this.downloadUrl);

}