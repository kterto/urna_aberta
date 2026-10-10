import 'package:flutter/material.dart';

import 'app/app.dart';
import 'client.dart';
import 'replay/replay_controller.dart';
import 'secao/secao_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(
    UrnaAbertaApp(
      tallySource: ServerTallySource(client),
      secaoSource: ServerSecaoSource(client),
    ),
  );
}
