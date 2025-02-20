import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/auth/presentation/widgets/login_dialog.dart';
import 'package:inkboard/features/auth/presentation/widgets/registro_dialog.dart';

class AutenticacionRequerida extends StatelessWidget {
  const AutenticacionRequerida({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Para continuar\nnecesitas iniciar sesión",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
              ).paddingSymmetric(vertical: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();

                    Get.dialog(LoginDialog());
                  },
                  child: Text("Iniciar sesión"),
                ),
              ),
              Gap(5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.grey.shade300),
                    foregroundColor: WidgetStatePropertyAll(Colors.black)
                  ),
                  onPressed: () {
                    Get.back();

                    Get.dialog(RegistroDialog());
                  },
                  child: Text("Registrarse"),
                ),
              ),
              Gap(10),
            ],
          ).paddingSymmetric(horizontal: 15),
    );
  }
}

class AutenticacionRequeridaButton extends StatefulWidget {
  final Widget child;

  const AutenticacionRequeridaButton({super.key, required this.child});

  @override
  State<AutenticacionRequeridaButton> createState() =>
      _AutenticacionRequeridaButtonState();
}

class _AutenticacionRequeridaButtonState
    extends State<AutenticacionRequeridaButton> {
  final AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (auth.authenticado) return;

        Get.dialog(AutenticacionRequerida());
      },
      child: IgnorePointer(ignoring: !auth.authenticado, child: widget.child),
    );
  }
}
