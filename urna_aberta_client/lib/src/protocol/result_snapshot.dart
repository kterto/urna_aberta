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
import 'candidate_tally.dart' as _ixvsuy9r;
import 'data_origin.dart' as _i2ilnjuc;
import 'signature_status.dart' as _iomwgc6v;

/// One immutable version of a TSE EA20 result file.
abstract class ResultSnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResultSnapshot._({
    this.id,
    required this.origin,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.sectionsTotal,
    required this.sectionsTotalized,
    required this.tseGeneratedAt,
    required this.fetchedAt,
    required this.rawSha256,
    this.signature,
    this.signatureKid,
    this.jws,
    this.tallies,
  });

  factory ResultSnapshot({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int sectionsTotal,
    required int sectionsTotalized,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? signatureKid,
    String? jws,
    List<_ixvsuy9r.CandidateTally>? tallies,
  }) = _ResultSnapshotImpl;

  factory ResultSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultSnapshot(
      id: jsonSerialization['id'] as int?,
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      sectionsTotal: jsonSerialization['sectionsTotal'] as int,
      sectionsTotalized: jsonSerialization['sectionsTotalized'] as int,
      tseGeneratedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['tseGeneratedAt'],
      ),
      fetchedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['fetchedAt'],
      ),
      rawSha256: jsonSerialization['rawSha256'] as String,
      signature: jsonSerialization['signature'] == null
          ? null
          : _iomwgc6v.SignatureStatus.fromJson(
              (jsonSerialization['signature'] as String),
            ),
      signatureKid: jsonSerialization['signatureKid'] as String?,
      jws: jsonSerialization['jws'] as String?,
      tallies: jsonSerialization['tallies'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<List<_ixvsuy9r.CandidateTally>>(
              jsonSerialization['tallies'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2ilnjuc.DataOrigin origin;

  /// TSE election code, e.g. 6257 (Federal, 1st round 2026).
  int electionCode;

  /// TSE office code: 1 President, 3 Governor, 5 Senator.
  int officeCode;

  /// Lowercase scope: `br`, a UF, or `zz` (exterior).
  String scopeCode;

  int sectionsTotal;

  int sectionsTotalized;

  /// When TSE generated the file (UTC).
  DateTime tseGeneratedAt;

  DateTime fetchedAt;

  /// SHA-256 of the raw file bytes, hex.
  String rawSha256;

  /// JWS check result; null when the file came without its `.jws`.
  _iomwgc6v.SignatureStatus? signature;

  String? signatureKid;

  /// The `.jws` as received (compact serialization; its payload is the file).
  String? jws;

  List<_ixvsuy9r.CandidateTally>? tallies;

  /// Returns a shallow copy of this [ResultSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResultSnapshot copyWith({
    int? id,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? sectionsTotal,
    int? sectionsTotalized,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? signatureKid,
    String? jws,
    List<_ixvsuy9r.CandidateTally>? tallies,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultSnapshot',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      if (signature != null) 'signature': signature?.toJson(),
      if (signatureKid != null) 'signatureKid': signatureKid,
      if (jws != null) 'jws': jws,
      if (tallies != null)
        'tallies': tallies?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultSnapshot',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      if (signature != null) 'signature': signature?.toJson(),
      if (signatureKid != null) 'signatureKid': signatureKid,
      if (jws != null) 'jws': jws,
      if (tallies != null)
        'tallies': tallies?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResultSnapshotImpl extends ResultSnapshot {
  _ResultSnapshotImpl({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int sectionsTotal,
    required int sectionsTotalized,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? signatureKid,
    String? jws,
    List<_ixvsuy9r.CandidateTally>? tallies,
  }) : super._(
         id: id,
         origin: origin,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         sectionsTotal: sectionsTotal,
         sectionsTotalized: sectionsTotalized,
         tseGeneratedAt: tseGeneratedAt,
         fetchedAt: fetchedAt,
         rawSha256: rawSha256,
         signature: signature,
         signatureKid: signatureKid,
         jws: jws,
         tallies: tallies,
       );

  /// Returns a shallow copy of this [ResultSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResultSnapshot copyWith({
    Object? id = _Undefined,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? sectionsTotal,
    int? sectionsTotalized,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    Object? signature = _Undefined,
    Object? signatureKid = _Undefined,
    Object? jws = _Undefined,
    Object? tallies = _Undefined,
  }) {
    return ResultSnapshot(
      id: id is int? ? id : this.id,
      origin: origin ?? this.origin,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      sectionsTotal: sectionsTotal ?? this.sectionsTotal,
      sectionsTotalized: sectionsTotalized ?? this.sectionsTotalized,
      tseGeneratedAt: tseGeneratedAt ?? this.tseGeneratedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rawSha256: rawSha256 ?? this.rawSha256,
      signature: signature is _iomwgc6v.SignatureStatus?
          ? signature
          : this.signature,
      signatureKid: signatureKid is String? ? signatureKid : this.signatureKid,
      jws: jws is String? ? jws : this.jws,
      tallies: tallies is List<_ixvsuy9r.CandidateTally>?
          ? tallies
          : this.tallies?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
