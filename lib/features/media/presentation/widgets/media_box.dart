import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/presentation/logic/extensions/media_extensions.dart';

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

  static HashMap<MediaProvider, Widget Function(MediaSource media)> builders = new HashMap.from({
    MediaProvider.image : (MediaSource media) => Image(image: media.toImage()),
    MediaProvider.gif : (MediaSource media) => Image(image: media.toImage())

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

      if(builder == null ) throw UnimplementedError("Media no soportado!!!");

      Widget dimensionable = this.builder != null ? this.builder!(context, builder(media)) : builder(media);;

      if (style.radius != null) {
        dimensionable = ClipRect(
          child: ClipRRect(
            borderRadius: style.radius!,
            child: dimensionable,
          ),
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
