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

/// The urna's own digital signature over its file list.
enum UrnaSignature implements _isc.SerializableModel {
  /// Signed by the urna, with a certificate from TSE's urna CA.
  valid,

  /// The signature, the list or the certificate does not check out.
  invalid,

  /// An algorithm Urna Aberta cannot check (older urna models).
  unsupported,

  /// No signature file was available.
  missing;

  static UrnaSignature fromJson(String name) {
    switch (name) {
      case 'valid':
        return UrnaSignature.valid;
      case 'invalid':
        return UrnaSignature.invalid;
      case 'unsupported':
        return UrnaSignature.unsupported;
      case 'missing':
        return UrnaSignature.missing;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "UrnaSignature"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
