import 'dart:async';

import 'package:flutter/material.dart';

class LinearGradientAnimation extends StatefulWidget {
  final List<Color> colors;
  final int? duration;
  final bool reverse;
  const LinearGradientAnimation({
    super.key,
    required this.colors,
    this.reverse = false,
    this.duration,
  });

  @override
  State<LinearGradientAnimation> createState() =>
      _LinearGradientAnimationState();
}

class _LinearGradientAnimationState extends State<LinearGradientAnimation> {
  final List<double> stops = [];
  late final List<List<Color>> patterns;
  late final Timer timer;
  int pattern = 0;

  @override
  void initState() {
    final int duration = widget.duration ?? (widget.colors.length * 100);

    for (var i = 0; i < widget.colors.length; i++) {
      var index = i + 1;

      stops.add(index / widget.colors.length);

      if (index != widget.colors.length) {
        stops.add(index / widget.colors.length);
      }
    }

    List<List<Color>> patterns = [widget.colors];

    for (var i = 0; i < widget.colors.length - 1; i++) {
      patterns = [
        ...patterns,
        [patterns[i].last, ...patterns[i].sublist(0, patterns[i].length - 1)],
      ];
    }

    this.patterns = widget.reverse ? patterns.reversed.toList() : patterns;

    timer = Timer.periodic(
      Duration(milliseconds: duration ~/ widget.colors.length),
      (timer) {
        setState(() {
          if (pattern < this.patterns.length - 1) {
            pattern++;
          } else {
            pattern = 0;
          }
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getColors(patterns[pattern]),
          stops: stops,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  List<Color> _getColors(List<Color> pattern) {
    List<Color> colors = [];

    for (var i = 0; i < pattern.length; i++) {
      colors.add(pattern[i]);

      if (i > 0) {
        colors.add(pattern[i]);
      }
    }

    return colors;
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }
}
