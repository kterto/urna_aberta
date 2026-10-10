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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:urna_aberta_server/src/generated/protocol.dart' as _iyugoj1j;
import 'divergence_event.dart' as _i3f5hnmb;
import 'tally_frame.dart' as _iiyd8otz;
import 'timeline_point.dart' as _i4neo0h8;

/// The presidential count TSE is publishing now, or the next one.
abstract class LiveStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveStatus._({
    this.electionCode,
    this.round,
    this.opensAt,
    this.closesAt,
    required this.open,
    this.frame,
    required this.timeline,
    required this.divergence,
  });

  factory LiveStatus({
    int? electionCode,
    int? round,
    DateTime? opensAt,
    DateTime? closesAt,
    required bool open,
    _iiyd8otz.TallyFrame? frame,
    required List<_i4neo0h8.TimelinePoint> timeline,
    required List<_i3f5hnmb.DivergenceEvent> divergence,
  }) = _LiveStatusImpl;

  factory LiveStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveStatus(
      electionCode: jsonSerialization['electionCode'] as int?,
      round: jsonSerialization['round'] as int?,
      opensAt: jsonSerialization['opensAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['opensAt']),
      closesAt: jsonSerialization['closesAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['closesAt']),
      open: _is.BoolJsonExtension.fromJson(jsonSerialization['open']),
      frame: jsonSerialization['frame'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<_iiyd8otz.TallyFrame>(
              jsonSerialization['frame'],
            ),
      timeline: _iyugoj1j.Protocol().deserialize<List<_i4neo0h8.TimelinePoint>>(
        jsonSerialization['timeline'],
      ),
      divergence: _iyugoj1j.Protocol()
          .deserialize<List<_i3f5hnmb.DivergenceEvent>>(
            jsonSerialization['divergence'],
          ),
    );
  }

  /// Null when EA11 lists no presidential election.
  int? electionCode;

  int? round;

  /// Live window, UTC: from 17:00 Brasília on election day to 06:00 next day.
  DateTime? opensAt;

  DateTime? closesAt;

  bool open;

  /// The latest stored live files; null until the first one arrives.
  _iiyd8otz.TallyFrame? frame;

  /// One point per moment a stored file changed.
  List<_i4neo0h8.TimelinePoint> timeline;

  List<_i3f5hnmb.DivergenceEvent> divergence;

  /// Returns a shallow copy of this [LiveStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveStatus copyWith({
    int? electionCode,
    int? round,
    DateTime? opensAt,
    DateTime? closesAt,
    bool? open,
    _iiyd8otz.TallyFrame? frame,
    List<_i4neo0h8.TimelinePoint>? timeline,
    List<_i3f5hnmb.DivergenceEvent>? divergence,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveStatus',
      if (electionCode != null) 'electionCode': electionCode,
      if (round != null) 'round': round,
      if (opensAt != null) 'opensAt': opensAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      'open': open,
      if (frame != null) 'frame': frame?.toJson(),
      'timeline': timeline.toJson(valueToJson: (v) => v.toJson()),
      'divergence': divergence.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveStatus',
      if (electionCode != null) 'electionCode': electionCode,
      if (round != null) 'round': round,
      if (opensAt != null) 'opensAt': opensAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      'open': open,
      if (frame != null) 'frame': frame?.toJsonForProtocol(),
      'timeline': timeline.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'divergence': divergence.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveStatusImpl extends LiveStatus {
  _LiveStatusImpl({
    int? electionCode,
    int? round,
    DateTime? opensAt,
    DateTime? closesAt,
    required bool open,
    _iiyd8otz.TallyFrame? frame,
    required List<_i4neo0h8.TimelinePoint> timeline,
    required List<_i3f5hnmb.DivergenceEvent> divergence,
  }) : super._(
         electionCode: electionCode,
         round: round,
         opensAt: opensAt,
         closesAt: closesAt,
         open: open,
         frame: frame,
         timeline: timeline,
         divergence: divergence,
       );

  /// Returns a shallow copy of this [LiveStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveStatus copyWith({
    Object? electionCode = _Undefined,
    Object? round = _Undefined,
    Object? opensAt = _Undefined,
    Object? closesAt = _Undefined,
    bool? open,
    Object? frame = _Undefined,
    List<_i4neo0h8.TimelinePoint>? timeline,
    List<_i3f5hnmb.DivergenceEvent>? divergence,
  }) {
    return LiveStatus(
      electionCode: electionCode is int? ? electionCode : this.electionCode,
      round: round is int? ? round : this.round,
      opensAt: opensAt is DateTime? ? opensAt : this.opensAt,
      closesAt: closesAt is DateTime? ? closesAt : this.closesAt,
      open: open ?? this.open,
      frame: frame is _iiyd8otz.TallyFrame? ? frame : this.frame?.copyWith(),
      timeline: timeline ?? this.timeline.map((e0) => e0.copyWith()).toList(),
      divergence:
          divergence ?? this.divergence.map((e0) => e0.copyWith()).toList(),
    );
  }
}
