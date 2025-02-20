import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/domain/iauth_repository.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/core/presentation/widgets/dialog/dialog_responsive.dart';

class RegistroDialog extends StatefulWidget {
  const RegistroDialog({super.key});

  @override
  State<RegistroDialog> createState() => _RegistroDialogState();
}

class _RegistroDialogState extends State<RegistroDialog> {

  final IAuthRepository repository = GetIt.I.get();
  final AuthController auth = Get.find();

  final TextEditingController usuario = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutDialog(
      title: "Registrarse",
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Usuario",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(decoration: InputDecoration(hintText: "Usuario")),
              SizedBox(height: 10),
              Text(
                "Contraseña",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Contraseña"),
              ),
              SizedBox(height: 10),
              Text(
                "Confirmacion de contraseña",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Confirma tu Contraseña"),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<AuthController>();
                  },
                  child: Text("Registrarse"),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10,vertical: 5),
        ),
      ),
    );
  }

  void registrarse() async {
    var result = await repository.login(
      usuario: usuario.text,
      password: password.text,
    );

    result.fold((l) {}, (r) async {
      await auth.login(r);
    
      Get.back();
    });


  }
}

