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

/// Where a stored figure came from. Anything but [live] is shown with the
/// simulation stamp.
enum DataOrigin implements _isc.SerializableModel {
  /// Fetched from TSE during the count.
  live,

  /// An archived TSE file replayed on a virtual clock.
  replay,

  /// Interpolated between real files; never an official figure.
  synthetic;

  static DataOrigin fromJson(String name) {
    switch (name) {
      case 'live':
        return DataOrigin.live;
      case 'replay':
        return DataOrigin.replay;
      case 'synthetic':
        return DataOrigin.synthetic;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DataOrigin"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
