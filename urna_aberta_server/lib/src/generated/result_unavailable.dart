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

/// TSE has not published this result, or the request names an office the
/// scope does not elect. The message is Portuguese; the app shows its own.
abstract class ResultUnavailable
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ResultUnavailable._({
    required this.message,
    required this.reason,
  });

  factory ResultUnavailable({
    required String message,
    required String reason,
  }) = _ResultUnavailableImpl;

  factory ResultUnavailable.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultUnavailable(
      message: jsonSerialization['message'] as String,
      reason: jsonSerialization['reason'] as String,
    );
  }

  String message;

  /// `notPublished`, `invalidRequest` or `tseUnavailable`.
  String reason;

  /// Returns a shallow copy of this [ResultUnavailable]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResultUnavailable copyWith({
    String? message,
    String? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultUnavailable',
      'message': message,
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultUnavailable',
      'message': message,
      'reason': reason,
    };
  }

  @override
  String toString() {
    return 'ResultUnavailable(message: $message, reason: $reason)';
  }
}

class _ResultUnavailableImpl extends ResultUnavailable {
  _ResultUnavailableImpl({
    required String message,
    required String reason,
  }) : super._(
         message: message,
         reason: reason,
       );

  /// Returns a shallow copy of this [ResultUnavailable]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResultUnavailable copyWith({
    String? message,
    String? reason,
  }) {
    return ResultUnavailable(
      message: message ?? this.message,
      reason: reason ?? this.reason,
    );
  }
}
