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

/// Votes of one kind (a candidacy, a party, blank or null) in a BU.
abstract class VotoResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  VotoResult._({
    required this.tipo,
    this.numero,
    this.partido,
    this.nome,
    required this.votos,
  });

  factory VotoResult({
    required String tipo,
    int? numero,
    int? partido,
    String? nome,
    required int votos,
  }) = _VotoResultImpl;

  factory VotoResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return VotoResult(
      tipo: jsonSerialization['tipo'] as String,
      numero: jsonSerialization['numero'] as int?,
      partido: jsonSerialization['partido'] as int?,
      nome: jsonSerialization['nome'] as String?,
      votos: jsonSerialization['votos'] as int,
    );
  }

  /// nominal, legenda, branco, nulo or cargoSemCandidato.
  String tipo;

  int? numero;

  int? partido;

  /// Ballot name when a stored result file lists the number.
  String? nome;

  int votos;

  /// Returns a shallow copy of this [VotoResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VotoResult copyWith({
    String? tipo,
    int? numero,
    int? partido,
    String? nome,
    int? votos,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VotoResult',
      'tipo': tipo,
      if (numero != null) 'numero': numero,
      if (partido != null) 'partido': partido,
      if (nome != null) 'nome': nome,
      'votos': votos,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VotoResult',
      'tipo': tipo,
      if (numero != null) 'numero': numero,
      if (partido != null) 'partido': partido,
      if (nome != null) 'nome': nome,
      'votos': votos,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VotoResultImpl extends VotoResult {
  _VotoResultImpl({
    required String tipo,
    int? numero,
    int? partido,
    String? nome,
    required int votos,
  }) : super._(
         tipo: tipo,
         numero: numero,
         partido: partido,
         nome: nome,
         votos: votos,
       );

  /// Returns a shallow copy of this [VotoResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VotoResult copyWith({
    String? tipo,
    Object? numero = _Undefined,
    Object? partido = _Undefined,
    Object? nome = _Undefined,
    int? votos,
  }) {
    return VotoResult(
      tipo: tipo ?? this.tipo,
      numero: numero is int? ? numero : this.numero,
      partido: partido is int? ? partido : this.partido,
      nome: nome is String? ? nome : this.nome,
      votos: votos ?? this.votos,
    );
  }
}
