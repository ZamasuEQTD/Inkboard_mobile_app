import 'dart:io';

class PickedFile {
  final File file;

  const PickedFile({required this.file});
}

class EmbedFile {
  final String url;

  const EmbedFile({required this.url});
}