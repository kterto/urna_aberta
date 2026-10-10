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

abstract class MunicipioRef
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MunicipioRef._({
    required this.codigo,
    required this.nome,
  });

  factory MunicipioRef({
    required int codigo,
    required String nome,
  }) = _MunicipioRefImpl;

  factory MunicipioRef.fromJson(Map<String, dynamic> jsonSerialization) {
    return MunicipioRef(
      codigo: jsonSerialization['codigo'] as int,
      nome: jsonSerialization['nome'] as String,
    );
  }

  int codigo;

  String nome;

  /// Returns a shallow copy of this [MunicipioRef]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MunicipioRef copyWith({
    int? codigo,
    String? nome,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MunicipioRef',
      'codigo': codigo,
      'nome': nome,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MunicipioRef',
      'codigo': codigo,
      'nome': nome,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MunicipioRefImpl extends MunicipioRef {
  _MunicipioRefImpl({
    required int codigo,
    required String nome,
  }) : super._(
         codigo: codigo,
         nome: nome,
       );

  /// Returns a shallow copy of this [MunicipioRef]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MunicipioRef copyWith({
    int? codigo,
    String? nome,
  }) {
    return MunicipioRef(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
    );
  }
}
