import 'package:flutter/material.dart';

import 'app/app.dart';
import 'client.dart';
import 'conta/conta_controller.dart';
import 'conta/server_conta_source.dart';
import 'relatorios/relatorios_source.dart';
import 'replay/replay_controller.dart';
import 'resultados/resultados_controller.dart';
import 'secao/secao_controller.dart';
import 'verificar/verificar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(
    UrnaAbertaApp(
      tallySource: ServerTallySource(client),
      secaoSource: CachedSecaoSource(ServerSecaoSource(client)),
      verificarSource: ServerVerificarSource(client),
      resultadosSource: ServerResultadosSource(client),
      conta: ContaController(ServerContaSource(client))..start(),
      relatoriosSource: ServerRelatoriosSource(client),
    ),
  );
}
