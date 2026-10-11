import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';

VoterPlace portoWalter({int? zona = 4, int? secao = 77}) => VoterPlace(
  authUserId: UuidValue.fromString('0190a7c4-0000-7000-8000-000000000001'),
  uf: 'ac',
  municipio: 1066,
  municipioNome: 'PORTO WALTER',
  zona: zona,
  secao: secao,
  updatedAt: DateTime.utc(2026, 10, 10),
);

/// The server's meuLocal endpoint and the auth session, in memory.
class FakeContaSource implements ContaSource {
  FakeContaSource({bool signedIn = false, this.place})
    : signedIn = ValueNotifier(signedIn);

  @override
  final ValueNotifier<bool> signedIn;
  VoterPlace? place;
  Object? failWith;
  final saved = <(String, int, int?, int?)>[];

  void signIn() => signedIn.value = true;

  @override
  Future<VoterPlace?> ler() async {
    if (failWith != null) throw failWith!;
    return place;
  }

  @override
  Future<VoterPlace> salvar(String uf, int municipio, int? zona, int? secao) {
    if (failWith != null) return Future.error(failWith!);
    saved.add((uf, municipio, zona, secao));
    return Future.value(
      place = portoWalter(
        zona: zona,
        secao: secao,
      ).copyWith(municipio: municipio),
    );
  }

  @override
  Future<void> apagar() async => place = null;

  @override
  Future<void> sair() async => signedIn.value = false;

  @override
  Widget signInForm(BuildContext context) => const Text('[entrar]');
}
