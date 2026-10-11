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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:urna_aberta_server/src/generated/future_calls.dart'
    as _iplz5ub8;
import 'package:urna_aberta_server/src/generated/reports/report_spec.dart'
    as _icv1nmb7;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../meu_local/meu_local_endpoint.dart' as _i9rogxyk;
import '../replay/tally_endpoint.dart' as _iphjbc6w;
import '../reports/relatorios_endpoint.dart' as _igbubms3;
import '../results/resultados_endpoint.dart' as _ignf5cub;
import '../secao/secao_endpoint.dart' as _i5402ufq;
import '../verify/verificar_endpoint.dart' as _i11vp49h;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'meuLocal': _i9rogxyk.MeuLocalEndpoint()
        ..initialize(
          server,
          'meuLocal',
          null,
        ),
      'tally': _iphjbc6w.TallyEndpoint()
        ..initialize(
          server,
          'tally',
          null,
        ),
      'relatorios': _igbubms3.RelatoriosEndpoint()
        ..initialize(
          server,
          'relatorios',
          null,
        ),
      'resultados': _ignf5cub.ResultadosEndpoint()
        ..initialize(
          server,
          'resultados',
          null,
        ),
      'secao': _i5402ufq.SecaoEndpoint()
        ..initialize(
          server,
          'secao',
          null,
        ),
      'verificar': _i11vp49h.VerificarEndpoint()
        ..initialize(
          server,
          'verificar',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['meuLocal'] = _is.EndpointConnector(
      name: 'meuLocal',
      endpoint: endpoints['meuLocal']!,
      methodConnectors: {
        'ler': _is.MethodConnector(
          name: 'ler',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['meuLocal'] as _i9rogxyk.MeuLocalEndpoint)
                  .ler(session),
        ),
        'salvar': _is.MethodConnector(
          name: 'salvar',
          params: {
            'uf': _is.ParameterDescription(
              name: 'uf',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'municipio': _is.ParameterDescription(
              name: 'municipio',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'zona': _is.ParameterDescription(
              name: 'zona',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'secao': _is.ParameterDescription(
              name: 'secao',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['meuLocal'] as _i9rogxyk.MeuLocalEndpoint).salvar(
                    session,
                    params['uf'],
                    params['municipio'],
                    params['zona'],
                    params['secao'],
                  ),
        ),
        'apagar': _is.MethodConnector(
          name: 'apagar',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['meuLocal'] as _i9rogxyk.MeuLocalEndpoint)
                  .apagar(session),
        ),
      },
    );
    connectors['tally'] = _is.EndpointConnector(
      name: 'tally',
      endpoint: endpoints['tally']!,
      methodConnectors: {
        'night': _is.MethodConnector(
          name: 'night',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tally'] as _iphjbc6w.TallyEndpoint).night(
                session,
              ),
        ),
        'frame': _is.MethodConnector(
          name: 'frame',
          params: {
            'at': _is.ParameterDescription(
              name: 'at',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tally'] as _iphjbc6w.TallyEndpoint).frame(
                session,
                params['at'],
              ),
        ),
        'timeline': _is.MethodConnector(
          name: 'timeline',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'stepSeconds': _is.ParameterDescription(
              name: 'stepSeconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tally'] as _iphjbc6w.TallyEndpoint).timeline(
                    session,
                    params['from'],
                    params['to'],
                    params['stepSeconds'],
                  ),
        ),
        'divergence': _is.MethodConnector(
          name: 'divergence',
          params: {
            'at': _is.ParameterDescription(
              name: 'at',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tally'] as _iphjbc6w.TallyEndpoint).divergence(
                    session,
                    params['at'],
                  ),
        ),
        'live': _is.MethodConnector(
          name: 'live',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tally'] as _iphjbc6w.TallyEndpoint).live(session),
        ),
      },
    );
    connectors['relatorios'] = _is.EndpointConnector(
      name: 'relatorios',
      endpoint: endpoints['relatorios']!,
      methodConnectors: {
        'orcar': _is.MethodConnector(
          name: 'orcar',
          params: {
            'spec': _is.ParameterDescription(
              name: 'spec',
              type: _is.getType<_icv1nmb7.ReportSpec>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['relatorios'] as _igbubms3.RelatoriosEndpoint)
                      .orcar(
                        session,
                        params['spec'],
                      ),
        ),
      },
    );
    connectors['resultados'] = _is.EndpointConnector(
      name: 'resultados',
      endpoint: endpoints['resultados']!,
      methodConnectors: {
        'eleicoes': _is.MethodConnector(
          name: 'eleicoes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['resultados'] as _ignf5cub.ResultadosEndpoint)
                      .eleicoes(session),
        ),
        'municipios': _is.MethodConnector(
          name: 'municipios',
          params: {
            'eleicao': _is.ParameterDescription(
              name: 'eleicao',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'uf': _is.ParameterDescription(
              name: 'uf',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['resultados'] as _ignf5cub.ResultadosEndpoint)
                      .municipios(
                        session,
                        params['eleicao'],
                        params['uf'],
                      ),
        ),
        'resultado': _is.MethodConnector(
          name: 'resultado',
          params: {
            'eleicao': _is.ParameterDescription(
              name: 'eleicao',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'cargo': _is.ParameterDescription(
              name: 'cargo',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'abrangencia': _is.ParameterDescription(
              name: 'abrangencia',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['resultados'] as _ignf5cub.ResultadosEndpoint)
                      .resultado(
                        session,
                        params['eleicao'],
                        params['cargo'],
                        params['abrangencia'],
                      ),
        ),
        'camara': _is.MethodConnector(
          name: 'camara',
          params: {
            'eleicao': _is.ParameterDescription(
              name: 'eleicao',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['resultados'] as _ignf5cub.ResultadosEndpoint)
                      .camara(
                        session,
                        params['eleicao'],
                      ),
        ),
      },
    );
    connectors['secao'] = _is.EndpointConnector(
      name: 'secao',
      endpoint: endpoints['secao']!,
      methodConnectors: {
        'municipios': _is.MethodConnector(
          name: 'municipios',
          params: {
            'uf': _is.ParameterDescription(
              name: 'uf',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['secao'] as _i5402ufq.SecaoEndpoint).municipios(
                    session,
                    params['uf'],
                  ),
        ),
        'zonas': _is.MethodConnector(
          name: 'zonas',
          params: {
            'uf': _is.ParameterDescription(
              name: 'uf',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'municipio': _is.ParameterDescription(
              name: 'municipio',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['secao'] as _i5402ufq.SecaoEndpoint).zonas(
                session,
                params['uf'],
                params['municipio'],
              ),
        ),
        'secoes': _is.MethodConnector(
          name: 'secoes',
          params: {
            'uf': _is.ParameterDescription(
              name: 'uf',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'municipio': _is.ParameterDescription(
              name: 'municipio',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'zona': _is.ParameterDescription(
              name: 'zona',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['secao'] as _i5402ufq.SecaoEndpoint).secoes(
                session,
                params['uf'],
                params['municipio'],
                params['zona'],
              ),
        ),
        'consultar': _is.MethodConnector(
          name: 'consultar',
          params: {
            'uf': _is.ParameterDescription(
              name: 'uf',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'municipio': _is.ParameterDescription(
              name: 'municipio',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'zona': _is.ParameterDescription(
              name: 'zona',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'secao': _is.ParameterDescription(
              name: 'secao',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['secao'] as _i5402ufq.SecaoEndpoint).consultar(
                    session,
                    params['uf'],
                    params['municipio'],
                    params['zona'],
                    params['secao'],
                  ),
        ),
      },
    );
    connectors['verificar'] = _is.EndpointConnector(
      name: 'verificar',
      endpoint: endpoints['verificar']!,
      methodConnectors: {
        'arquivos': _is.MethodConnector(
          name: 'arquivos',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['verificar'] as _i11vp49h.VerificarEndpoint)
                  .arquivos(session),
        ),
        'jws': _is.MethodConnector(
          name: 'jws',
          params: {
            'snapshotId': _is.ParameterDescription(
              name: 'snapshotId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verificar'] as _i11vp49h.VerificarEndpoint).jws(
                    session,
                    params['snapshotId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _iplz5ub8.FutureCalls();
  }
}
