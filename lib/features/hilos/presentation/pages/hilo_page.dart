import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/presentation/logic/controllers/hilo_page_controller.dart';
import 'package:inkboard/features/hilos/presentation/widgets/comentario.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/presentation/logic/extensions/media_extensions.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/shared/presentation/util/extensions/scroll_controller_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HiloPage extends StatefulWidget {
  const HiloPage({super.key});

  @override
  State<HiloPage> createState() => _HiloPageState();
}

class _HiloPageState extends State<HiloPage> {
  final HiloPageController controller = Get.put(HiloPageController());

  final GlobalKey key = GlobalKey();

  late final ScrollController scroll = ScrollController();

  @override
  void initState() {
    scroll.onBottom(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (context.isLargerThanMd) {
            //no celular
            return LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    SizedBox(
                      width: 0.45 * constraints.maxWidth,
                      height: double.infinity,
                      child: ColoredBox(
                        color: Colors.grey.shade200,
                        child: SingleChildScrollView(child: HiloBody()),
                      ),
                    ),
                    SizedBox(
                      width: 0.55 * constraints.maxWidth,
                      child: Column(
                        children: [
                          Flexible(
                            child: CustomScrollView(
                              clipBehavior: Clip.none,
                              controller: scroll,
                              slivers: [_comentariosList()],
                            ),
                          ),
                          ComentarHilo(key: key),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }

          //celular
          return Column(
            children: [
              Flexible(
                child: CustomScrollView(
                  controller: scroll,
                  slivers: [
                    SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: ColoredBox(
                          color: Colors.grey.shade200,
                          child: HiloBody(),
                        ),
                      ),
                    ),
                    _comentariosList(),
                  ],
                ),
              ),
              ComentarHilo(key: key),
            ],
          );
        },
      ),
    );
  }

  SliverPadding _comentariosList() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              "Comentarios (40)",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          Obx(() {
            var comentarios = [...this.controller.destacados, ...controller.comentarios];
            
            return SliverList.builder(
              itemCount: comentarios.length,
              itemBuilder:
                  (context, index) =>
                      ComentarioWidget(comentario: comentarios[index]),
            );
          }),
        ],
      ),
    );
  }
}

class HiloBody extends StatelessWidget {
  const HiloBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ColoredBox(
            color: Colors.white,
            child: Row(
              spacing: 4,
              children: [
                IconButton(onPressed: Get.back, icon: Icon(Icons.chevron_left)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox.square(
                    dimension: 30,
                    child: ColoredBox(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "NSFW",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.link,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 4, horizontal: 12),
          ),
        ).marginOnly(bottom: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ColoredBox(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.star_outline),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.flag_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.star_outline),
                    ),
                  ],
                ),
                Row(
                  spacing: 3.5,
                  children: [
                    Text(
                      "Anonimo",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Chip(
                      labelPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 4,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      backgroundColor: Colors.grey.shade400,
                      label: Text(
                        "ANON",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),

                    Text("2m", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ).paddingSymmetric(vertical: 4, horizontal: 12),
          ),
        ).marginOnly(bottom: 10),

        Center(
          child: MediaBox(
            style: DimensionableStyle(
              radius: BorderRadius.circular(10),
              constraints: BoxConstraints(maxHeight: 450),
            ),
            media: MediaSource(
              source: MediaSourceType.network,
              model: MediaModel(
                provider: MediaProvider.image,
                url:
                    "https://static1.dualshockersimages.com/wordpress/wp-content/uploads/2019/11/angela-and-the-knifepng.jpeg",
              ),
            ),
          ),
        ).marginOnly(bottom: 10),
        Text(
          "Titulo",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text("descripcion"),
      ],
    ).paddingSymmetric(horizontal: 8, vertical: 10);
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
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              IconButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(CircleBorder()),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                ),
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
              Flexible(
                child: TextFormField(
                  controller: controller.comentario,
                  maxLines: 5,
                  minLines: 2,
                  decoration: InputDecoration(
                    hintText: "Escribe tu comentario...",
                  ),
                ),
              ),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900),
                ),
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 10),
        ],
      ),
    );
  }
}

extension ResponsiveExtensions on BuildContext {
  bool get isLargerThanSm =>
      ResponsiveBreakpoints.of(this).largerThan(Breakpoints.sm.name!);

  bool get isLargerThanMd =>
      ResponsiveBreakpoints.of(this).largerThan(Breakpoints.md.name!);
}
