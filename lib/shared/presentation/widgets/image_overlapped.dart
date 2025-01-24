import 'dart:io';

import 'package:flutter/widgets.dart';

class ImageOverlapped extends StatelessWidget {
  late final ImageProvider imageProvider;
  final Widget child;
  final BoxFit? boxFit;

  ImageOverlapped.network({
    super.key,
    required this.child,
    required String url,
    this.boxFit,
  }) {
    imageProvider = NetworkImage(url);
  }

  ImageOverlapped.file({
    super.key,
    required this.child,
    required String path,
    this.boxFit,
  }) {
    imageProvider = FileImage(File(path));
  }

  ImageOverlapped.provider({
    super.key,
    required ImageProvider provider,
    this.boxFit,
    required this.child,
  }) {
    imageProvider = provider;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
        child,
      ],
    );
  }
}
