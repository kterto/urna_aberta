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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:urna_aberta_client/src/protocol/protocol.dart' as _ihdok87d;
import 'section_check.dart' as _i1fk3nml;

/// A raw TSE file stored exactly as fetched.
abstract class SectionFile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SectionFile._({
    this.id,
    required this.checkId,
    this.check,
    required this.kind,
    required this.name,
    required this.url,
    required this.sha256,
    required this.content,
    this.receivedAt,
  });

  factory SectionFile({
    int? id,
    required int checkId,
    _i1fk3nml.SectionCheck? check,
    required String kind,
    required String name,
    required String url,
    required String sha256,
    required _idt.ByteData content,
    DateTime? receivedAt,
  }) = _SectionFileImpl;

  factory SectionFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return SectionFile(
      id: jsonSerialization['id'] as int?,
      checkId: jsonSerialization['checkId'] as int,
      check: jsonSerialization['check'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<_i1fk3nml.SectionCheck>(
              jsonSerialization['check'],
            ),
      kind: jsonSerialization['kind'] as String,
      name: jsonSerialization['name'] as String,
      url: jsonSerialization['url'] as String,
      sha256: jsonSerialization['sha256'] as String,
      content: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['content'],
      ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int checkId;

  _i1fk3nml.SectionCheck? check;

  /// aux, bu or vota.
  String kind;

  String name;

  String url;

  String sha256;

  _idt.ByteData content;

  /// When TSE received the urna files (UTC); null for the aux file.
  DateTime? receivedAt;

  /// Returns a shallow copy of this [SectionFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SectionFile copyWith({
    int? id,
    int? checkId,
    _i1fk3nml.SectionCheck? check,
    String? kind,
    String? name,
    String? url,
    String? sha256,
    _idt.ByteData? content,
    DateTime? receivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SectionFile',
      if (id != null) 'id': id,
      'checkId': checkId,
      if (check != null) 'check': check?.toJson(),
      'kind': kind,
      'name': name,
      'url': url,
      'sha256': sha256,
      'content': content.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SectionFile',
      if (id != null) 'id': id,
      'checkId': checkId,
      if (check != null) 'check': check?.toJsonForProtocol(),
      'kind': kind,
      'name': name,
      'url': url,
      'sha256': sha256,
      'content': content.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectionFileImpl extends SectionFile {
  _SectionFileImpl({
    int? id,
    required int checkId,
    _i1fk3nml.SectionCheck? check,
    required String kind,
    required String name,
    required String url,
    required String sha256,
    required _idt.ByteData content,
    DateTime? receivedAt,
  }) : super._(
         id: id,
         checkId: checkId,
         check: check,
         kind: kind,
         name: name,
         url: url,
         sha256: sha256,
         content: content,
         receivedAt: receivedAt,
       );

  /// Returns a shallow copy of this [SectionFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SectionFile copyWith({
    Object? id = _Undefined,
    int? checkId,
    Object? check = _Undefined,
    String? kind,
    String? name,
    String? url,
    String? sha256,
    _idt.ByteData? content,
    Object? receivedAt = _Undefined,
  }) {
    return SectionFile(
      id: id is int? ? id : this.id,
      checkId: checkId ?? this.checkId,
      check: check is _i1fk3nml.SectionCheck? ? check : this.check?.copyWith(),
      kind: kind ?? this.kind,
      name: name ?? this.name,
      url: url ?? this.url,
      sha256: sha256 ?? this.sha256,
      content: content ?? this.content.clone(),
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
    );
  }
}
