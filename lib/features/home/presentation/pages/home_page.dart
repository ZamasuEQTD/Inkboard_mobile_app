import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/auth/presentation/widgets/autenticacion_requerida.dart';
import 'package:inkboard/features/hilos/presentation/widgets/portadas-grid/portadas_grid.dart';
import 'package:inkboard/features/hilos/presentation/widgets/postear-hilo/postear_hilo_dialog.dart';
import 'package:inkboard/features/home/presentation/logic/controllers/home_page_controller.dart';
import 'package:inkboard/shared/presentation/util/extensions/scroll_controller_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scroll = ScrollController();

  final HomePageController controller = Get.put(HomePageController());

  @override
  void initState() {
    controller.cargarPortadas();

    scroll.onBottom(() => controller.cargarPortadas());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(child: Center(child:Column(children: [],))),
      body: Stack(
        children: [
          CustomScrollView(
            controller: scroll,
            slivers: [
              SliverAppBar(
                pinned: true,
                title: GestureDetector(
                  onTap: () => Get.toNamed("/"),
                  child: Text(
                    "Inkboard",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                actions: [
                  Builder(
                    builder:
                        (context) => IconButton(
                          onPressed:
                              () => Scaffold.of(context).openEndDrawer(),
                          icon: SizedBox.square(
                            dimension: 40,
                            child: Icon(Icons.menu),
                          ),
                        ),
                  ),
                ],
              ),
              Obx(
                () => SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                  ).copyWith(bottom: 10),
                  sliver: PortadaGrid(
                    cargando: controller.cargandoPortadas.value,
                    portadas: controller.portadas,
                    builder:
                        (child) => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => Get.toNamed("/hilo"),
                            child: child,
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),
          //postear  hilo button
          Positioned(
            bottom: 10,
            right: 10,
            child: AutenticacionRequeridaButton(
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  iconColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  fixedSize: WidgetStatePropertyAll(Size.square(50)),
                ),
                onPressed: () => Get.dialog(PostearHiloDialog()),
                icon: Icon(Icons.add, size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
