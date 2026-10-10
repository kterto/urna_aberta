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
import 'voto_result.dart' as _iuhijha9;

/// One office's votes in a section's BU.
abstract class CargoResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CargoResult._({
    required this.eleicao,
    required this.codigo,
    required this.nome,
    required this.comparecimento,
    required this.votos,
  });

  factory CargoResult({
    required int eleicao,
    required int codigo,
    required String nome,
    required int comparecimento,
    required List<_iuhijha9.VotoResult> votos,
  }) = _CargoResultImpl;

  factory CargoResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return CargoResult(
      eleicao: jsonSerialization['eleicao'] as int,
      codigo: jsonSerialization['codigo'] as int,
      nome: jsonSerialization['nome'] as String,
      comparecimento: jsonSerialization['comparecimento'] as int,
      votos: _ihdok87d.Protocol().deserialize<List<_iuhijha9.VotoResult>>(
        jsonSerialization['votos'],
      ),
    );
  }

  int eleicao;

  /// TSE office code (1 President, 3 Governor, 5 Senator, 6 Federal Deputy…).
  int codigo;

  String nome;

  int comparecimento;

  List<_iuhijha9.VotoResult> votos;

  /// Returns a shallow copy of this [CargoResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CargoResult copyWith({
    int? eleicao,
    int? codigo,
    String? nome,
    int? comparecimento,
    List<_iuhijha9.VotoResult>? votos,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CargoResult',
      'eleicao': eleicao,
      'codigo': codigo,
      'nome': nome,
      'comparecimento': comparecimento,
      'votos': votos.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CargoResult',
      'eleicao': eleicao,
      'codigo': codigo,
      'nome': nome,
      'comparecimento': comparecimento,
      'votos': votos.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CargoResultImpl extends CargoResult {
  _CargoResultImpl({
    required int eleicao,
    required int codigo,
    required String nome,
    required int comparecimento,
    required List<_iuhijha9.VotoResult> votos,
  }) : super._(
         eleicao: eleicao,
         codigo: codigo,
         nome: nome,
         comparecimento: comparecimento,
         votos: votos,
       );

  /// Returns a shallow copy of this [CargoResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CargoResult copyWith({
    int? eleicao,
    int? codigo,
    String? nome,
    int? comparecimento,
    List<_iuhijha9.VotoResult>? votos,
  }) {
    return CargoResult(
      eleicao: eleicao ?? this.eleicao,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      comparecimento: comparecimento ?? this.comparecimento,
      votos: votos ?? this.votos.map((e0) => e0.copyWith()).toList(),
    );
  }
}
