import 'package:flutter/material.dart';
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
        PortadaGrid(
          portadas: [],
          builder: (child) => GestureDetector(
            child: child,
          ),
        )
      ],
    ));
  }
}
