import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/notificaciones/domain/inotificaciones_repository.dart';
import 'package:inkboard/features/notificaciones/domain/models/notificacion.dart';

class MisNotificacionesController extends GetxController {
  RxList<Notificacion> notificaciones = RxList([]);

  Rx<Failure?> failure = Rx(null);

  RxBool cargandoNotificaciones = false.obs;

  final INotificacionesRepository _repository = GetIt.I.get();


  void cargar() async {
    if (cargandoNotificaciones.value) return;

    cargandoNotificaciones.value = true;

    var result = await _repository.getMisNotificaciones();

    result.fold(
      (l) {
        failure.value = l;
      },
      (r) {
        notificaciones.value = [...notificaciones, ...r];

      },
    );

    cargandoNotificaciones.value = false;
  }

  void leerTodas() async {
 
    var res = await _repository.leerTodas();

    res.fold((l) {}, (r) => notificaciones.clear());
  }

  void leer(String id) async {
    var res = await _repository.leerNotificacion(id: id);

    res.fold(
      (l) {},
      (r) => notificaciones.removeWhere((e) => e.id == id),
    );
  }

  void agregarNotificacion(Notificacion notificacion) {
    notificaciones.value = [notificacion, ...notificaciones];
  }
}
