import 'dart:io';

abstract class VideoProvider {
  const VideoProvider();
}

class  NetworkVideoProvider extends VideoProvider {
  final String url;
  const NetworkVideoProvider(this.url);
}

class FileVideoProvider extends VideoProvider {
  final File file;
  const FileVideoProvider(this.file);
}