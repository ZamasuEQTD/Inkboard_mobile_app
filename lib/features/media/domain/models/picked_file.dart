import 'dart:io';

class PickedFile {
  final String source;

  final PickedFileProvider provider;

  const PickedFile({required this.source, required this.provider});
}

enum PickedFileProvider { youtube, video, image, other }
