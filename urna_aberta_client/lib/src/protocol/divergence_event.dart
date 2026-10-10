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

/// A period when the national file lagged the sum of the per-UF files.
abstract class DivergenceEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DivergenceEvent._({
    this.id,
    required this.origin,
    required this.electionCode,
    required this.startedAt,
    this.endedAt,
    required this.nationalPctAtStart,
    required this.maxGap,
  });

  factory DivergenceEvent({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required DateTime startedAt,
    DateTime? endedAt,
    required double nationalPctAtStart,
    required double maxGap,
  }) = _DivergenceEventImpl;

  factory DivergenceEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return DivergenceEvent(
      id: jsonSerialization['id'] as int?,
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      electionCode: jsonSerialization['electionCode'] as int,
      startedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      nationalPctAtStart: (jsonSerialization['nationalPctAtStart'] as num)
          .toDouble(),
      maxGap: (jsonSerialization['maxGap'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2ilnjuc.DataOrigin origin;

  int electionCode;

  DateTime startedAt;

  /// Null while the gap is still open.
  DateTime? endedAt;

  /// % sections totalized in the national file when the lag began.
  double nationalPctAtStart;

  /// Largest gap seen, in percentage points.
  double maxGap;

  /// Returns a shallow copy of this [DivergenceEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DivergenceEvent copyWith({
    int? id,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    DateTime? startedAt,
    DateTime? endedAt,
    double? nationalPctAtStart,
    double? maxGap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DivergenceEvent',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'startedAt': startedAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'nationalPctAtStart': nationalPctAtStart,
      'maxGap': maxGap,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DivergenceEvent',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'startedAt': startedAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'nationalPctAtStart': nationalPctAtStart,
      'maxGap': maxGap,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DivergenceEventImpl extends DivergenceEvent {
  _DivergenceEventImpl({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required DateTime startedAt,
    DateTime? endedAt,
    required double nationalPctAtStart,
    required double maxGap,
  }) : super._(
         id: id,
         origin: origin,
         electionCode: electionCode,
         startedAt: startedAt,
         endedAt: endedAt,
         nationalPctAtStart: nationalPctAtStart,
         maxGap: maxGap,
       );

  /// Returns a shallow copy of this [DivergenceEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DivergenceEvent copyWith({
    Object? id = _Undefined,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    DateTime? startedAt,
    Object? endedAt = _Undefined,
    double? nationalPctAtStart,
    double? maxGap,
  }) {
    return DivergenceEvent(
      id: id is int? ? id : this.id,
      origin: origin ?? this.origin,
      electionCode: electionCode ?? this.electionCode,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      nationalPctAtStart: nationalPctAtStart ?? this.nationalPctAtStart,
      maxGap: maxGap ?? this.maxGap,
    );
  }
}
