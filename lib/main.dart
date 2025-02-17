import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:inkboard/features/home/presentation/pages/home_page.dart';
import 'package:inkboard/shared/presentation/styles/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: AppThemes.light,
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: Breakpoints.breakpoints,
          );
        },
        home: HomePage());
  }
}
