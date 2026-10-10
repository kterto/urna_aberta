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
import 'data_origin.dart' as _i2ilnjuc;
import 'signature_status.dart' as _iomwgc6v;

/// The newest stored version of one published result file and how its
/// signature checked out.
abstract class FileVerification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FileVerification._({
    required this.snapshotId,
    required this.origin,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.fileName,
    required this.url,
    required this.tseGeneratedAt,
    required this.sha256,
    this.signature,
    this.kid,
  });

  factory FileVerification({
    required int snapshotId,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required String fileName,
    required String url,
    required DateTime tseGeneratedAt,
    required String sha256,
    _iomwgc6v.SignatureStatus? signature,
    String? kid,
  }) = _FileVerificationImpl;

  factory FileVerification.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileVerification(
      snapshotId: jsonSerialization['snapshotId'] as int,
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      fileName: jsonSerialization['fileName'] as String,
      url: jsonSerialization['url'] as String,
      tseGeneratedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['tseGeneratedAt'],
      ),
      sha256: jsonSerialization['sha256'] as String,
      signature: jsonSerialization['signature'] == null
          ? null
          : _iomwgc6v.SignatureStatus.fromJson(
              (jsonSerialization['signature'] as String),
            ),
      kid: jsonSerialization['kid'] as String?,
    );
  }

  int snapshotId;

  _i2ilnjuc.DataOrigin origin;

  int electionCode;

  /// TSE office code: 1 President, 3 Governor, 5 Senator.
  int officeCode;

  /// Lowercase scope: `br`, a UF, or `zz` (exterior).
  String scopeCode;

  /// The signed file's name, e.g. `br-c0001-e006257-u.jws`.
  String fileName;

  /// Where TSE publishes the signed file.
  String url;

  DateTime tseGeneratedAt;

  /// SHA-256 of the file (the JWS payload), hex.
  String sha256;

  /// Null when the file was stored without its `.jws`.
  _iomwgc6v.SignatureStatus? signature;

  String? kid;

  /// Returns a shallow copy of this [FileVerification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FileVerification copyWith({
    int? snapshotId,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    String? fileName,
    String? url,
    DateTime? tseGeneratedAt,
    String? sha256,
    _iomwgc6v.SignatureStatus? signature,
    String? kid,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileVerification',
      'snapshotId': snapshotId,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'fileName': fileName,
      'url': url,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'sha256': sha256,
      if (signature != null) 'signature': signature?.toJson(),
      if (kid != null) 'kid': kid,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileVerification',
      'snapshotId': snapshotId,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'fileName': fileName,
      'url': url,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'sha256': sha256,
      if (signature != null) 'signature': signature?.toJson(),
      if (kid != null) 'kid': kid,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FileVerificationImpl extends FileVerification {
  _FileVerificationImpl({
    required int snapshotId,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required String fileName,
    required String url,
    required DateTime tseGeneratedAt,
    required String sha256,
    _iomwgc6v.SignatureStatus? signature,
    String? kid,
  }) : super._(
         snapshotId: snapshotId,
         origin: origin,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         fileName: fileName,
         url: url,
         tseGeneratedAt: tseGeneratedAt,
         sha256: sha256,
         signature: signature,
         kid: kid,
       );

  /// Returns a shallow copy of this [FileVerification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FileVerification copyWith({
    int? snapshotId,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    String? fileName,
    String? url,
    DateTime? tseGeneratedAt,
    String? sha256,
    Object? signature = _Undefined,
    Object? kid = _Undefined,
  }) {
    return FileVerification(
      snapshotId: snapshotId ?? this.snapshotId,
      origin: origin ?? this.origin,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      tseGeneratedAt: tseGeneratedAt ?? this.tseGeneratedAt,
      sha256: sha256 ?? this.sha256,
      signature: signature is _iomwgc6v.SignatureStatus?
          ? signature
          : this.signature,
      kid: kid is String? ? kid : this.kid,
    );
  }
}
