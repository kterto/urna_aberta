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

/// One candidate's votes in the national file and in the sum of states.
abstract class CandidateVotes
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CandidateVotes._({
    required this.candidateNumber,
    required this.national,
    required this.states,
  });

  factory CandidateVotes({
    required int candidateNumber,
    required int national,
    required int states,
  }) = _CandidateVotesImpl;

  factory CandidateVotes.fromJson(Map<String, dynamic> jsonSerialization) {
    return CandidateVotes(
      candidateNumber: jsonSerialization['candidateNumber'] as int,
      national: jsonSerialization['national'] as int,
      states: jsonSerialization['states'] as int,
    );
  }

  int candidateNumber;

  int national;

  int states;

  /// Returns a shallow copy of this [CandidateVotes]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CandidateVotes copyWith({
    int? candidateNumber,
    int? national,
    int? states,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CandidateVotes',
      'candidateNumber': candidateNumber,
      'national': national,
      'states': states,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CandidateVotes',
      'candidateNumber': candidateNumber,
      'national': national,
      'states': states,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CandidateVotesImpl extends CandidateVotes {
  _CandidateVotesImpl({
    required int candidateNumber,
    required int national,
    required int states,
  }) : super._(
         candidateNumber: candidateNumber,
         national: national,
         states: states,
       );

  /// Returns a shallow copy of this [CandidateVotes]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CandidateVotes copyWith({
    int? candidateNumber,
    int? national,
    int? states,
  }) {
    return CandidateVotes(
      candidateNumber: candidateNumber ?? this.candidateNumber,
      national: national ?? this.national,
      states: states ?? this.states,
    );
  }
}
