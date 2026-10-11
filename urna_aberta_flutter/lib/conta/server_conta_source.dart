import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import 'conta_controller.dart';

/// Serverpod's email sign-in and the `meuLocal` endpoint.
class ServerContaSource implements ContaSource {
  ServerContaSource(this._client) {
    _client.auth.authInfoListenable.addListener(_sync);
    _sync();
  }

  final Client _client;
  final _signedIn = ValueNotifier(false);

  void _sync() => _signedIn.value = _client.auth.isAuthenticated;

  @override
  ValueListenable<bool> get signedIn => _signedIn;

  @override
  Future<VoterPlace?> ler() => _client.meuLocal.ler();

  @override
  Future<VoterPlace> salvar(String uf, int municipio, int? zona, int? secao) =>
      _client.meuLocal.salvar(uf, municipio, zona, secao);

  @override
  Future<void> apagar() => _client.meuLocal.apagar();

  @override
  Future<void> sair() => _client.auth.signOutDevice();

  @override
  Widget signInForm(BuildContext context) => SignInWidget(client: _client);
}
