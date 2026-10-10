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

/// A TSE file behind a section report.
abstract class SectionFileInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SectionFileInfo._({
    required this.kind,
    required this.name,
    required this.url,
    required this.sha256,
    required this.sizeBytes,
  });

  factory SectionFileInfo({
    required String kind,
    required String name,
    required String url,
    required String sha256,
    required int sizeBytes,
  }) = _SectionFileInfoImpl;

  factory SectionFileInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SectionFileInfo(
      kind: jsonSerialization['kind'] as String,
      name: jsonSerialization['name'] as String,
      url: jsonSerialization['url'] as String,
      sha256: jsonSerialization['sha256'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
    );
  }

  String kind;

  String name;

  String url;

  String sha256;

  int sizeBytes;

  /// Returns a shallow copy of this [SectionFileInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SectionFileInfo copyWith({
    String? kind,
    String? name,
    String? url,
    String? sha256,
    int? sizeBytes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SectionFileInfo',
      'kind': kind,
      'name': name,
      'url': url,
      'sha256': sha256,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SectionFileInfo',
      'kind': kind,
      'name': name,
      'url': url,
      'sha256': sha256,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SectionFileInfoImpl extends SectionFileInfo {
  _SectionFileInfoImpl({
    required String kind,
    required String name,
    required String url,
    required String sha256,
    required int sizeBytes,
  }) : super._(
         kind: kind,
         name: name,
         url: url,
         sha256: sha256,
         sizeBytes: sizeBytes,
       );

  /// Returns a shallow copy of this [SectionFileInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SectionFileInfo copyWith({
    String? kind,
    String? name,
    String? url,
    String? sha256,
    int? sizeBytes,
  }) {
    return SectionFileInfo(
      kind: kind ?? this.kind,
      name: name ?? this.name,
      url: url ?? this.url,
      sha256: sha256 ?? this.sha256,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}
