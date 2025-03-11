import 'dart:collection';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/presentation/logic/extensions/media_extensions.dart';
import 'package:inkboard/features/media/presentation/logic/video_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef DimensionableBuilder =
    Widget Function(BuildContext context, Widget dimensionable);

class DimensionableStyle {
  final BorderRadius? radius;
  final BoxConstraints? constraints;

  const DimensionableStyle({this.radius, this.constraints});
}

class MediaBox extends StatelessWidget {
  static Set<MediaProvider> dimensionables = Set.from({
    MediaProvider.image,
    MediaProvider.video,
    MediaProvider.youtube,
  });

  static HashMap<MediaProvider, Widget Function(MediaSource media)> builders =
      HashMap.from({
        MediaProvider.image:
            (MediaSource media) => Image(image: media.toImage()),
        MediaProvider.gif: (MediaSource media) => Image(image: media.toImage()),
        MediaProvider.video:
            (MediaSource media) =>
                VideoPlayerWidget(provider: media.toVideoProvider()),
      });

  final DimensionableStyle style;

  final DimensionableBuilder? builder;

  final MediaSource media;

  const MediaBox({
    super.key,
    required this.media,
    this.style = const DimensionableStyle(),
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (dimensionables.contains(media.model.provider)) {
      var builder = builders[media.model.provider];

      if (builder == null) throw UnimplementedError("Media no soportado!!!");

      Widget dimensionable =
          this.builder != null
              ? this.builder!(context, builder(media))
              : builder(media);

      if (style.radius != null) {
        dimensionable = ClipRect(
          child: ClipRRect(borderRadius: style.radius!, child: dimensionable),
        );
      }

      if (style.constraints != null) {
        dimensionable = ConstrainedBox(
          constraints: style.constraints!,
          child: dimensionable,
        );
      }

      return dimensionable;
    }

    return Container();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoProvider provider;
  final ImageProvider? miniatura;

  const VideoPlayerWidget({super.key, required this.provider, this.miniatura});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final ChewieController controller;
  bool inicializdo = false;

  VideoPlayerController get video => controller.videoPlayerController;

  @override
  void initState() {
    VideoPlayerController player;

    switch (widget.provider is NetworkVideoProvider) {
      case true:
        player = VideoPlayerController.networkUrl(
          Uri.parse((widget.provider as NetworkVideoProvider).url),
        );
        break;
      case false:
        player = VideoPlayerController.file(
          (widget.provider as FileVideoProvider).file,
        );
        break;
    }

    controller = ChewieController(videoPlayerController: player);

    video.initialize().then((_) {
      setState(() {
        inicializdo = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!inicializdo) return previsualizacion;

    return AspectRatio(
      aspectRatio: video.value.aspectRatio,
      child: Chewie(controller: controller),
    );
  }

  Widget get previsualizacion =>
      widget.miniatura != null
          ? Image(image: widget.miniatura!)
          : CircularProgressIndicator();
}

class YoutubePlayerWidget extends StatefulWidget {
  final String url;
  const YoutubePlayerWidget({super.key, required this.url});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late final YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: controller,
      builder: (context, player) => player,
    );
  }
}
