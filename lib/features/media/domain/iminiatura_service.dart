import 'package:flutter/material.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

abstract class IMiniaturaFactory {
  IMiniaturaService create(MediaProvider provider);
}

abstract class IMiniaturaService {
  Future<ImageProvider> generar(PickedFile media);
}
