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

/// A candidacy as listed in an EA20 file. Never given a color in the UI.
abstract class Candidate
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Candidate._({
    this.id,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.number,
    required this.ballotName,
    required this.party,
  });

  factory Candidate({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int number,
    required String ballotName,
    required String party,
  }) = _CandidateImpl;

  factory Candidate.fromJson(Map<String, dynamic> jsonSerialization) {
    return Candidate(
      id: jsonSerialization['id'] as int?,
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      number: jsonSerialization['number'] as int,
      ballotName: jsonSerialization['ballotName'] as String,
      party: jsonSerialization['party'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int electionCode;

  int officeCode;

  /// Scope of the file that lists it: `br` for President, a UF otherwise.
  String scopeCode;

  /// Ballot number.
  int number;

  /// Name on the ballot (`nmu`), as TSE writes it.
  String ballotName;

  /// Party abbreviation (`sg`).
  String party;

  /// Returns a shallow copy of this [Candidate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Candidate copyWith({
    int? id,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? number,
    String? ballotName,
    String? party,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Candidate',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'number': number,
      'ballotName': ballotName,
      'party': party,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Candidate',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'number': number,
      'ballotName': ballotName,
      'party': party,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CandidateImpl extends Candidate {
  _CandidateImpl({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int number,
    required String ballotName,
    required String party,
  }) : super._(
         id: id,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         number: number,
         ballotName: ballotName,
         party: party,
       );

  /// Returns a shallow copy of this [Candidate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Candidate copyWith({
    Object? id = _Undefined,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? number,
    String? ballotName,
    String? party,
  }) {
    return Candidate(
      id: id is int? ? id : this.id,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      number: number ?? this.number,
      ballotName: ballotName ?? this.ballotName,
      party: party ?? this.party,
    );
  }
}
