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
import '../reports/report_spec.dart' as _iqf2o9z7;
import '../reports/report_status.dart' as _i5iav6pq;

/// A report a signed-in viewer asked for: its spec, its progress through
/// the queue and, once ready, its files in private storage. Deleted with
/// the account.
abstract class ReportRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReportRequest._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.spec,
    required this.status,
    required this.filesDone,
    required this.filesTotal,
    this.errorReason,
    required this.createdAt,
    this.startedAt,
    this.finishedAt,
    this.sha256,
    this.publicToken,
  });

  factory ReportRequest({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required _iqf2o9z7.ReportSpec spec,
    required _i5iav6pq.ReportStatus status,
    required int filesDone,
    required int filesTotal,
    String? errorReason,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? sha256,
    String? publicToken,
  }) = _ReportRequestImpl;

  factory ReportRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportRequest(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      spec: _ihdok87d.Protocol().deserialize<_iqf2o9z7.ReportSpec>(
        jsonSerialization['spec'],
      ),
      status: _i5iav6pq.ReportStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      filesDone: jsonSerialization['filesDone'] as int,
      filesTotal: jsonSerialization['filesTotal'] as int,
      errorReason: jsonSerialization['errorReason'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
      sha256: jsonSerialization['sha256'] as String?,
      publicToken: jsonSerialization['publicToken'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  _iacc.AuthUser? authUser;

  _iqf2o9z7.ReportSpec spec;

  _i5iav6pq.ReportStatus status;

  /// TSE files read so far, of those the report needs.
  int filesDone;

  int filesTotal;

  /// Why it failed: `tseUnavailable`, `invalidRequest` or `internal`.
  String? errorReason;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? finishedAt;

  /// SHA-256 of the CSV (the report's data), printed on the PDF.
  String? sha256;

  /// Set while the owner publishes it: the report is then readable by
  /// anyone at `/r/<publicToken>`.
  String? publicToken;

  /// Returns a shallow copy of this [ReportRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReportRequest copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    _iqf2o9z7.ReportSpec? spec,
    _i5iav6pq.ReportStatus? status,
    int? filesDone,
    int? filesTotal,
    String? errorReason,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? sha256,
    String? publicToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportRequest',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'spec': spec.toJson(),
      'status': status.toJson(),
      'filesDone': filesDone,
      'filesTotal': filesTotal,
      if (errorReason != null) 'errorReason': errorReason,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (sha256 != null) 'sha256': sha256,
      if (publicToken != null) 'publicToken': publicToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportRequest',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'spec': spec.toJsonForProtocol(),
      'status': status.toJson(),
      'filesDone': filesDone,
      'filesTotal': filesTotal,
      if (errorReason != null) 'errorReason': errorReason,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (sha256 != null) 'sha256': sha256,
      if (publicToken != null) 'publicToken': publicToken,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportRequestImpl extends ReportRequest {
  _ReportRequestImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required _iqf2o9z7.ReportSpec spec,
    required _i5iav6pq.ReportStatus status,
    required int filesDone,
    required int filesTotal,
    String? errorReason,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? sha256,
    String? publicToken,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         spec: spec,
         status: status,
         filesDone: filesDone,
         filesTotal: filesTotal,
         errorReason: errorReason,
         createdAt: createdAt,
         startedAt: startedAt,
         finishedAt: finishedAt,
         sha256: sha256,
         publicToken: publicToken,
       );

  /// Returns a shallow copy of this [ReportRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReportRequest copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    _iqf2o9z7.ReportSpec? spec,
    _i5iav6pq.ReportStatus? status,
    int? filesDone,
    int? filesTotal,
    Object? errorReason = _Undefined,
    DateTime? createdAt,
    Object? startedAt = _Undefined,
    Object? finishedAt = _Undefined,
    Object? sha256 = _Undefined,
    Object? publicToken = _Undefined,
  }) {
    return ReportRequest(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      spec: spec ?? this.spec.copyWith(),
      status: status ?? this.status,
      filesDone: filesDone ?? this.filesDone,
      filesTotal: filesTotal ?? this.filesTotal,
      errorReason: errorReason is String? ? errorReason : this.errorReason,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
      sha256: sha256 is String? ? sha256 : this.sha256,
      publicToken: publicToken is String? ? publicToken : this.publicToken,
    );
  }
}
