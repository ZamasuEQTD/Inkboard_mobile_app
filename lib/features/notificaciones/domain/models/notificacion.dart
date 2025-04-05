class NotificacionesContext {
  final int cantidad;
  final List<Notificacion> notificaciones;

  const NotificacionesContext({
    required this.cantidad,
    required this.notificaciones,
  });

  factory NotificacionesContext.fromJson(Map<String, dynamic> json) =>
      NotificacionesContext(
        cantidad: json["cantidad"],
        notificaciones: List.from(json["notificaciones"]),
      );
}

abstract class Notificacion {
  final String id;
  final String content;
  final DateTime fecha;
  final String comentario;
  final NotificacionHilo hilo;
  const Notificacion({
    required this.id,
    required this.comentario,
    required this.content,
    required this.fecha,
    required this.hilo,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    switch (json["tipo"]) {
      case "HiloComentado":
        return HiloComentado.fromJson(json);
      case "HiloSeguidoComentado":
        return HiloSeguidoComentado.fromJson(json);
      case "ComentarioRespondido":
        return ComentarioRespondido.fromJson(json);
      default:
        throw Exception("Tipo de notificación desconocido");
    }
  }
}

class NotificacionHilo {
  final String id;
  final String titulo;
  final String portada;
  const NotificacionHilo({
    required this.id,
    required this.titulo,
    required this.portada,
  });

  factory NotificacionHilo.fromJson(Map<String, dynamic> json) =>
      NotificacionHilo(
        id: json["id"],
        titulo: json["titulo"],
        portada: json["portada"],
      );
}

class HiloComentado extends Notificacion {
  const HiloComentado({
    required super.id,
    required super.hilo,
    required super.comentario,
    required super.content,
    required super.fecha,
  });

  factory HiloComentado.fromJson(Map<String, dynamic> json) => HiloComentado(
    id: json["id"],
    hilo: NotificacionHilo.fromJson(json["hilo"]),
    comentario: json["comentario_respuesta_tag"],
    content: json["contenido"],
    fecha: DateTime.parse(json["fecha"]),
  );
}

class HiloSeguidoComentado extends HiloComentado {
  const HiloSeguidoComentado({
    required super.id,
    required super.hilo,
    required super.comentario,
    required super.content,
    required super.fecha,
  });

  factory HiloSeguidoComentado.fromJson(Map<String, dynamic> json) =>
      HiloSeguidoComentado(
        id: json["id"],
        hilo: NotificacionHilo.fromJson(json["hilo"]),
        comentario: json["comentario"],
        content: json["contenido"],
        fecha: DateTime.parse(json["fecha"]),
      );
}

class ComentarioRespondido extends Notificacion {
  final String respondidoTag;
  final String respondido;
  const ComentarioRespondido({
    required super.id,
    required super.hilo,
    required super.comentario,
    required super.content,
    required super.fecha,
    required this.respondidoTag,
    required this.respondido,
  });

  factory ComentarioRespondido.fromJson(Map<String, dynamic> json) =>
      ComentarioRespondido(
        id: json["id"],
        hilo: NotificacionHilo.fromJson(json["hilo"]),
        comentario: json["comentario_respuesta_tag"],
        content: json["contenido"],
        fecha: DateTime.parse(json["fecha"]),
        respondidoTag: json["comentario_respuesta_tag"],
        respondido: json["comentario_respondido_tag"],
      );
}
