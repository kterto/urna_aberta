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

/// A party, federation or coalition on the ballot for one office.
abstract class ListReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ListReport._({
    required this.number,
    required this.name,
    required this.kind,
    required this.parties,
    required this.votes,
    required this.legendVotes,
    this.tseSeats,
    this.ourSeats,
    this.partyQuotient,
  });

  factory ListReport({
    required String number,
    required String name,
    required String kind,
    required List<String> parties,
    required int votes,
    required int legendVotes,
    int? tseSeats,
    int? ourSeats,
    int? partyQuotient,
  }) = _ListReportImpl;

  factory ListReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListReport(
      number: jsonSerialization['number'] as String,
      name: jsonSerialization['name'] as String,
      kind: jsonSerialization['kind'] as String,
      parties: _ihdok87d.Protocol().deserialize<List<String>>(
        jsonSerialization['parties'],
      ),
      votes: jsonSerialization['votes'] as int,
      legendVotes: jsonSerialization['legendVotes'] as int,
      tseSeats: jsonSerialization['tseSeats'] as int?,
      ourSeats: jsonSerialization['ourSeats'] as int?,
      partyQuotient: jsonSerialization['partyQuotient'] as int?,
    );
  }

  String number;

  String name;

  /// `party`, `federation` or `coalition`.
  String kind;

  /// Party abbreviations, as TSE writes them.
  List<String> parties;

  /// Valid nominal plus legend votes.
  int votes;

  int legendVotes;

  /// Seats as TSE published them, and as Urna Aberta computed them.
  int? tseSeats;

  int? ourSeats;

  /// Quociente partidário.
  int? partyQuotient;

  /// Returns a shallow copy of this [ListReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ListReport copyWith({
    String? number,
    String? name,
    String? kind,
    List<String>? parties,
    int? votes,
    int? legendVotes,
    int? tseSeats,
    int? ourSeats,
    int? partyQuotient,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ListReport',
      'number': number,
      'name': name,
      'kind': kind,
      'parties': parties.toJson(),
      'votes': votes,
      'legendVotes': legendVotes,
      if (tseSeats != null) 'tseSeats': tseSeats,
      if (ourSeats != null) 'ourSeats': ourSeats,
      if (partyQuotient != null) 'partyQuotient': partyQuotient,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ListReport',
      'number': number,
      'name': name,
      'kind': kind,
      'parties': parties.toJson(),
      'votes': votes,
      'legendVotes': legendVotes,
      if (tseSeats != null) 'tseSeats': tseSeats,
      if (ourSeats != null) 'ourSeats': ourSeats,
      if (partyQuotient != null) 'partyQuotient': partyQuotient,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListReportImpl extends ListReport {
  _ListReportImpl({
    required String number,
    required String name,
    required String kind,
    required List<String> parties,
    required int votes,
    required int legendVotes,
    int? tseSeats,
    int? ourSeats,
    int? partyQuotient,
  }) : super._(
         number: number,
         name: name,
         kind: kind,
         parties: parties,
         votes: votes,
         legendVotes: legendVotes,
         tseSeats: tseSeats,
         ourSeats: ourSeats,
         partyQuotient: partyQuotient,
       );

  /// Returns a shallow copy of this [ListReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ListReport copyWith({
    String? number,
    String? name,
    String? kind,
    List<String>? parties,
    int? votes,
    int? legendVotes,
    Object? tseSeats = _Undefined,
    Object? ourSeats = _Undefined,
    Object? partyQuotient = _Undefined,
  }) {
    return ListReport(
      number: number ?? this.number,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      parties: parties ?? this.parties.map((e0) => e0).toList(),
      votes: votes ?? this.votes,
      legendVotes: legendVotes ?? this.legendVotes,
      tseSeats: tseSeats is int? ? tseSeats : this.tseSeats,
      ourSeats: ourSeats is int? ? ourSeats : this.ourSeats,
      partyQuotient: partyQuotient is int? ? partyQuotient : this.partyQuotient,
    );
  }
}
