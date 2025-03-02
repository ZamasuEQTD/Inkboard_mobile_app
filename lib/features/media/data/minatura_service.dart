import 'dart:collection';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:inkboard/features/media/domain/iminiatura_service.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_compress/video_compress.dart';


class GetItMiniaturaFactory implements IMiniaturaFactory {

  static final HashMap<MediaProvider, IMiniaturaService> _services = HashMap.from({
    MediaProvider.youtube: GetIt.I.get<YoutubeMiniaturaService>(),
    MediaProvider.image: GetIt.I.get<ImagenMiniaturaService>(),
    MediaProvider.video: GetIt.I.get<VideoCompressMiniaturaGenerador>()
  });

  @override
  IMiniaturaService create(MediaProvider provider) {
    if (_services.containsKey(provider)) {
      return _services[provider]!;
    }

    throw Exception("Tipo de media no soportado");
  }
}


class VideoCompressMiniaturaGenerador extends IMiniaturaService {
  @override
  Future<ImageProvider> generar(PickedFile media) async {
    File miniatura = await VideoCompress.getFileThumbnail(media.source);

    return FileImage(miniatura);
  }
}

class YoutubeMiniaturaService extends IMiniaturaService {
  @override
  Future<ImageProvider> generar(PickedFile media) async {
    return NetworkImage(YoutubeService.miniaturaFromUrl(media.source)!);
  }
}

class ImagenMiniaturaService extends IMiniaturaService {
  @override
  Future<ImageProvider> generar(PickedFile media) {
    return Future.value(FileImage(File(media.source)));
  }
}

class YoutubeService {
  static RegExp youtubeIdRegex = RegExp(
    r'(youtu.*be.*)\/(watch\?v=|embed\/|v|shorts|)(.*?((?=[&#?])|$))',
  );

  static RegExp youtubeLinkRegex = RegExp(
    r'^https?:\/\/(www\.)?youtu(\.be\/|be\.com\/)(watch\?v=|embed\/|v\/|shorts\/)([A-Za-z0-9-_]{11})((?=[&#?])|$)',
  );

  static String? miniaturaFromUrl(String url) {
    String? id = getVideoId(url);

    if (id == null) return null;

    return miniaturaFromId(id);
  }

  static String? getVideoId(String url) {
    var match = youtubeIdRegex.firstMatch(url);

    if (match == null) return null;

    return match.group(3)!;
  }

  static String miniaturaFromId(String id) =>
      'https://img.youtube.com/vi/$id/1.jpg';

  static bool EsVideoOrShort(String url) => getVideoId(url) != null;
}
