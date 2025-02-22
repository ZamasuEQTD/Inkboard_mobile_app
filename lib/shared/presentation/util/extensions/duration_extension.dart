extension DurationExtensions on DateTime {
  String get tiempoTranscurrido {
    final now = DateTime.now();

    final diferencia = now.difference(this);

    if (diferencia.inMinutes < 1) {
      return "Ahora";
    } else if (diferencia.inHours < 1) {
      return "${diferencia.inMinutes}m";
    } else if (diferencia.inDays < 1) {
      return "${diferencia.inHours}hs";
    } else if (diferencia.inDays < 30) {
      return "${diferencia.inDays}dias";
    } else {
      int meses = (diferencia.inDays / 30).floor();
      return "${meses}meses";
    }
  }
}
