import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

/// What the report screens need from the server; [ServerRelatoriosSource]
/// wraps the generated client.
abstract interface class RelatoriosSource {
  Future<ReportQuote> orcar(ReportSpec spec);
  Future<ReportRequest> pedir(ReportSpec spec);
  Future<List<ReportRequest>> listar();
  Stream<ReportRequest> acompanhar(int id);

  /// A download link valid for ten minutes.
  Future<String> link(int id, String formato);
  Future<ReportRequest> publicar(int id, bool publico);
  Future<String?> linkPublico(int id);
  Future<void> apagar(int id);
}

class ServerRelatoriosSource implements RelatoriosSource {
  ServerRelatoriosSource(this._client);

  final Client _client;

  @override
  Future<ReportQuote> orcar(ReportSpec spec) => _client.relatorios.orcar(spec);

  @override
  Future<ReportRequest> pedir(ReportSpec spec) =>
      _client.relatorios.pedir(spec);

  @override
  Future<List<ReportRequest>> listar() => _client.relatorios.listar();

  @override
  Stream<ReportRequest> acompanhar(int id) => _client.relatorios.acompanhar(id);

  @override
  Future<String> link(int id, String formato) =>
      _client.relatorios.link(id, formato);

  @override
  Future<ReportRequest> publicar(int id, bool publico) =>
      _client.relatorios.publicar(id, publico);

  @override
  Future<String?> linkPublico(int id) => _client.relatorios.linkPublico(id);

  @override
  Future<void> apagar(int id) => _client.relatorios.apagar(id);
}

/// Provides the [RelatoriosSource]; screens hide their report actions
/// without it.
class RelatoriosScope extends InheritedWidget {
  const RelatoriosScope({
    super.key,
    required this.source,
    required super.child,
  });

  final RelatoriosSource source;

  static RelatoriosSource? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RelatoriosScope>()?.source;

  @override
  bool updateShouldNotify(RelatoriosScope old) => source != old.source;
}
