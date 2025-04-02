import 'dart:async';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:signalr_netcore/signalr_client.dart';

class EncuestaSignalRHub {
  final StreamController<String> ultimoVoto =
      StreamController<String>.broadcast();

  EncuestaSignalRHub();

  void init(String id) {
    var hub =
        HubConnectionBuilder()
            .withUrl("${dotenv.env["BASE_HUB_URL"]}encuestas")
            .build();

    hub.start()!.then((value) {
      hub.invoke("Unirse", args: [id]).then((value) {
        hub.on(
          "OnEncuestaVotada",
          (arguments) {
            ultimoVoto.add(arguments![0] as String);
          },
        );
      });
    });
  }

  Stream<String> get onUltimoVoto => ultimoVoto.stream;
}
