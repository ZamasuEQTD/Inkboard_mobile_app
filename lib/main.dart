import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/core/dependency_injection.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:inkboard/features/core/router.dart';
import 'package:inkboard/shared/presentation/styles/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.addDependencies();

  await Get.put(GetIt.I.get<AuthController>()).restaurarSesion();
  
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
      initialRoute: "/",
      getPages: routes,
    );
  }
}
