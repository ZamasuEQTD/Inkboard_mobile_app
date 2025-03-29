import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSnackbar extends StatelessWidget {
  final String mensaje;
  final FlashController controller;
  const AppSnackbar({
    super.key,
    required this.controller,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: FlashBar(
          backgroundColor: CupertinoColors.destructiveRed,
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
}
