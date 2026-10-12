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

/// A candidacy and its outcome.
abstract class CandidateReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CandidateReport._({
    required this.number,
    required this.ballotName,
    required this.party,
    required this.list,
    required this.votes,
    required this.validity,
    required this.elected,
    required this.tseStatus,
    this.ourSeat,
  });

  factory CandidateReport({
    required int number,
    required String ballotName,
    required String party,
    required String list,
    required int votes,
    required String validity,
    required bool elected,
    required String tseStatus,
    String? ourSeat,
  }) = _CandidateReportImpl;

  factory CandidateReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return CandidateReport(
      number: jsonSerialization['number'] as int,
      ballotName: jsonSerialization['ballotName'] as String,
      party: jsonSerialization['party'] as String,
      list: jsonSerialization['list'] as String,
      votes: jsonSerialization['votes'] as int,
      validity: jsonSerialization['validity'] as String,
      elected: _isc.BoolJsonExtension.fromJson(jsonSerialization['elected']),
      tseStatus: jsonSerialization['tseStatus'] as String,
      ourSeat: jsonSerialization['ourSeat'] as String?,
    );
  }

  int number;

  String ballotName;

  String party;

  String list;

  int votes;

  /// `valid`, `validForParty`, `annulled` or `annulledSubJudice`.
  String validity;

  bool elected;

  /// TSE's status as written, e.g. `Eleito por QP`, `Suplente`, `2º turno`.
  String tseStatus;

  /// Urna Aberta's seat: `QP`, `média`, or null when not elected by us.
  String? ourSeat;

  /// Returns a shallow copy of this [CandidateReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CandidateReport copyWith({
    int? number,
    String? ballotName,
    String? party,
    String? list,
    int? votes,
    String? validity,
    bool? elected,
    String? tseStatus,
    String? ourSeat,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CandidateReport',
      'number': number,
      'ballotName': ballotName,
      'party': party,
      'list': list,
      'votes': votes,
      'validity': validity,
      'elected': elected,
      'tseStatus': tseStatus,
      if (ourSeat != null) 'ourSeat': ourSeat,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CandidateReport',
      'number': number,
      'ballotName': ballotName,
      'party': party,
      'list': list,
      'votes': votes,
      'validity': validity,
      'elected': elected,
      'tseStatus': tseStatus,
      if (ourSeat != null) 'ourSeat': ourSeat,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CandidateReportImpl extends CandidateReport {
  _CandidateReportImpl({
    required int number,
    required String ballotName,
    required String party,
    required String list,
    required int votes,
    required String validity,
    required bool elected,
    required String tseStatus,
    String? ourSeat,
  }) : super._(
         number: number,
         ballotName: ballotName,
         party: party,
         list: list,
         votes: votes,
         validity: validity,
         elected: elected,
         tseStatus: tseStatus,
         ourSeat: ourSeat,
       );

  /// Returns a shallow copy of this [CandidateReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CandidateReport copyWith({
    int? number,
    String? ballotName,
    String? party,
    String? list,
    int? votes,
    String? validity,
    bool? elected,
    String? tseStatus,
    Object? ourSeat = _Undefined,
  }) {
    return CandidateReport(
      number: number ?? this.number,
      ballotName: ballotName ?? this.ballotName,
      party: party ?? this.party,
      list: list ?? this.list,
      votes: votes ?? this.votes,
      validity: validity ?? this.validity,
      elected: elected ?? this.elected,
      tseStatus: tseStatus ?? this.tseStatus,
      ourSeat: ourSeat is String? ? ourSeat : this.ourSeat,
    );
  }
}
