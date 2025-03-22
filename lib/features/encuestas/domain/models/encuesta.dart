
class EncuestaModel {
  final String id;
  final List<RespuestaModel> respuestas;
  final String? respuestaVotada;

  const EncuestaModel({
    required this.id,
    required this.respuestas,
    required this.respuestaVotada,
  });

  factory EncuestaModel.fromJson(Map<String, dynamic> json) {
    var respuestasFromJson = json['respuestas'] as List;
    List<RespuestaModel> respuestasList =
        respuestasFromJson
            .map(
              (respuesta) =>
                  RespuestaModel.fromJson(respuesta as Map<String, dynamic>),
            )
            .toList();

    return EncuestaModel(
      id: json['id'] as String,
      respuestas: respuestasList,
      respuestaVotada: json['respuesta_votada'] as String?,
    );
  }

  int get votosTotales =>
      respuestas.fold(0, (total, respuesta) => total + respuesta.votos);
}

class RespuestaModel {
  final String id;
  final String respuesta;
  final int votos;

  const RespuestaModel({
    required this.id,
    required this.respuesta,
    required this.votos,
  });
  factory RespuestaModel.fromJson(Map<String, dynamic> json) {
    return RespuestaModel(
      id: json['id'] as String,
      respuesta: json['respuesta'] as String,
      votos: json['votos'] as int,
    );
  }
}
