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

/// One sample of the national-vs-states timeline.
abstract class TimelinePoint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TimelinePoint._({
    required this.at,
    required this.nationalPct,
    required this.statesPct,
  });

  factory TimelinePoint({
    required DateTime at,
    required double nationalPct,
    required double statesPct,
  }) = _TimelinePointImpl;

  factory TimelinePoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelinePoint(
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      nationalPct: (jsonSerialization['nationalPct'] as num).toDouble(),
      statesPct: (jsonSerialization['statesPct'] as num).toDouble(),
    );
  }

  DateTime at;

  double nationalPct;

  double statesPct;

  /// Returns a shallow copy of this [TimelinePoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TimelinePoint copyWith({
    DateTime? at,
    double? nationalPct,
    double? statesPct,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelinePoint',
      'at': at.toJson(),
      'nationalPct': nationalPct,
      'statesPct': statesPct,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelinePoint',
      'at': at.toJson(),
      'nationalPct': nationalPct,
      'statesPct': statesPct,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TimelinePointImpl extends TimelinePoint {
  _TimelinePointImpl({
    required DateTime at,
    required double nationalPct,
    required double statesPct,
  }) : super._(
         at: at,
         nationalPct: nationalPct,
         statesPct: statesPct,
       );

  /// Returns a shallow copy of this [TimelinePoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TimelinePoint copyWith({
    DateTime? at,
    double? nationalPct,
    double? statesPct,
  }) {
    return TimelinePoint(
      at: at ?? this.at,
      nationalPct: nationalPct ?? this.nationalPct,
      statesPct: statesPct ?? this.statesPct,
    );
  }
}
