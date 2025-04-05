import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSnackbar extends StatelessWidget {
  final Color color;
  final String mensaje;
  final FlashController controller;
  const AppSnackbar({
    super.key,
    required this.controller,
    required this.mensaje,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: FlashBar(
          shadowColor: Colors.transparent,
          backgroundColor: color,
          position: FlashPosition.top,
          useSafeArea: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            mensaje,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          controller: controller,
        ),
      ),
    );
  }

  static void success(BuildContext context,{required String mensaje}) => context.showFlash(
    duration: Duration(seconds: 3),
    builder:
        (context, controller) => AppSnackbar(
          controller: controller,
          mensaje: mensaje,
          color: Colors.white,
        ),
  );

  static void error(BuildContext context, {required String mensaje}) => context.showFlash(
    duration: Duration(seconds: 3),
    builder:
        (context, controller) => AppSnackbar(
          controller: controller,
          mensaje: mensaje,
          color: CupertinoColors.destructiveRed,
        ),
  );
}
