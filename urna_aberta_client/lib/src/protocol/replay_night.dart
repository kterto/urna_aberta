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

/// The replayable night: clock bounds and the simulated national freeze.
abstract class ReplayNight
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReplayNight._({
    required this.origin,
    required this.electionCode,
    required this.officeCode,
    required this.start,
    required this.end,
    required this.freezeStart,
    required this.freezeEnd,
    required this.finalsGeneratedAt,
  });

  factory ReplayNight({
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required DateTime start,
    required DateTime end,
    required DateTime freezeStart,
    required DateTime freezeEnd,
    required DateTime finalsGeneratedAt,
  }) = _ReplayNightImpl;

  factory ReplayNight.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReplayNight(
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      start: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
      end: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['end']),
      freezeStart: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['freezeStart'],
      ),
      freezeEnd: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['freezeEnd'],
      ),
      finalsGeneratedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['finalsGeneratedAt'],
      ),
    );
  }

  _i2ilnjuc.DataOrigin origin;

  int electionCode;

  int officeCode;

  DateTime start;

  /// From here on every figure equals the archived final files.
  DateTime end;

  DateTime freezeStart;

  DateTime freezeEnd;

  /// When TSE generated the newest archived final file.
  DateTime finalsGeneratedAt;

  /// Returns a shallow copy of this [ReplayNight]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReplayNight copyWith({
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    DateTime? start,
    DateTime? end,
    DateTime? freezeStart,
    DateTime? freezeEnd,
    DateTime? finalsGeneratedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplayNight',
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'start': start.toJson(),
      'end': end.toJson(),
      'freezeStart': freezeStart.toJson(),
      'freezeEnd': freezeEnd.toJson(),
      'finalsGeneratedAt': finalsGeneratedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplayNight',
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'start': start.toJson(),
      'end': end.toJson(),
      'freezeStart': freezeStart.toJson(),
      'freezeEnd': freezeEnd.toJson(),
      'finalsGeneratedAt': finalsGeneratedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReplayNightImpl extends ReplayNight {
  _ReplayNightImpl({
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required DateTime start,
    required DateTime end,
    required DateTime freezeStart,
    required DateTime freezeEnd,
    required DateTime finalsGeneratedAt,
  }) : super._(
         origin: origin,
         electionCode: electionCode,
         officeCode: officeCode,
         start: start,
         end: end,
         freezeStart: freezeStart,
         freezeEnd: freezeEnd,
         finalsGeneratedAt: finalsGeneratedAt,
       );

  /// Returns a shallow copy of this [ReplayNight]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReplayNight copyWith({
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    DateTime? start,
    DateTime? end,
    DateTime? freezeStart,
    DateTime? freezeEnd,
    DateTime? finalsGeneratedAt,
  }) {
    return ReplayNight(
      origin: origin ?? this.origin,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      start: start ?? this.start,
      end: end ?? this.end,
      freezeStart: freezeStart ?? this.freezeStart,
      freezeEnd: freezeEnd ?? this.freezeEnd,
      finalsGeneratedAt: finalsGeneratedAt ?? this.finalsGeneratedAt,
    );
  }
}
