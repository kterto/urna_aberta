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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:urna_aberta_client/src/protocol/divergence_event.dart'
    as _ivdor3em;
import 'package:urna_aberta_client/src/protocol/file_verification.dart'
    as _i4bcni6a;
import 'package:urna_aberta_client/src/protocol/greetings/greeting.dart'
    as _i0ezu2ai;
import 'package:urna_aberta_client/src/protocol/live_status.dart' as _iz8cte89;
import 'package:urna_aberta_client/src/protocol/municipio_ref.dart'
    as _iawxlp65;
import 'package:urna_aberta_client/src/protocol/replay_night.dart' as _i47uhwzn;
import 'package:urna_aberta_client/src/protocol/section_report.dart'
    as _it6gukgl;
import 'package:urna_aberta_client/src/protocol/tally_frame.dart' as _iirfdrc4;
import 'package:urna_aberta_client/src/protocol/timeline_point.dart'
    as _ipzn9brv;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_i0ezu2ai.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i0ezu2ai.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// National file vs independent sum of states, on the replay clock.
///
/// The client owns the clock: it asks for the frame at its own virtual time,
/// so viewers never share play/pause state.
/// {@category Endpoint}
class EndpointTally extends _isc.EndpointRef {
  EndpointTally(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tally';

  _ida.Future<_i47uhwzn.ReplayNight> night() =>
      caller.callServerEndpoint<_i47uhwzn.ReplayNight>(
        'tally',
        'night',
        {},
      );

  _ida.Future<_iirfdrc4.TallyFrame> frame(DateTime at) =>
      caller.callServerEndpoint<_iirfdrc4.TallyFrame>(
        'tally',
        'frame',
        {'at': at},
      );

  /// At most [ReplayService.maxTimelinePoints] samples from [from] to [to].
  _ida.Future<List<_ipzn9brv.TimelinePoint>> timeline(
    DateTime from,
    DateTime to,
    int stepSeconds,
  ) => caller.callServerEndpoint<List<_ipzn9brv.TimelinePoint>>(
    'tally',
    'timeline',
    {
      'from': from,
      'to': to,
      'stepSeconds': stepSeconds,
    },
  );

  _ida.Future<List<_ivdor3em.DivergenceEvent>> divergence(DateTime at) =>
      caller.callServerEndpoint<List<_ivdor3em.DivergenceEvent>>(
        'tally',
        'divergence',
        {'at': at},
      );

  /// The presidential count TSE is publishing now (or the next one), from
  /// the files the live poll stored.
  _ida.Future<_iz8cte89.LiveStatus> live() =>
      caller.callServerEndpoint<_iz8cte89.LiveStatus>(
        'tally',
        'live',
        {},
      );
}

/// Minha seção: find a polling section and read its official files.
/// {@category Endpoint}
class EndpointSecao extends _isc.EndpointRef {
  EndpointSecao(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'secao';

  _ida.Future<List<_iawxlp65.MunicipioRef>> municipios(String uf) =>
      caller.callServerEndpoint<List<_iawxlp65.MunicipioRef>>(
        'secao',
        'municipios',
        {'uf': uf},
      );

  _ida.Future<List<int>> zonas(
    String uf,
    int municipio,
  ) => caller.callServerEndpoint<List<int>>(
    'secao',
    'zonas',
    {
      'uf': uf,
      'municipio': municipio,
    },
  );

  _ida.Future<List<int>> secoes(
    String uf,
    int municipio,
    int zona,
  ) => caller.callServerEndpoint<List<int>>(
    'secao',
    'secoes',
    {
      'uf': uf,
      'municipio': municipio,
      'zona': zona,
    },
  );

  _ida.Future<_it6gukgl.SectionReport> consultar(
    String uf,
    int municipio,
    int zona,
    int secao,
  ) => caller.callServerEndpoint<_it6gukgl.SectionReport>(
    'secao',
    'consultar',
    {
      'uf': uf,
      'municipio': municipio,
      'zona': zona,
      'secao': secao,
    },
  );
}

/// Verificar: how each stored TSE result file's signature checked out, and
/// the signed files themselves so the app can check them again on its own.
/// {@category Endpoint}
class EndpointVerificar extends _isc.EndpointRef {
  EndpointVerificar(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'verificar';

  /// The newest stored version of each result file: President (Brazil,
  /// then UFs and exterior), then Governor, then Senator.
  _ida.Future<List<_i4bcni6a.FileVerification>> arquivos() =>
      caller.callServerEndpoint<List<_i4bcni6a.FileVerification>>(
        'verificar',
        'arquivos',
        {},
      );

  /// The stored `.jws` of one file, exactly as TSE served it.
  _ida.Future<String> jws(int snapshotId) => caller.callServerEndpoint<String>(
    'verificar',
    'jws',
    {'snapshotId': snapshotId},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    greeting = EndpointGreeting(this);
    tally = EndpointTally(this);
    secao = EndpointSecao(this);
    verificar = EndpointVerificar(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointGreeting greeting;

  late final EndpointTally tally;

  late final EndpointSecao secao;

  late final EndpointVerificar verificar;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'greeting': greeting,
    'tally': tally,
    'secao': secao,
    'verificar': verificar,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
