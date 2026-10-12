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
import 'signature_status.dart' as _iomwgc6v;

/// A signed TSE result file (EA20) as fetched for Resultados: the raw
/// `.jws`, so every figure shown can be traced back to it.
abstract class ResultFile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResultFile._({
    this.id,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.tseGeneratedAt,
    required this.fetchedAt,
    required this.rawSha256,
    required this.signature,
    required this.jws,
  });

  factory ResultFile({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    required _iomwgc6v.SignatureStatus signature,
    required String jws,
  }) = _ResultFileImpl;

  factory ResultFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultFile(
      id: jsonSerialization['id'] as int?,
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      tseGeneratedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['tseGeneratedAt'],
      ),
      fetchedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['fetchedAt'],
      ),
      rawSha256: jsonSerialization['rawSha256'] as String,
      signature: _iomwgc6v.SignatureStatus.fromJson(
        (jsonSerialization['signature'] as String),
      ),
      jws: jsonSerialization['jws'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int electionCode;

  int officeCode;

  /// Lowercase scope: `br`, a UF, `zz`, or a municipality (`sp71072`).
  String scopeCode;

  DateTime tseGeneratedAt;

  DateTime fetchedAt;

  /// SHA-256 of the `.jws` bytes, hex.
  String rawSha256;

  _iomwgc6v.SignatureStatus signature;

  String jws;

  /// Returns a shallow copy of this [ResultFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResultFile copyWith({
    int? id,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? jws,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultFile',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      'signature': signature.toJson(),
      'jws': jws,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultFile',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      'signature': signature.toJson(),
      'jws': jws,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResultFileImpl extends ResultFile {
  _ResultFileImpl({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    required _iomwgc6v.SignatureStatus signature,
    required String jws,
  }) : super._(
         id: id,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         tseGeneratedAt: tseGeneratedAt,
         fetchedAt: fetchedAt,
         rawSha256: rawSha256,
         signature: signature,
         jws: jws,
       );

  /// Returns a shallow copy of this [ResultFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResultFile copyWith({
    Object? id = _Undefined,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? jws,
  }) {
    return ResultFile(
      id: id is int? ? id : this.id,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      tseGeneratedAt: tseGeneratedAt ?? this.tseGeneratedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rawSha256: rawSha256 ?? this.rawSha256,
      signature: signature ?? this.signature,
      jws: jws ?? this.jws,
    );
  }
}
