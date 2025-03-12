import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:inkboard/features/media/presentation/logic/video_provider.dart';

import '../../../domain/models/media.dart';

extension MediaProviderConversionsExtensions on MediaSource {
  ImageProvider toImage() {
    if (isFromNetwork) return NetworkImage(model.url);

    return FileImage(File(model.url));
  }

  VideoProvider toVideoProvider() {
    if (isFromNetwork) return NetworkVideoProvider(model.url);

    return FileVideoProvider(File(model.url));
  }

  bool get isFromNetwork => source == MediaSourceType.network;
  bool get isFromFile => source == MediaSourceType.file;
}

extension MediaPickedConversionsExtensions on PickedFile {
  MediaModel toMediaModel() => MediaModel(
    previsualizacion: null,
    provider: provider,
    url: source,
    spoiler: false,
  );
}
