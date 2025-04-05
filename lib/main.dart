import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/app/presentation/logic/controllers/app_failure_controller.dart';
import 'package:inkboard/features/app/presentation/widgets/snackbar.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/core/dependency_injection.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:inkboard/features/core/router.dart';
import 'package:inkboard/shared/presentation/styles/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  GetIt.I.addDependencies();

  Get.put(AppFailureController());
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
          child: GlobalFailureHandler(child: child!),
          breakpoints: Breakpoints.breakpoints,
        );
      },
      initialRoute: "/",
      getPages: routes,
    );
  }
}

class GlobalFailureHandler extends StatelessWidget {
  final Widget child;
  const GlobalFailureHandler({super.key, required this.child});
  

  @override
  Widget build(BuildContext context) {
    final failureController = Get.find<AppFailureController>();
    
    // Escucha cambios y muestra Snackbar/Dialog
    ever(failureController.failure, (failure) {
      if (failure != null) {
        AppSnackbar.error(Get.context!, mensaje: failure.descripcion!);
        // Limpia el error después de mostrarlo
        failureController.limpiar();
      }
    });

    return child;
  }
}