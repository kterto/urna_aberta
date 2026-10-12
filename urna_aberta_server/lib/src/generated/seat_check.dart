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

/// Urna Aberta's seat allocation against TSE's, for one race.
abstract class SeatCheck
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SeatCheck._({
    required this.quotient,
    this.tseQuotient,
    required this.matches,
    required this.listDifferences,
    required this.candidateDifferences,
    required this.unfilled,
  });

  factory SeatCheck({
    required int quotient,
    int? tseQuotient,
    required bool matches,
    required int listDifferences,
    required int candidateDifferences,
    required int unfilled,
  }) = _SeatCheckImpl;

  factory SeatCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return SeatCheck(
      quotient: jsonSerialization['quotient'] as int,
      tseQuotient: jsonSerialization['tseQuotient'] as int?,
      matches: _is.BoolJsonExtension.fromJson(jsonSerialization['matches']),
      listDifferences: jsonSerialization['listDifferences'] as int,
      candidateDifferences: jsonSerialization['candidateDifferences'] as int,
      unfilled: jsonSerialization['unfilled'] as int,
    );
  }

  int quotient;

  int? tseQuotient;

  bool matches;

  /// Lists and candidates whose outcome differs from TSE's.
  int listDifferences;

  int candidateDifferences;

  /// Seats no candidate could take.
  int unfilled;

  /// Returns a shallow copy of this [SeatCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SeatCheck copyWith({
    int? quotient,
    int? tseQuotient,
    bool? matches,
    int? listDifferences,
    int? candidateDifferences,
    int? unfilled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SeatCheck',
      'quotient': quotient,
      if (tseQuotient != null) 'tseQuotient': tseQuotient,
      'matches': matches,
      'listDifferences': listDifferences,
      'candidateDifferences': candidateDifferences,
      'unfilled': unfilled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SeatCheck',
      'quotient': quotient,
      if (tseQuotient != null) 'tseQuotient': tseQuotient,
      'matches': matches,
      'listDifferences': listDifferences,
      'candidateDifferences': candidateDifferences,
      'unfilled': unfilled,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeatCheckImpl extends SeatCheck {
  _SeatCheckImpl({
    required int quotient,
    int? tseQuotient,
    required bool matches,
    required int listDifferences,
    required int candidateDifferences,
    required int unfilled,
  }) : super._(
         quotient: quotient,
         tseQuotient: tseQuotient,
         matches: matches,
         listDifferences: listDifferences,
         candidateDifferences: candidateDifferences,
         unfilled: unfilled,
       );

  /// Returns a shallow copy of this [SeatCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SeatCheck copyWith({
    int? quotient,
    Object? tseQuotient = _Undefined,
    bool? matches,
    int? listDifferences,
    int? candidateDifferences,
    int? unfilled,
  }) {
    return SeatCheck(
      quotient: quotient ?? this.quotient,
      tseQuotient: tseQuotient is int? ? tseQuotient : this.tseQuotient,
      matches: matches ?? this.matches,
      listDifferences: listDifferences ?? this.listDifferences,
      candidateDifferences: candidateDifferences ?? this.candidateDifferences,
      unfilled: unfilled ?? this.unfilled,
    );
  }
}
