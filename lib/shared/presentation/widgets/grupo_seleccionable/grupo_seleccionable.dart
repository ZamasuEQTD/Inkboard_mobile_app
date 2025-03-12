import 'package:flutter/material.dart';

class GrupoSeleccionableItem {
  final String? titulo;
  final List<SeleccionableItem> seleccionables;

  const GrupoSeleccionableItem({this.titulo, required this.seleccionables});
}

class SeleccionableItem {
  final String titulo;
  final Widget? leading;

  final void Function()? onTap;

  const SeleccionableItem({required this.titulo, this.leading, this.onTap});
}

class GrupoSeleccionableSliverSheet extends StatelessWidget {
  final List<GrupoSeleccionableItem> grupos;
  const GrupoSeleccionableSliverSheet({super.key, required this.grupos});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          sliver: SliverMainAxisGroup(
            slivers: [
              ...grupos.map(
                (grupo) => SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                    ),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        if (grupo.titulo != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                grupo.titulo!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          sliver: SliverList.builder(
                            itemCount: grupo.seleccionables.length,
                            itemBuilder: (context, index) {
                              final seleccionable = grupo.seleccionables[index];
                              return ListTile(
                                onTap: seleccionable.onTap,
                                trailing: seleccionable.leading,
                                title: Text(
                                  seleccionable.titulo,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
