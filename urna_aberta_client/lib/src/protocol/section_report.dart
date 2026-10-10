/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:urna_aberta_client/src/protocol/protocol.dart' as _ihdok87d;
import 'bu_check.dart' as _ijbwnxcy;
import 'cargo_result.dart' as _i77b8h6f;
import 'section_file_info.dart' as _igdizl70;

/// Everything Urna Aberta knows about one polling section.
abstract class SectionReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SectionReport._({
    required this.uf,
    required this.municipio,
    required this.municipioNome,
    required this.zona,
    required this.secao,
    required this.status,
    this.auxGeneratedAt,
    this.receivedAt,
    this.emitidoEm,
    this.abertura,
    this.encerramento,
    this.local,
    this.aptos,
    this.comparecimento,
    required this.buCheck,
    required this.signatureVerified,
    required this.cargos,
    required this.files,
    this.fetchedAt,
  });

  factory SectionReport({
    required String uf,
    required int municipio,
    required String municipioNome,
    required int zona,
    required int secao,
    required String status,
    DateTime? auxGeneratedAt,
    DateTime? receivedAt,
    String? emitidoEm,
    String? abertura,
    String? encerramento,
    int? local,
    int? aptos,
    int? comparecimento,
    required _ijbwnxcy.BuCheck buCheck,
    required bool signatureVerified,
    required List<_i77b8h6f.CargoResult> cargos,
    required List<_igdizl70.SectionFileInfo> files,
    DateTime? fetchedAt,
  }) = _SectionReportImpl;

  factory SectionReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SectionReport(
      uf: jsonSerialization['uf'] as String,
      municipio: jsonSerialization['municipio'] as int,
      municipioNome: jsonSerialization['municipioNome'] as String,
      zona: jsonSerialization['zona'] as int,
      secao: jsonSerialization['secao'] as int,
      status: jsonSerialization['status'] as String,
      auxGeneratedAt: jsonSerialization['auxGeneratedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['auxGeneratedAt'],
            ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
            ),
      emitidoEm: jsonSerialization['emitidoEm'] as String?,
      abertura: jsonSerialization['abertura'] as String?,
      encerramento: jsonSerialization['encerramento'] as String?,
      local: jsonSerialization['local'] as int?,
      aptos: jsonSerialization['aptos'] as int?,
      comparecimento: jsonSerialization['comparecimento'] as int?,
      buCheck: _ijbwnxcy.BuCheck.fromJson(
        (jsonSerialization['buCheck'] as String),
      ),
      signatureVerified: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['signatureVerified'],
      ),
      cargos: _ihdok87d.Protocol().deserialize<List<_i77b8h6f.CargoResult>>(
        jsonSerialization['cargos'],
      ),
      files: _ihdok87d.Protocol().deserialize<List<_igdizl70.SectionFileInfo>>(
        jsonSerialization['files'],
      ),
      fetchedAt: jsonSerialization['fetchedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['fetchedAt']),
    );
  }

  String uf;

  int municipio;

  String municipioNome;

  int zona;

  int secao;

  /// EA18 status, or `Aguardando` when TSE has no aux file yet.
  String status;

  DateTime? auxGeneratedAt;

  /// When TSE received the urna files (UTC).
  DateTime? receivedAt;

  /// Urna clock times, local to the urna, `YYYY-MM-DDThh:mm:ss`.
  String? emitidoEm;

  String? abertura;

  String? encerramento;

  int? local;

  int? aptos;

  int? comparecimento;

  _ijbwnxcy.BuCheck buCheck;

  /// Always false for now: the urna's EdDSA signature is not verified.
  bool signatureVerified;

  /// Votes, only when buCheck is `matches`.
  List<_i77b8h6f.CargoResult> cargos;

  List<_igdizl70.SectionFileInfo> files;

  DateTime? fetchedAt;

  /// Returns a shallow copy of this [SectionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SectionReport copyWith({
    String? uf,
    int? municipio,
    String? municipioNome,
    int? zona,
    int? secao,
    String? status,
    DateTime? auxGeneratedAt,
    DateTime? receivedAt,
    String? emitidoEm,
    String? abertura,
    String? encerramento,
    int? local,
    int? aptos,
    int? comparecimento,
    _ijbwnxcy.BuCheck? buCheck,
    bool? signatureVerified,
    List<_i77b8h6f.CargoResult>? cargos,
    List<_igdizl70.SectionFileInfo>? files,
    DateTime? fetchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SectionReport',
      'uf': uf,
      'municipio': municipio,
      'municipioNome': municipioNome,
      'zona': zona,
      'secao': secao,
      'status': status,
      if (auxGeneratedAt != null) 'auxGeneratedAt': auxGeneratedAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (emitidoEm != null) 'emitidoEm': emitidoEm,
      if (abertura != null) 'abertura': abertura,
      if (encerramento != null) 'encerramento': encerramento,
      if (local != null) 'local': local,
      if (aptos != null) 'aptos': aptos,
      if (comparecimento != null) 'comparecimento': comparecimento,
      'buCheck': buCheck.toJson(),
      'signatureVerified': signatureVerified,
      'cargos': cargos.toJson(valueToJson: (v) => v.toJson()),
      'files': files.toJson(valueToJson: (v) => v.toJson()),
      if (fetchedAt != null) 'fetchedAt': fetchedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SectionReport',
      'uf': uf,
      'municipio': municipio,
      'municipioNome': municipioNome,
      'zona': zona,
      'secao': secao,
      'status': status,
      if (auxGeneratedAt != null) 'auxGeneratedAt': auxGeneratedAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (emitidoEm != null) 'emitidoEm': emitidoEm,
      if (abertura != null) 'abertura': abertura,
      if (encerramento != null) 'encerramento': encerramento,
      if (local != null) 'local': local,
      if (aptos != null) 'aptos': aptos,
      if (comparecimento != null) 'comparecimento': comparecimento,
      'buCheck': buCheck.toJson(),
      'signatureVerified': signatureVerified,
      'cargos': cargos.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'files': files.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (fetchedAt != null) 'fetchedAt': fetchedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectionReportImpl extends SectionReport {
  _SectionReportImpl({
    required String uf,
    required int municipio,
    required String municipioNome,
    required int zona,
    required int secao,
    required String status,
    DateTime? auxGeneratedAt,
    DateTime? receivedAt,
    String? emitidoEm,
    String? abertura,
    String? encerramento,
    int? local,
    int? aptos,
    int? comparecimento,
    required _ijbwnxcy.BuCheck buCheck,
    required bool signatureVerified,
    required List<_i77b8h6f.CargoResult> cargos,
    required List<_igdizl70.SectionFileInfo> files,
    DateTime? fetchedAt,
  }) : super._(
         uf: uf,
         municipio: municipio,
         municipioNome: municipioNome,
         zona: zona,
         secao: secao,
         status: status,
         auxGeneratedAt: auxGeneratedAt,
         receivedAt: receivedAt,
         emitidoEm: emitidoEm,
         abertura: abertura,
         encerramento: encerramento,
         local: local,
         aptos: aptos,
         comparecimento: comparecimento,
         buCheck: buCheck,
         signatureVerified: signatureVerified,
         cargos: cargos,
         files: files,
         fetchedAt: fetchedAt,
       );

  /// Returns a shallow copy of this [SectionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SectionReport copyWith({
    String? uf,
    int? municipio,
    String? municipioNome,
    int? zona,
    int? secao,
    String? status,
    Object? auxGeneratedAt = _Undefined,
    Object? receivedAt = _Undefined,
    Object? emitidoEm = _Undefined,
    Object? abertura = _Undefined,
    Object? encerramento = _Undefined,
    Object? local = _Undefined,
    Object? aptos = _Undefined,
    Object? comparecimento = _Undefined,
    _ijbwnxcy.BuCheck? buCheck,
    bool? signatureVerified,
    List<_i77b8h6f.CargoResult>? cargos,
    List<_igdizl70.SectionFileInfo>? files,
    Object? fetchedAt = _Undefined,
  }) {
    return SectionReport(
      uf: uf ?? this.uf,
      municipio: municipio ?? this.municipio,
      municipioNome: municipioNome ?? this.municipioNome,
      zona: zona ?? this.zona,
      secao: secao ?? this.secao,
      status: status ?? this.status,
      auxGeneratedAt: auxGeneratedAt is DateTime?
          ? auxGeneratedAt
          : this.auxGeneratedAt,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      emitidoEm: emitidoEm is String? ? emitidoEm : this.emitidoEm,
      abertura: abertura is String? ? abertura : this.abertura,
      encerramento: encerramento is String? ? encerramento : this.encerramento,
      local: local is int? ? local : this.local,
      aptos: aptos is int? ? aptos : this.aptos,
      comparecimento: comparecimento is int?
          ? comparecimento
          : this.comparecimento,
      buCheck: buCheck ?? this.buCheck,
      signatureVerified: signatureVerified ?? this.signatureVerified,
      cargos: cargos ?? this.cargos.map((e0) => e0.copyWith()).toList(),
      files: files ?? this.files.map((e0) => e0.copyWith()).toList(),
      fetchedAt: fetchedAt is DateTime? ? fetchedAt : this.fetchedAt,
    );
  }
}
