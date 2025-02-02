import 'package:flutter/material.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/features/hilos/presentation/widgets/portadas-grid/portadas_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(title: Text("Inkboard"), actions: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: SizedBox.square(
              dimension: 40,
              child: Icon(Icons.menu),
            ),
          )
        ]),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          sliver: PortadaGrid(
            portadas: List.generate(
              200,
              (index) => PortadaModel(
                id: "id",
                titulo: "titulo",
                subcategoria: "NSFW",
                esNuevo: true,
                miniatura: MiniaturaModel(
                  url:
                      "https://static.wikia.nocookie.net/dragonball/images/c/c0/Son_Goku_en_Super_Hero.png/revision/latest?cb=20220302091733&path-prefix=es",
                  spoiler: false,
                ),
                banderas: Banderas(
                  esSticky: true,
                  tieneEncuesta: true,
                  dadosActivado: true,
                  idUnicoActivado: true,
                ),
              ),
            ),
            builder: (child) => GestureDetector(
              child: child,
            ),
          ),
        )
      ],
    ));
  }
}
