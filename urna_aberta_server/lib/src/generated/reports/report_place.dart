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
import 'package:serverpod/serverpod.dart' as _is;
import '../reports/report_place_kind.dart' as _ix2z5zy6;

/// A place a report covers. The fields its kind needs are set: `regiao`
/// for a region (n, ne, co, se, s); `uf` and below for the rest, as TSE
/// codes (lowercase UF, 5-digit municipality).
abstract class ReportPlace
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReportPlace._({
    required this.kind,
    this.regiao,
    this.uf,
    this.municipio,
    this.zona,
    this.secao,
  });

  factory ReportPlace({
    required _ix2z5zy6.ReportPlaceKind kind,
    String? regiao,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
  }) = _ReportPlaceImpl;

  factory ReportPlace.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportPlace(
      kind: _ix2z5zy6.ReportPlaceKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      regiao: jsonSerialization['regiao'] as String?,
      uf: jsonSerialization['uf'] as String?,
      municipio: jsonSerialization['municipio'] as int?,
      zona: jsonSerialization['zona'] as int?,
      secao: jsonSerialization['secao'] as int?,
    );
  }

  _ix2z5zy6.ReportPlaceKind kind;

  String? regiao;

  String? uf;

  int? municipio;

  int? zona;

  int? secao;

  /// Returns a shallow copy of this [ReportPlace]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportPlace copyWith({
    _ix2z5zy6.ReportPlaceKind? kind,
    String? regiao,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportPlace',
      'kind': kind.toJson(),
      if (regiao != null) 'regiao': regiao,
      if (uf != null) 'uf': uf,
      if (municipio != null) 'municipio': municipio,
      if (zona != null) 'zona': zona,
      if (secao != null) 'secao': secao,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportPlace',
      'kind': kind.toJson(),
      if (regiao != null) 'regiao': regiao,
      if (uf != null) 'uf': uf,
      if (municipio != null) 'municipio': municipio,
      if (zona != null) 'zona': zona,
      if (secao != null) 'secao': secao,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportPlaceImpl extends ReportPlace {
  _ReportPlaceImpl({
    required _ix2z5zy6.ReportPlaceKind kind,
    String? regiao,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
  }) : super._(
         kind: kind,
         regiao: regiao,
         uf: uf,
         municipio: municipio,
         zona: zona,
         secao: secao,
       );

  /// Returns a shallow copy of this [ReportPlace]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportPlace copyWith({
    _ix2z5zy6.ReportPlaceKind? kind,
    Object? regiao = _Undefined,
    Object? uf = _Undefined,
    Object? municipio = _Undefined,
    Object? zona = _Undefined,
    Object? secao = _Undefined,
  }) {
    return ReportPlace(
      kind: kind ?? this.kind,
      regiao: regiao is String? ? regiao : this.regiao,
      uf: uf is String? ? uf : this.uf,
      municipio: municipio is int? ? municipio : this.municipio,
      zona: zona is int? ? zona : this.zona,
      secao: secao is int? ? secao : this.secao,
    );
  }
}
