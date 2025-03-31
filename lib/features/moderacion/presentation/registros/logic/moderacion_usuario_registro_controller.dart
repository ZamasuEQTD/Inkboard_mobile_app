
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/moderacion/domain/iregistro_repository.dart';
import 'package:inkboard/features/moderacion/domain/models/registro.dart';

class RegistroUsuarioModeracionController extends GetxController {
  final Rx<RegistroUsuario?> usuario = Rx(null);
  final RxBool usuarioCargando = false.obs;

  final RxList<HiloComentadoRegistro> comentariosHistorial = RxList([]);
  final RxBool comentariosCargando = false.obs;
  bool hallegadoAlFinalComentarios = false;


  final RxList<HiloPosteadoRegistro> hilosHistorial = RxList([]);
  final RxBool hilosCargando = false.obs;
  bool hallegadoAlFinalHilos = false;

  final Rx<RegistroSeleccionado> seleccionado = RegistroSeleccionado.hilos.obs;

  final IRegistrosRepository _repository = GetIt.I.get();

  final String id;

  RegistroUsuarioModeracionController({required this.id});

  Future cargarUsuario() async {
    usuarioCargando.value = true;

    var response = await _repository.getRegistroUsuario(id);

    response.fold((l) {}, (r) {
      usuario.value = r;

      cargarHilos();
    });

    usuarioCargando.value = false;
  }

  Future cargarComentarios() async {
    if(comentariosCargando.value || hallegadoAlFinalComentarios) return;

    comentariosCargando.value = true;
    var response = await _repository.getComentariosHistorial(id, ultimoComentario: this.comentariosHistorial.lastOrNull?.id);

    response.fold((l) {}, (r) {
      comentariosHistorial.addAll(r);

      if(r.isEmpty) {
        hallegadoAlFinalComentarios = true; 
      }
    });

    comentariosCargando.value = false;
  }

  Future cargarHilos() async {
    if(hilosCargando.value || hallegadoAlFinalHilos) return;

    hilosCargando.value = true;

    final ultimo = hilosHistorial.lastOrNull; 

    var response = await _repository.getHilosHistorial(id, ultimoHilo:ultimo?.hilo.id);

    response.fold((l) {}, (r) {
      hilosHistorial.addAll(r);

      if(r.isEmpty) {
        hallegadoAlFinalHilos = true;
      }
    });

    hilosCargando.value = false;
  }

  bool get isUsuarioCargando => usuarioCargando.value;
  bool get isComentariosCargando => comentariosCargando.value;
  bool get isHilosCargando => hilosCargando.value;
  bool get isHilosSeleccionado =>
      seleccionado.value == RegistroSeleccionado.hilos;

  bool get isComentariosSeleccionado =>
      seleccionado.value == RegistroSeleccionado.comentarios;
}

enum RegistroSeleccionado { hilos, comentarios }