import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/categorias/domain/icategorias_repository.dart';
import 'package:inkboard/features/categorias/domain/models/categoria.dart';
import 'package:inkboard/features/categorias/domain/models/subcategoria.dart';
import 'package:inkboard/shared/presentation/widgets/grupo_seleccionable/grupo_seleccionable.dart';

typedef OnSubcategoriaSeleccionada =
    void Function(SubcategoriaModel subcategoria);

class CategoriasController extends GetxController {
  final _categoriasRepository = GetIt.I.get<ICategoriasRepository>();
  final categorias = <CategoriaModel>[].obs;
  final isLoading = false.obs;

  Future<void> cargarCategorias() async {
    isLoading.value = true;

    final result = await _categoriasRepository.getCategories();

    result.fold((l) {}, (r) {
      categorias.value = r;
    });

    isLoading.value = false;
  }
}

class SeleccionarSubcategoriasBottomSheet extends StatefulWidget {
  final OnSubcategoriaSeleccionada onSubcategoriaSeleccionada;

  const SeleccionarSubcategoriasBottomSheet({
    super.key,
    required this.onSubcategoriaSeleccionada,
  });

  @override
  State<SeleccionarSubcategoriasBottomSheet> createState() =>
      _SeleccionarSubcategoriasBottomSheetState();
}

class _SeleccionarSubcategoriasBottomSheetState
    extends State<SeleccionarSubcategoriasBottomSheet> {
  final controller = Get.put(CategoriasController());

  @override
  void initState() {
    controller.cargarCategorias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return GrupoSeleccionableSliverSheet(
        grupos:
            controller.categorias
                .map(
                  (categoria) => GrupoSeleccionableItem(
                    titulo: categoria.nombre,
                    seleccionables:
                        categoria.subcategorias
                            .map(
                              (subcategoria) => SeleccionableItem(
                                onTap:
                                    () => widget.onSubcategoriaSeleccionada(
                                      subcategoria,
                                    ),
                                titulo: subcategoria.nombre,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: SizedBox.square(
                                    dimension: 30,
                                    child: Image.network(
                                      subcategoria.imagen,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                )
                .toList(),
      );
    });
  }
}
