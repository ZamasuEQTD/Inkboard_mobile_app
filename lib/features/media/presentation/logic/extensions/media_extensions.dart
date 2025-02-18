
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

import '../../../domain/models/media.dart';

extension MediaProviderConversionsExtensions on MediaSource{
  ImageProvider toImage(){
    if( isFromNetwork) return NetworkImage(this.model.url);

    return FileImage(File(model.url));
  }

  bool get isFromNetwork => source == MediaSourceType.network;
  bool get isFromFile => source == MediaSourceType.file;
}


extension MediaPickedConversionsExtensions  on PickedFile {
  MediaModel toMediaModel()=> new MediaModel(previsualizacion: null, provider: this.provider, url: this.source);
}
