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
import 'result_snapshot.dart' as _i4dv59av;

/// Votes for one candidate in one [ResultSnapshot].
abstract class CandidateTally
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CandidateTally._({
    this.id,
    required this.snapshotId,
    this.snapshot,
    required this.candidateNumber,
    required this.votes,
  });

  factory CandidateTally({
    int? id,
    required int snapshotId,
    _i4dv59av.ResultSnapshot? snapshot,
    required int candidateNumber,
    required int votes,
  }) = _CandidateTallyImpl;

  factory CandidateTally.fromJson(Map<String, dynamic> jsonSerialization) {
    return CandidateTally(
      id: jsonSerialization['id'] as int?,
      snapshotId: jsonSerialization['snapshotId'] as int,
      snapshot: jsonSerialization['snapshot'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<_i4dv59av.ResultSnapshot>(
              jsonSerialization['snapshot'],
            ),
      candidateNumber: jsonSerialization['candidateNumber'] as int,
      votes: jsonSerialization['votes'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int snapshotId;

  _i4dv59av.ResultSnapshot? snapshot;

  int candidateNumber;

  int votes;

  /// Returns a shallow copy of this [CandidateTally]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CandidateTally copyWith({
    int? id,
    int? snapshotId,
    _i4dv59av.ResultSnapshot? snapshot,
    int? candidateNumber,
    int? votes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CandidateTally',
      if (id != null) 'id': id,
      'snapshotId': snapshotId,
      if (snapshot != null) 'snapshot': snapshot?.toJson(),
      'candidateNumber': candidateNumber,
      'votes': votes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CandidateTally',
      if (id != null) 'id': id,
      'snapshotId': snapshotId,
      if (snapshot != null) 'snapshot': snapshot?.toJsonForProtocol(),
      'candidateNumber': candidateNumber,
      'votes': votes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CandidateTallyImpl extends CandidateTally {
  _CandidateTallyImpl({
    int? id,
    required int snapshotId,
    _i4dv59av.ResultSnapshot? snapshot,
    required int candidateNumber,
    required int votes,
  }) : super._(
         id: id,
         snapshotId: snapshotId,
         snapshot: snapshot,
         candidateNumber: candidateNumber,
         votes: votes,
       );

  /// Returns a shallow copy of this [CandidateTally]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CandidateTally copyWith({
    Object? id = _Undefined,
    int? snapshotId,
    Object? snapshot = _Undefined,
    int? candidateNumber,
    int? votes,
  }) {
    return CandidateTally(
      id: id is int? ? id : this.id,
      snapshotId: snapshotId ?? this.snapshotId,
      snapshot: snapshot is _i4dv59av.ResultSnapshot?
          ? snapshot
          : this.snapshot?.copyWith(),
      candidateNumber: candidateNumber ?? this.candidateNumber,
      votes: votes ?? this.votes,
    );
  }
}
