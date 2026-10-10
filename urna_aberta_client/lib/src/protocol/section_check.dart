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
import 'section_file.dart' as _i4rww364;

/// One looked-up polling section, with the raw TSE files it was built from.
abstract class SectionCheck
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SectionCheck._({
    this.id,
    required this.pleito,
    required this.uf,
    required this.municipio,
    required this.zona,
    required this.secao,
    required this.auxStatus,
    required this.auxGeneratedAt,
    required this.fetchedAt,
    this.files,
  });

  factory SectionCheck({
    int? id,
    required int pleito,
    required String uf,
    required int municipio,
    required int zona,
    required int secao,
    required String auxStatus,
    required DateTime auxGeneratedAt,
    required DateTime fetchedAt,
    List<_i4rww364.SectionFile>? files,
  }) = _SectionCheckImpl;

  factory SectionCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return SectionCheck(
      id: jsonSerialization['id'] as int?,
      pleito: jsonSerialization['pleito'] as int,
      uf: jsonSerialization['uf'] as String,
      municipio: jsonSerialization['municipio'] as int,
      zona: jsonSerialization['zona'] as int,
      secao: jsonSerialization['secao'] as int,
      auxStatus: jsonSerialization['auxStatus'] as String,
      auxGeneratedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['auxGeneratedAt'],
      ),
      fetchedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['fetchedAt'],
      ),
      files: jsonSerialization['files'] == null
          ? null
          : _ihdok87d.Protocol().deserialize<List<_i4rww364.SectionFile>>(
              jsonSerialization['files'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int pleito;

  String uf;

  int municipio;

  int zona;

  int secao;

  /// EA18 section status (Totalizada, Recebida, Anulada…).
  String auxStatus;

  DateTime auxGeneratedAt;

  DateTime fetchedAt;

  List<_i4rww364.SectionFile>? files;

  /// Returns a shallow copy of this [SectionCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SectionCheck copyWith({
    int? id,
    int? pleito,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
    String? auxStatus,
    DateTime? auxGeneratedAt,
    DateTime? fetchedAt,
    List<_i4rww364.SectionFile>? files,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SectionCheck',
      if (id != null) 'id': id,
      'pleito': pleito,
      'uf': uf,
      'municipio': municipio,
      'zona': zona,
      'secao': secao,
      'auxStatus': auxStatus,
      'auxGeneratedAt': auxGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      if (files != null) 'files': files?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SectionCheck',
      if (id != null) 'id': id,
      'pleito': pleito,
      'uf': uf,
      'municipio': municipio,
      'zona': zona,
      'secao': secao,
      'auxStatus': auxStatus,
      'auxGeneratedAt': auxGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      if (files != null)
        'files': files?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectionCheckImpl extends SectionCheck {
  _SectionCheckImpl({
    int? id,
    required int pleito,
    required String uf,
    required int municipio,
    required int zona,
    required int secao,
    required String auxStatus,
    required DateTime auxGeneratedAt,
    required DateTime fetchedAt,
    List<_i4rww364.SectionFile>? files,
  }) : super._(
         id: id,
         pleito: pleito,
         uf: uf,
         municipio: municipio,
         zona: zona,
         secao: secao,
         auxStatus: auxStatus,
         auxGeneratedAt: auxGeneratedAt,
         fetchedAt: fetchedAt,
         files: files,
       );

  /// Returns a shallow copy of this [SectionCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SectionCheck copyWith({
    Object? id = _Undefined,
    int? pleito,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
    String? auxStatus,
    DateTime? auxGeneratedAt,
    DateTime? fetchedAt,
    Object? files = _Undefined,
  }) {
    return SectionCheck(
      id: id is int? ? id : this.id,
      pleito: pleito ?? this.pleito,
      uf: uf ?? this.uf,
      municipio: municipio ?? this.municipio,
      zona: zona ?? this.zona,
      secao: secao ?? this.secao,
      auxStatus: auxStatus ?? this.auxStatus,
      auxGeneratedAt: auxGeneratedAt ?? this.auxGeneratedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      files: files is List<_i4rww364.SectionFile>?
          ? files
          : this.files?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
