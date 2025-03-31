import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/domain/iauth_repository.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/core/presentation/widgets/dialog/dialog_responsive.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();


  static void show()=> Get.dialog(LoginDialog(),useSafeArea: false);
}

class _LoginDialogState extends State<LoginDialog> {
  final AuthController auth = Get.find();

  final TextEditingController password = TextEditingController();
  final TextEditingController usuario = TextEditingController();

  final IAuthRepository repository = GetIt.I.get();

  bool iniciando = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutDialog(
      title: "Iniciar sesión",
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
              TextFormField(
                controller: usuario,
                decoration: InputDecoration(hintText: "Usuario"),
              ),
              SizedBox(height: 10),
              Text(
                "Contraseña",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(hintText: "Contraseña"),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => iniciarSesion(),
                  child:
                      iniciando
                          ? FittedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text("Iniciar sesión"),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 5),
        ),
      ),
    );
  }

  void iniciarSesion() async {
    setState(() {
      iniciando = true;
    });
    var result = await repository.login(
      usuario: usuario.text,
      password: password.text,
    );

    result.fold((l) {}, (r) async {
      await auth.login(r);

      Get.back();
    });
    setState(() {
      iniciando = false;
    });
  }
}
