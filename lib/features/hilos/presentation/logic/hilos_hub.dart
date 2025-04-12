import 'dart:async';

import 'package:inkboard/features/core/presentation/utils/network/client.dart'
    as dotenv;
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class HilosHubSignalr {
  Stream<String> get onComentarioEliminado =>  _onComentarioEliminado.stream;

  Stream<ComentarioModel> get onComentado => _onComentado.stream;

  final _onComentado = StreamController<ComentarioModel>.broadcast();

  final _onComentarioEliminado = StreamController<String>.broadcast();

  late final HubConnection hub;

  void init(String id) {
      hub =
        HubConnectionBuilder()
            .withUrl("${dotenv.env["BASE_HUB_URL"]}hilos")
            .build();

    hub.start()!.then((value) {
      hub.invoke("SubscribirseHilo", args: [id]).then((value) {
        hub.on("OnHiloComentado", (args) {
          _onComentado.add(
            ComentarioModel.fromJson(args![0] as Map<String, dynamic>),
          );
        });

        hub.on("OnComentarioEliminado", (args) {
          _onComentarioEliminado.add(args![0] as String);
        });
      });
    });
  }


  void dispose(){
    _onComentado.close();
    _onComentarioEliminado.close();

    hub.stop();
  }
}
