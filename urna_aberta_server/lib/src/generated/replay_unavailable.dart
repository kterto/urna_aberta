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

/// No archived final files are stored, so there is nothing to replay.
abstract class ReplayUnavailableException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ReplayUnavailableException._({required this.message});

  factory ReplayUnavailableException({required String message}) =
      _ReplayUnavailableExceptionImpl;

  factory ReplayUnavailableException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReplayUnavailableException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [ReplayUnavailableException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReplayUnavailableException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplayUnavailableException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplayUnavailableException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ReplayUnavailableException(message: $message)';
  }
}

class _ReplayUnavailableExceptionImpl extends ReplayUnavailableException {
  _ReplayUnavailableExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [ReplayUnavailableException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReplayUnavailableException copyWith({String? message}) {
    return ReplayUnavailableException(message: message ?? this.message);
  }
}
