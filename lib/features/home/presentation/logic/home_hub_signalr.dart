import 'dart:async';

import 'package:inkboard/features/core/presentation/utils/network/client.dart'
    as dotenv;
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class HomeHubSignalr {
  final _onHiloEliminado = StreamController<String>.broadcast();

  final _onHiloPosteado = StreamController<PortadaModel>.broadcast();

  void init() {
    var hub =
        HubConnectionBuilder()
            .withUrl("${dotenv.env["BASE_HUB_URL"]}home")
            .build();

    hub.start()!.then((value) {
      hub.on("OnHiloEliminado", (arguments) {
        _onHiloEliminado.add(arguments![0] as String);
      });

      hub.on("OnHiloPosteado", (arguments) {
          var map = arguments![0] as Map<String, dynamic>;

          var portada = PortadaModel.fromJson(map);

          _onHiloPosteado.add(portada);
      });
    });
  }

  Stream<String> get onHiloEliminado => _onHiloEliminado.stream;
  Stream<PortadaModel> get onHiloPosteado => _onHiloPosteado.stream;
}
