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

/// What a report would cost before it is queued.
abstract class ReportQuote
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReportQuote._({
    required this.files,
    required this.stored,
    required this.seconds,
    required this.limit,
    required this.tables,
    required this.sectionsWithoutFiles,
  });

  factory ReportQuote({
    required int files,
    required int stored,
    required int seconds,
    required int limit,
    required int tables,
    required int sectionsWithoutFiles,
  }) = _ReportQuoteImpl;

  factory ReportQuote.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportQuote(
      files: jsonSerialization['files'] as int,
      stored: jsonSerialization['stored'] as int,
      seconds: jsonSerialization['seconds'] as int,
      limit: jsonSerialization['limit'] as int,
      tables: jsonSerialization['tables'] as int,
      sectionsWithoutFiles: jsonSerialization['sectionsWithoutFiles'] as int,
    );
  }

  /// TSE files the report reads (a section counts its aux file, BU and
  /// signature file).
  int files;

  /// Of those, already stored: read without asking TSE.
  int stored;

  /// Estimated time to fetch the rest at the client's rate.
  int seconds;

  /// Most files one report may read.
  int limit;

  /// One per election × office × place, breakdown rows included.
  int tables;

  /// Sections TSE lists with no urna files yet: shown, never requested.
  int sectionsWithoutFiles;

  /// Returns a shallow copy of this [ReportQuote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportQuote copyWith({
    int? files,
    int? stored,
    int? seconds,
    int? limit,
    int? tables,
    int? sectionsWithoutFiles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportQuote',
      'files': files,
      'stored': stored,
      'seconds': seconds,
      'limit': limit,
      'tables': tables,
      'sectionsWithoutFiles': sectionsWithoutFiles,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportQuote',
      'files': files,
      'stored': stored,
      'seconds': seconds,
      'limit': limit,
      'tables': tables,
      'sectionsWithoutFiles': sectionsWithoutFiles,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ReportQuoteImpl extends ReportQuote {
  _ReportQuoteImpl({
    required int files,
    required int stored,
    required int seconds,
    required int limit,
    required int tables,
    required int sectionsWithoutFiles,
  }) : super._(
         files: files,
         stored: stored,
         seconds: seconds,
         limit: limit,
         tables: tables,
         sectionsWithoutFiles: sectionsWithoutFiles,
       );

  /// Returns a shallow copy of this [ReportQuote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportQuote copyWith({
    int? files,
    int? stored,
    int? seconds,
    int? limit,
    int? tables,
    int? sectionsWithoutFiles,
  }) {
    return ReportQuote(
      files: files ?? this.files,
      stored: stored ?? this.stored,
      seconds: seconds ?? this.seconds,
      limit: limit ?? this.limit,
      tables: tables ?? this.tables,
      sectionsWithoutFiles: sectionsWithoutFiles ?? this.sectionsWithoutFiles,
    );
  }
}
