import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/presentation/logic/controllers/hilo_page_controller.dart';
import 'package:inkboard/features/hilos/presentation/widgets/comentario.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/shared/presentation/util/color_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HiloPage extends StatefulWidget {
  const HiloPage({super.key});

  @override
  State<HiloPage> createState() => _HiloPageState();
}

class _HiloPageState extends State<HiloPage> {
  final HiloPageController controller = Get.put(HiloPageController());

  final GlobalKey key = GlobalKey();

  final RxList<ComentarioModel> comentarios = RxList([
    ComentarioModel(
      id: "1",
      texto: "Este es un comentario con >>A1B2C3D4.",
      createdAt: DateTime.now(),
      autorId: "user123",
      esAutor: true,
      destacado: false,
      respondidoPor: [],
      respondeA: [],
      esOp: true,
      tag: "discusión",
      tagUnico: "discusión-1",
      recibirNotificaciones: true,
      color: "#FF0000",
      autorRole: "admin",
      autor: "Usuario1",
    ),
    ComentarioModel(
      id: "2",
      texto: "¡Hola a todos! >>Z9Y8X7W6 es un tag interesante.",
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      autorId: "user456",
      esAutor: false,
      destacado: true,
      respondidoPor: ["user123"],
      respondeA: ["1"],
      esOp: false,
      tag: "pregunta",
      tagUnico: "pregunta-2",
      recibirNotificaciones: false,
      color: "#00FF00",
      dados: "Dados de ejemplo",
      media: null,
      autorRole: "user",
      autor: "Usuario2",
    ),
    ComentarioModel(
      id: "3",
      texto: "¿Alguien más vio esto? >>B2C3D4E5.",
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      autorId: "user789",
      esAutor: false,
      destacado: false,
      respondidoPor: [],
      respondeA: [],
      esOp: false,
      tag: "opinión",
      tagUnico: "opinión-3",
      recibirNotificaciones: true,
      color: "#0000FF",
      dados: null,
      autorRole: "moderador",
      autor: "Usuario3",
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (context.isLargerThanSm) {
            //no celular
            return LayoutBuilder(
              builder: (context, constraints) {
                return Row(children: [
                  SizedBox(
                    width: 0.45 * constraints.maxWidth,
                    height: double.infinity,
                    child: CustomScrollView(
                      slivers: [],
                    ),
                  ),
                  SizedBox(
                      width: 0.55 * constraints.maxWidth,
                      child: Column(
                        children: [
                          Flexible(
                            child: CustomScrollView(
                              slivers: [_comentariosList()],
                            ),
                          ),
                          ComentarHilo(
                            key: key,
                          )
                        ],
                      ))
                ]);
              },
            );
          }

          //celular
          return Column(
            children: [
              Flexible(
                child: CustomScrollView(
                  slivers: [_comentariosList()],
                ),
              ),
              ComentarHilo(
                key: key,
              )
            ],
          );
        },
      ),
    );
  }

  SliverPadding _comentariosList() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              "Comentarios (40)",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: comentarios.length,
            itemBuilder: (context, index) => ComentarioWidget(
              comentario: comentarios[index],
            ),
          )
        ],
      ),
    );
  }
}

class ComentarHilo extends StatefulWidget {
  const ComentarHilo({super.key});

  @override
  State<ComentarHilo> createState() => _ComentarHiloState();
}

class _ComentarHiloState extends State<ComentarHilo> {
  final HiloPageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.comentario,
      decoration: InputDecoration(hintText: "Escribe tu comentario..."),
    );
  }
}

extension ResponsiveExtensions on BuildContext {
  bool get isLargerThanSm =>
      ResponsiveBreakpoints.of(this).largerThan(Breakpoints.sm.name!);

  bool get isLargerThanMd =>
      ResponsiveBreakpoints.of(this).largerThan(Breakpoints.md.name!);
}
