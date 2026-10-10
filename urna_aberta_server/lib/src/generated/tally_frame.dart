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
import 'candidate_votes.dart' as _iurxdm15;
import 'data_origin.dart' as _i2ilnjuc;
import 'uf_progress.dart' as _icbf2ppq;

/// The national file and the independent sum of states at one moment.
abstract class TallyFrame
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TallyFrame._({
    required this.at,
    required this.origin,
    required this.nationalPct,
    required this.statesPct,
    required this.missingScopes,
    required this.candidates,
    required this.ufs,
  });

  factory TallyFrame({
    required DateTime at,
    required _i2ilnjuc.DataOrigin origin,
    required double nationalPct,
    required double statesPct,
    required List<String> missingScopes,
    required List<_iurxdm15.CandidateVotes> candidates,
    required List<_icbf2ppq.UfProgress> ufs,
  }) = _TallyFrameImpl;

  factory TallyFrame.fromJson(Map<String, dynamic> jsonSerialization) {
    return TallyFrame(
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      nationalPct: (jsonSerialization['nationalPct'] as num).toDouble(),
      statesPct: (jsonSerialization['statesPct'] as num).toDouble(),
      missingScopes: _iyugoj1j.Protocol().deserialize<List<String>>(
        jsonSerialization['missingScopes'],
      ),
      candidates: _iyugoj1j.Protocol()
          .deserialize<List<_iurxdm15.CandidateVotes>>(
            jsonSerialization['candidates'],
          ),
      ufs: _iyugoj1j.Protocol().deserialize<List<_icbf2ppq.UfProgress>>(
        jsonSerialization['ufs'],
      ),
    );
  }

  DateTime at;

  _i2ilnjuc.DataOrigin origin;

  /// % sections totalized in the national (`br`) file.
  double nationalPct;

  /// % sections totalized across the per-UF files.
  double statesPct;

  /// Expected scopes with no file yet; the sum never estimates them.
  List<String> missingScopes;

  List<_iurxdm15.CandidateVotes> candidates;

  List<_icbf2ppq.UfProgress> ufs;

  /// Returns a shallow copy of this [TallyFrame]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TallyFrame copyWith({
    DateTime? at,
    _i2ilnjuc.DataOrigin? origin,
    double? nationalPct,
    double? statesPct,
    List<String>? missingScopes,
    List<_iurxdm15.CandidateVotes>? candidates,
    List<_icbf2ppq.UfProgress>? ufs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TallyFrame',
      'at': at.toJson(),
      'origin': origin.toJson(),
      'nationalPct': nationalPct,
      'statesPct': statesPct,
      'missingScopes': missingScopes.toJson(),
      'candidates': candidates.toJson(valueToJson: (v) => v.toJson()),
      'ufs': ufs.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TallyFrame',
      'at': at.toJson(),
      'origin': origin.toJson(),
      'nationalPct': nationalPct,
      'statesPct': statesPct,
      'missingScopes': missingScopes.toJson(),
      'candidates': candidates.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'ufs': ufs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TallyFrameImpl extends TallyFrame {
  _TallyFrameImpl({
    required DateTime at,
    required _i2ilnjuc.DataOrigin origin,
    required double nationalPct,
    required double statesPct,
    required List<String> missingScopes,
    required List<_iurxdm15.CandidateVotes> candidates,
    required List<_icbf2ppq.UfProgress> ufs,
  }) : super._(
         at: at,
         origin: origin,
         nationalPct: nationalPct,
         statesPct: statesPct,
         missingScopes: missingScopes,
         candidates: candidates,
         ufs: ufs,
       );

  /// Returns a shallow copy of this [TallyFrame]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TallyFrame copyWith({
    DateTime? at,
    _i2ilnjuc.DataOrigin? origin,
    double? nationalPct,
    double? statesPct,
    List<String>? missingScopes,
    List<_iurxdm15.CandidateVotes>? candidates,
    List<_icbf2ppq.UfProgress>? ufs,
  }) {
    return TallyFrame(
      at: at ?? this.at,
      origin: origin ?? this.origin,
      nationalPct: nationalPct ?? this.nationalPct,
      statesPct: statesPct ?? this.statesPct,
      missingScopes:
          missingScopes ?? this.missingScopes.map((e0) => e0).toList(),
      candidates:
          candidates ?? this.candidates.map((e0) => e0.copyWith()).toList(),
      ufs: ufs ?? this.ufs.map((e0) => e0.copyWith()).toList(),
    );
  }
}
