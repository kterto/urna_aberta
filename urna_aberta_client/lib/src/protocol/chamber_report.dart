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
import 'list_report.dart' as _i49o1wen;

/// The Câmara dos Deputados as elected: the 27 state races for Deputado
/// Federal summed by party or federation, with Urna Aberta's own count.
abstract class ChamberReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChamberReport._({
    required this.electionCode,
    required this.seats,
    required this.lists,
    required this.states,
    required this.matchingStates,
    required this.differingStates,
  });

  factory ChamberReport({
    required int electionCode,
    required int seats,
    required List<_i49o1wen.ListReport> lists,
    required int states,
    required int matchingStates,
    required List<String> differingStates,
  }) = _ChamberReportImpl;

  factory ChamberReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChamberReport(
      electionCode: jsonSerialization['electionCode'] as int,
      seats: jsonSerialization['seats'] as int,
      lists: _ihdok87d.Protocol().deserialize<List<_i49o1wen.ListReport>>(
        jsonSerialization['lists'],
      ),
      states: jsonSerialization['states'] as int,
      matchingStates: jsonSerialization['matchingStates'] as int,
      differingStates: _ihdok87d.Protocol().deserialize<List<String>>(
        jsonSerialization['differingStates'],
      ),
    );
  }

  int electionCode;

  int seats;

  /// Lists summed across states (matched by their parties); `number` is
  /// the party abbreviations joined with `/`.
  List<_i49o1wen.ListReport> lists;

  /// States read, and those where our allocation matches TSE's exactly.
  int states;

  int matchingStates;

  /// UFs where it does not, if any.
  List<String> differingStates;

  /// Returns a shallow copy of this [ChamberReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChamberReport copyWith({
    int? electionCode,
    int? seats,
    List<_i49o1wen.ListReport>? lists,
    int? states,
    int? matchingStates,
    List<String>? differingStates,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChamberReport',
      'electionCode': electionCode,
      'seats': seats,
      'lists': lists.toJson(valueToJson: (v) => v.toJson()),
      'states': states,
      'matchingStates': matchingStates,
      'differingStates': differingStates.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChamberReport',
      'electionCode': electionCode,
      'seats': seats,
      'lists': lists.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'states': states,
      'matchingStates': matchingStates,
      'differingStates': differingStates.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ChamberReportImpl extends ChamberReport {
  _ChamberReportImpl({
    required int electionCode,
    required int seats,
    required List<_i49o1wen.ListReport> lists,
    required int states,
    required int matchingStates,
    required List<String> differingStates,
  }) : super._(
         electionCode: electionCode,
         seats: seats,
         lists: lists,
         states: states,
         matchingStates: matchingStates,
         differingStates: differingStates,
       );

  /// Returns a shallow copy of this [ChamberReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChamberReport copyWith({
    int? electionCode,
    int? seats,
    List<_i49o1wen.ListReport>? lists,
    int? states,
    int? matchingStates,
    List<String>? differingStates,
  }) {
    return ChamberReport(
      electionCode: electionCode ?? this.electionCode,
      seats: seats ?? this.seats,
      lists: lists ?? this.lists.map((e0) => e0.copyWith()).toList(),
      states: states ?? this.states,
      matchingStates: matchingStates ?? this.matchingStates,
      differingStates:
          differingStates ?? this.differingStates.map((e0) => e0).toList(),
    );
  }
}
