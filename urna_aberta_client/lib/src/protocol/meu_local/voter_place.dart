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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:urna_aberta_client/src/protocol/protocol.dart' as _ihdok87d;

/// A signed-in viewer's own polling place, as they entered it. Deleted with
/// their account.
abstract class VoterPlace
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  VoterPlace._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.uf,
    required this.municipio,
    required this.municipioNome,
    this.zona,
    this.secao,
    required this.updatedAt,
  });

  factory VoterPlace({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String uf,
    required int municipio,
    required String municipioNome,
    int? zona,
    int? secao,
    required DateTime updatedAt,
  }) = _VoterPlaceImpl;

  factory VoterPlace.fromJson(Map<String, dynamic> jsonSerialization) {
    return VoterPlace(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      uf: jsonSerialization['uf'] as String,
      municipio: jsonSerialization['municipio'] as int,
      municipioNome: jsonSerialization['municipioNome'] as String,
      zona: jsonSerialization['zona'] as int?,
      secao: jsonSerialization['secao'] as int?,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  _iacc.AuthUser? authUser;

  /// TSE's lowercase UF code ('zz' is abroad).
  String uf;

  /// TSE's 5-digit municipality code.
  int municipio;

  String municipioNome;

  int? zona;

  int? secao;

  DateTime updatedAt;

  /// Returns a shallow copy of this [VoterPlace]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VoterPlace copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? uf,
    int? municipio,
    String? municipioNome,
    int? zona,
    int? secao,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VoterPlace',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'uf': uf,
      'municipio': municipio,
      'municipioNome': municipioNome,
      if (zona != null) 'zona': zona,
      if (secao != null) 'secao': secao,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VoterPlace',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'uf': uf,
      'municipio': municipio,
      'municipioNome': municipioNome,
      if (zona != null) 'zona': zona,
      if (secao != null) 'secao': secao,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VoterPlaceImpl extends VoterPlace {
  _VoterPlaceImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String uf,
    required int municipio,
    required String municipioNome,
    int? zona,
    int? secao,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         uf: uf,
         municipio: municipio,
         municipioNome: municipioNome,
         zona: zona,
         secao: secao,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [VoterPlace]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VoterPlace copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? uf,
    int? municipio,
    String? municipioNome,
    Object? zona = _Undefined,
    Object? secao = _Undefined,
    DateTime? updatedAt,
  }) {
    return VoterPlace(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      uf: uf ?? this.uf,
      municipio: municipio ?? this.municipio,
      municipioNome: municipioNome ?? this.municipioNome,
      zona: zona is int? ? zona : this.zona,
      secao: secao is int? ? secao : this.secao,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
