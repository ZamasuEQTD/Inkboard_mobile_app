import 'package:flutter/material.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:inkboard/features/hilos/presentation/widgets/portada/portada.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../domain/models/portada_model.dart';

typedef PortadaItemBuilder = Widget Function(PortadaItem child);

class PortadaGrid extends StatelessWidget {
  
  static Widget skeleton = PortadaItemSkeleton();

  final List<PortadaModel> portadas;
  final bool cargando;
  final PortadaItemBuilder? builder;
  const PortadaGrid({super.key, required this.portadas, this.cargando = false, this.builder});

  @override
  Widget build(BuildContext context) {

    return SliverGrid.builder(
      gridDelegate: delegate(context),
      itemCount: portadas.length + (cargando? 10 : 0),
      itemBuilder: (context, index) {

        if(index > portadas.length - 1){
          return skeleton;
        }

        return builder != null? builder!(PortadaItem(portada: portadas[index],)) : PortadaItem(portada: portadas[index],);
       },	
    );
  }


  SliverGridDelegate delegate(BuildContext context ) => SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: _columns(context),
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    mainAxisExtent: _extent(context)
  );

  int _columns (BuildContext context){
    for (var i = 0; i < Breakpoints.breakpoints.length; i++) {
      if(ResponsiveBreakpoints.of(context).equals(Breakpoints.breakpoints[i].name!)){
        return i + 2;
      }
    }
    
    return 6;
  }

  double _extent(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    for (var i = 0; i < Breakpoints.breakpoints.length; i++) {
      if(ResponsiveBreakpoints.of(context).equals(Breakpoints.breakpoints[i].name!)){
        return size.width / (i + 2);
      }
    }

    return size.width / 6;
  }
}