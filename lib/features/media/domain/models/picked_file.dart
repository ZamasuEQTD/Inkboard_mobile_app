import 'dart:io';

import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/media/domain/models/media.dart';

class PickedFile {
  final String source;

  final MediaProvider provider;

  const PickedFile({required this.source, required this.provider});
}
