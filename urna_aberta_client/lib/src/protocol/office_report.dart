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
import 'candidate_report.dart' as _i8xvblpk;
import 'list_report.dart' as _i49o1wen;
import 'seat_check.dart' as _idhahere;
import 'signature_status.dart' as _iomwgc6v;

/// One office in one scope: TSE's published result and, for proportional
/// offices, Urna Aberta's own seat allocation compared with TSE's.
abstract class OfficeReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OfficeReport._({
    required this.electionCode,
    required this.round,
    required this.officeCode,
    required this.proportional,
    required this.scopeCode,
    required this.seats,
    required this.fileName,
    required this.signature,
    required this.tseGeneratedAt,
    required this.sectionsTotal,
    required this.sectionsTotalized,
    required this.totalVotes,
    required this.validVotes,
    required this.nominalVotes,
    required this.legendVotes,
    required this.blankVotes,
    required this.nullVotes,
    required this.annulledSubJudice,
    required this.lists,
    required this.candidates,
    this.seatCheck,
  });

  factory OfficeReport({
    required int electionCode,
    required int round,
    required int officeCode,
    required bool proportional,
    required String scopeCode,
    required int seats,
    required String fileName,
    required _iomwgc6v.SignatureStatus signature,
    required DateTime tseGeneratedAt,
    required int sectionsTotal,
    required int sectionsTotalized,
    required int totalVotes,
    required int validVotes,
    required int nominalVotes,
    required int legendVotes,
    required int blankVotes,
    required int nullVotes,
    required int annulledSubJudice,
    required List<_i49o1wen.ListReport> lists,
    required List<_i8xvblpk.CandidateReport> candidates,
    _idhahere.SeatCheck? seatCheck,
  }) = _OfficeReportImpl;

  factory OfficeReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfficeReport(
      electionCode: jsonSerialization['electionCode'] as int,
      round: jsonSerialization['round'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      proportional: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['proportional'],
      ),
      scopeCode: jsonSerialization['scopeCode'] as String,
      seats: jsonSerialization['seats'] as int,
      fileName: jsonSerialization['fileName'] as String,
      signature: _iomwgc6v.SignatureStatus.fromJson(
        (jsonSerialization['signature'] as String),
      ),
      tseGeneratedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['tseGeneratedAt'],
      ),
      sectionsTotal: jsonSerialization['sectionsTotal'] as int,
      sectionsTotalized: jsonSerialization['sectionsTotalized'] as int,
      totalVotes: jsonSerialization['totalVotes'] as int,
      validVotes: jsonSerialization['validVotes'] as int,
      nominalVotes: jsonSerialization['nominalVotes'] as int,
      legendVotes: jsonSerialization['legendVotes'] as int,
      blankVotes: jsonSerialization['blankVotes'] as int,
      nullVotes: jsonSerialization['nullVotes'] as int,
      annulledSubJudice: jsonSerialization['annulledSubJudice'] as int,
      lists: _ihdok87d.Protocol().deserialize<List<_i49o1wen.ListReport>>(
        jsonSerialization['lists'],
      ),
      candidates: _ihdok87d.Protocol()
          .deserialize<List<_i8xvblpk.CandidateReport>>(
            jsonSerialization['candidates'],
          ),
      seatCheck: jsonSerialization['seatCheck'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<_idhahere.SeatCheck>(
              jsonSerialization['seatCheck'],
            ),
    );
  }

  int electionCode;

  int round;

  int officeCode;

  bool proportional;

  String scopeCode;

  int seats;

  /// TSE file name, e.g. `sp-c0006-e006259-u.jws`.
  String fileName;

  _iomwgc6v.SignatureStatus signature;

  DateTime tseGeneratedAt;

  int sectionsTotal;

  int sectionsTotalized;

  int totalVotes;

  int validVotes;

  int nominalVotes;

  int legendVotes;

  int blankVotes;

  int nullVotes;

  int annulledSubJudice;

  List<_i49o1wen.ListReport> lists;

  /// Ordered by votes, highest first.
  List<_i8xvblpk.CandidateReport> candidates;

  /// Proportional offices only.
  _idhahere.SeatCheck? seatCheck;

  /// Returns a shallow copy of this [OfficeReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OfficeReport copyWith({
    int? electionCode,
    int? round,
    int? officeCode,
    bool? proportional,
    String? scopeCode,
    int? seats,
    String? fileName,
    _iomwgc6v.SignatureStatus? signature,
    DateTime? tseGeneratedAt,
    int? sectionsTotal,
    int? sectionsTotalized,
    int? totalVotes,
    int? validVotes,
    int? nominalVotes,
    int? legendVotes,
    int? blankVotes,
    int? nullVotes,
    int? annulledSubJudice,
    List<_i49o1wen.ListReport>? lists,
    List<_i8xvblpk.CandidateReport>? candidates,
    _idhahere.SeatCheck? seatCheck,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfficeReport',
      'electionCode': electionCode,
      'round': round,
      'officeCode': officeCode,
      'proportional': proportional,
      'scopeCode': scopeCode,
      'seats': seats,
      'fileName': fileName,
      'signature': signature.toJson(),
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
      'totalVotes': totalVotes,
      'validVotes': validVotes,
      'nominalVotes': nominalVotes,
      'legendVotes': legendVotes,
      'blankVotes': blankVotes,
      'nullVotes': nullVotes,
      'annulledSubJudice': annulledSubJudice,
      'lists': lists.toJson(valueToJson: (v) => v.toJson()),
      'candidates': candidates.toJson(valueToJson: (v) => v.toJson()),
      if (seatCheck != null) 'seatCheck': seatCheck?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OfficeReport',
      'electionCode': electionCode,
      'round': round,
      'officeCode': officeCode,
      'proportional': proportional,
      'scopeCode': scopeCode,
      'seats': seats,
      'fileName': fileName,
      'signature': signature.toJson(),
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
      'totalVotes': totalVotes,
      'validVotes': validVotes,
      'nominalVotes': nominalVotes,
      'legendVotes': legendVotes,
      'blankVotes': blankVotes,
      'nullVotes': nullVotes,
      'annulledSubJudice': annulledSubJudice,
      'lists': lists.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'candidates': candidates.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (seatCheck != null) 'seatCheck': seatCheck?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfficeReportImpl extends OfficeReport {
  _OfficeReportImpl({
    required int electionCode,
    required int round,
    required int officeCode,
    required bool proportional,
    required String scopeCode,
    required int seats,
    required String fileName,
    required _iomwgc6v.SignatureStatus signature,
    required DateTime tseGeneratedAt,
    required int sectionsTotal,
    required int sectionsTotalized,
    required int totalVotes,
    required int validVotes,
    required int nominalVotes,
    required int legendVotes,
    required int blankVotes,
    required int nullVotes,
    required int annulledSubJudice,
    required List<_i49o1wen.ListReport> lists,
    required List<_i8xvblpk.CandidateReport> candidates,
    _idhahere.SeatCheck? seatCheck,
  }) : super._(
         electionCode: electionCode,
         round: round,
         officeCode: officeCode,
         proportional: proportional,
         scopeCode: scopeCode,
         seats: seats,
         fileName: fileName,
         signature: signature,
         tseGeneratedAt: tseGeneratedAt,
         sectionsTotal: sectionsTotal,
         sectionsTotalized: sectionsTotalized,
         totalVotes: totalVotes,
         validVotes: validVotes,
         nominalVotes: nominalVotes,
         legendVotes: legendVotes,
         blankVotes: blankVotes,
         nullVotes: nullVotes,
         annulledSubJudice: annulledSubJudice,
         lists: lists,
         candidates: candidates,
         seatCheck: seatCheck,
       );

  /// Returns a shallow copy of this [OfficeReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OfficeReport copyWith({
    int? electionCode,
    int? round,
    int? officeCode,
    bool? proportional,
    String? scopeCode,
    int? seats,
    String? fileName,
    _iomwgc6v.SignatureStatus? signature,
    DateTime? tseGeneratedAt,
    int? sectionsTotal,
    int? sectionsTotalized,
    int? totalVotes,
    int? validVotes,
    int? nominalVotes,
    int? legendVotes,
    int? blankVotes,
    int? nullVotes,
    int? annulledSubJudice,
    List<_i49o1wen.ListReport>? lists,
    List<_i8xvblpk.CandidateReport>? candidates,
    Object? seatCheck = _Undefined,
  }) {
    return OfficeReport(
      electionCode: electionCode ?? this.electionCode,
      round: round ?? this.round,
      officeCode: officeCode ?? this.officeCode,
      proportional: proportional ?? this.proportional,
      scopeCode: scopeCode ?? this.scopeCode,
      seats: seats ?? this.seats,
      fileName: fileName ?? this.fileName,
      signature: signature ?? this.signature,
      tseGeneratedAt: tseGeneratedAt ?? this.tseGeneratedAt,
      sectionsTotal: sectionsTotal ?? this.sectionsTotal,
      sectionsTotalized: sectionsTotalized ?? this.sectionsTotalized,
      totalVotes: totalVotes ?? this.totalVotes,
      validVotes: validVotes ?? this.validVotes,
      nominalVotes: nominalVotes ?? this.nominalVotes,
      legendVotes: legendVotes ?? this.legendVotes,
      blankVotes: blankVotes ?? this.blankVotes,
      nullVotes: nullVotes ?? this.nullVotes,
      annulledSubJudice: annulledSubJudice ?? this.annulledSubJudice,
      lists: lists ?? this.lists.map((e0) => e0.copyWith()).toList(),
      candidates:
          candidates ?? this.candidates.map((e0) => e0.copyWith()).toList(),
      seatCheck: seatCheck is _idhahere.SeatCheck?
          ? seatCheck
          : this.seatCheck?.copyWith(),
    );
  }
}
