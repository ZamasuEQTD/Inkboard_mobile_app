import 'package:flutter/material.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension ResponsiveExtensions on BuildContext {
  bool get isLargerThanSm =>
      ResponsiveBreakpoints.of(this).largerThan(Breakpoints.sm.name!);

  bool get isLargerThanMd =>
      ResponsiveBreakpoints.of(this).largerThan(Breakpoints.md.name!);
}