import 'package:flutter/material.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/features/hilos/presentation/widgets/portadas-grid/portadas_grid.dart';
import 'package:inkboard/features/hilos/presentation/widgets/postear-hilo/postear_hilo_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: CustomScrollView(
          slivers: [
            SliverAppBar(
                pinned: true,
                title: Text(
                  "Inkboard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: SizedBox.square(
                        dimension: 40,
                        child: Icon(Icons.menu),
                      ),
                    ),
                  )
                ]),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              sliver: PortadaGrid(
                cargando: true,
                portadas: List.generate(
                  200,
                  (index) => PortadaModel(
                    id: "id",
                    titulo:
                        "titulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulotitulov",
                    subcategoria: "NSFW",
                    esNuevo: true,
                    miniatura: MiniaturaModel(
                      url:
                          "https://static1.dualshockersimages.com/wordpress/wp-content/uploads/2019/11/angela-and-the-knifepng.jpeg",
                      spoiler: true,
                    ),
                    banderas: Banderas(
                      esSticky: true,
                      tieneEncuesta: true,
                      dadosActivado: true,
                      idUnicoActivado: true,
                    ),
                  ),
                ),
                builder: (child) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: child,
                  ),
                ),
              ),
            )
          ],
        )),

        //postear  hilo button
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size.square(50)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => PostearHiloDialog(),
            ),
            icon: Icon(Icons.add, color: Colors.white, size: 25),
          ),
        )
      ],
    );
  }
}
