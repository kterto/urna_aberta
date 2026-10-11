/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:urna_aberta_server/src/generated/divergence_event.dart'
    as _it5gv87d;
import 'package:urna_aberta_server/src/generated/election_summary.dart'
    as _i22tx4kq;
import 'package:urna_aberta_server/src/generated/file_verification.dart'
    as _i5a4izj1;
import 'package:urna_aberta_server/src/generated/municipio_ref.dart'
    as _i5vkvva1;
import 'package:urna_aberta_server/src/generated/reports/report_request.dart'
    as _iwe7yug1;
import 'package:urna_aberta_server/src/generated/timeline_point.dart'
    as _ir3q3hqp;
import 'bu_check.dart' as _ijbwnxcy;
import 'candidate.dart' as _irnb9urg;
import 'candidate_report.dart' as _i8xvblpk;
import 'candidate_tally.dart' as _ixvsuy9r;
import 'candidate_votes.dart' as _iurxdm15;
import 'cargo_result.dart' as _i77b8h6f;
import 'chamber_report.dart' as _igvtxk1g;
import 'data_origin.dart' as _i2ilnjuc;
import 'divergence_event.dart' as _i3f5hnmb;
import 'election_summary.dart' as _ipxcqqyf;
import 'file_not_stored.dart' as _i0m7v5qb;
import 'file_verification.dart' as _ikk6q8b9;
import 'list_report.dart' as _i49o1wen;
import 'live_status.dart' as _i5q61ine;
import 'meu_local/voter_place.dart' as _i1gec43k;
import 'municipio_ref.dart' as _i663s1cn;
import 'office_report.dart' as _ie6yu1i3;
import 'replay_night.dart' as _i1vi4thm;
import 'replay_unavailable.dart' as _i6npibdt;
import 'reports/report_breakdown.dart' as _imbon9w7;
import 'reports/report_place.dart' as _ivpf0ztf;
import 'reports/report_place_kind.dart' as _ii4sj20c;
import 'reports/report_quote.dart' as _incjw5yy;
import 'reports/report_refused.dart' as _ic38joef;
import 'reports/report_request.dart' as _ixixo8eu;
import 'reports/report_spec.dart' as _i8pq152b;
import 'reports/report_status.dart' as _ie09c4o9;
import 'result_file.dart' as _ihi5zekk;
import 'result_snapshot.dart' as _i4dv59av;
import 'result_unavailable.dart' as _ip5wxoe5;
import 'seat_check.dart' as _idhahere;
import 'section_check.dart' as _i1fk3nml;
import 'section_file.dart' as _i4rww364;
import 'section_file_info.dart' as _igdizl70;
import 'section_not_found.dart' as _iakf100n;
import 'section_report.dart' as _i64rlb21;
import 'section_unavailable.dart' as _i8oamffp;
import 'signature_status.dart' as _iomwgc6v;
import 'tally_frame.dart' as _iiyd8otz;
import 'timeline_point.dart' as _i4neo0h8;
import 'uf_progress.dart' as _icbf2ppq;
import 'urna_signature.dart' as _i343iyih;
import 'voto_result.dart' as _iuhijha9;
export 'bu_check.dart';
export 'candidate.dart';
export 'candidate_report.dart';
export 'candidate_tally.dart';
export 'candidate_votes.dart';
export 'cargo_result.dart';
export 'chamber_report.dart';
export 'data_origin.dart';
export 'divergence_event.dart';
export 'election_summary.dart';
export 'file_not_stored.dart';
export 'file_verification.dart';
export 'list_report.dart';
export 'live_status.dart';
export 'meu_local/voter_place.dart';
export 'municipio_ref.dart';
export 'office_report.dart';
export 'replay_night.dart';
export 'replay_unavailable.dart';
export 'reports/report_breakdown.dart';
export 'reports/report_place.dart';
export 'reports/report_place_kind.dart';
export 'reports/report_quote.dart';
export 'reports/report_refused.dart';
export 'reports/report_request.dart';
export 'reports/report_spec.dart';
export 'reports/report_status.dart';
export 'result_file.dart';
export 'result_snapshot.dart';
export 'result_unavailable.dart';
export 'seat_check.dart';
export 'section_check.dart';
export 'section_file.dart';
export 'section_file_info.dart';
export 'section_not_found.dart';
export 'section_report.dart';
export 'section_unavailable.dart';
export 'signature_status.dart';
export 'tally_frame.dart';
export 'timeline_point.dart';
export 'uf_progress.dart';
export 'urna_signature.dart';
export 'voto_result.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'candidate',
      dartName: 'Candidate',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'electionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'officeCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'scopeCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'number',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'ballotName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'party',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'candidate_identity_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'electionCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scopeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'number',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'candidate_tally',
      dartName: 'CandidateTally',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'snapshotId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'candidateNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'votes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'candidate_tally_fk_0',
          columns: ['snapshotId'],
          referenceTable: 'result_snapshot',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'candidate_tally_snapshot_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'snapshotId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'candidateNumber',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'divergence_event',
      dartName: 'DivergenceEvent',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DataOrigin',
        ),
        _isp.ColumnDefinition(
          name: 'electionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'nationalPctAtStart',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'maxGap',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'divergence_event_election_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'origin',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'electionCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'startedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'report_request',
      dartName: 'ReportRequest',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'spec',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:ReportSpec',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ReportStatus',
        ),
        _isp.ColumnDefinition(
          name: 'filesDone',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'filesTotal',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'errorReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'finishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'sha256',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'publicToken',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'report_request_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'report_request_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'report_request_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'report_request_public_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'publicToken',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'result_file',
      dartName: 'ResultFile',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'electionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'officeCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'scopeCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'tseGeneratedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'fetchedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'rawSha256',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'signature',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SignatureStatus',
        ),
        _isp.ColumnDefinition(
          name: 'jws',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'result_file_version_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'electionCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scopeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'rawSha256',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'result_file_latest_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'electionCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scopeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tseGeneratedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'result_snapshot',
      dartName: 'ResultSnapshot',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DataOrigin',
        ),
        _isp.ColumnDefinition(
          name: 'electionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'officeCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'scopeCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sectionsTotal',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sectionsTotalized',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'tseGeneratedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'fetchedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'rawSha256',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'signature',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:SignatureStatus?',
        ),
        _isp.ColumnDefinition(
          name: 'signatureKid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'jws',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'result_snapshot_version_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'origin',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'electionCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scopeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'rawSha256',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'result_snapshot_timeline_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'origin',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'electionCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scopeCode',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tseGeneratedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'section_check',
      dartName: 'SectionCheck',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'pleito',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'uf',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'municipio',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'zona',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'secao',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'auxStatus',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'auxGeneratedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'fetchedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'section_check_identity_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'pleito',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'uf',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'municipio',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'zona',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'secao',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'section_file',
      dartName: 'SectionFile',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'checkId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'url',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sha256',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'section_file_fk_0',
          columns: ['checkId'],
          referenceTable: 'section_check',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'section_file_check_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'checkId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'kind',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'voter_place',
      dartName: 'VoterPlace',
      schema: 'public',
      module: 'urna_aberta',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'uf',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'municipio',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'municipioNome',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'zona',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'secao',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'voter_place_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'voter_place_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ijbwnxcy.BuCheck) {
      return _ijbwnxcy.BuCheck.fromJson(data) as T;
    }
    if (t == _irnb9urg.Candidate) {
      return _irnb9urg.Candidate.fromJson(data) as T;
    }
    if (t == _i8xvblpk.CandidateReport) {
      return _i8xvblpk.CandidateReport.fromJson(data) as T;
    }
    if (t == _ixvsuy9r.CandidateTally) {
      return _ixvsuy9r.CandidateTally.fromJson(data) as T;
    }
    if (t == _iurxdm15.CandidateVotes) {
      return _iurxdm15.CandidateVotes.fromJson(data) as T;
    }
    if (t == _i77b8h6f.CargoResult) {
      return _i77b8h6f.CargoResult.fromJson(data) as T;
    }
    if (t == _igvtxk1g.ChamberReport) {
      return _igvtxk1g.ChamberReport.fromJson(data) as T;
    }
    if (t == _i2ilnjuc.DataOrigin) {
      return _i2ilnjuc.DataOrigin.fromJson(data) as T;
    }
    if (t == _i3f5hnmb.DivergenceEvent) {
      return _i3f5hnmb.DivergenceEvent.fromJson(data) as T;
    }
    if (t == _ipxcqqyf.ElectionSummary) {
      return _ipxcqqyf.ElectionSummary.fromJson(data) as T;
    }
    if (t == _i0m7v5qb.FileNotStoredException) {
      return _i0m7v5qb.FileNotStoredException.fromJson(data) as T;
    }
    if (t == _ikk6q8b9.FileVerification) {
      return _ikk6q8b9.FileVerification.fromJson(data) as T;
    }
    if (t == _i49o1wen.ListReport) {
      return _i49o1wen.ListReport.fromJson(data) as T;
    }
    if (t == _i5q61ine.LiveStatus) {
      return _i5q61ine.LiveStatus.fromJson(data) as T;
    }
    if (t == _i1gec43k.VoterPlace) {
      return _i1gec43k.VoterPlace.fromJson(data) as T;
    }
    if (t == _i663s1cn.MunicipioRef) {
      return _i663s1cn.MunicipioRef.fromJson(data) as T;
    }
    if (t == _ie6yu1i3.OfficeReport) {
      return _ie6yu1i3.OfficeReport.fromJson(data) as T;
    }
    if (t == _i1vi4thm.ReplayNight) {
      return _i1vi4thm.ReplayNight.fromJson(data) as T;
    }
    if (t == _i6npibdt.ReplayUnavailableException) {
      return _i6npibdt.ReplayUnavailableException.fromJson(data) as T;
    }
    if (t == _imbon9w7.ReportBreakdown) {
      return _imbon9w7.ReportBreakdown.fromJson(data) as T;
    }
    if (t == _ivpf0ztf.ReportPlace) {
      return _ivpf0ztf.ReportPlace.fromJson(data) as T;
    }
    if (t == _ii4sj20c.ReportPlaceKind) {
      return _ii4sj20c.ReportPlaceKind.fromJson(data) as T;
    }
    if (t == _incjw5yy.ReportQuote) {
      return _incjw5yy.ReportQuote.fromJson(data) as T;
    }
    if (t == _ic38joef.ReportRefused) {
      return _ic38joef.ReportRefused.fromJson(data) as T;
    }
    if (t == _ixixo8eu.ReportRequest) {
      return _ixixo8eu.ReportRequest.fromJson(data) as T;
    }
    if (t == _i8pq152b.ReportSpec) {
      return _i8pq152b.ReportSpec.fromJson(data) as T;
    }
    if (t == _ie09c4o9.ReportStatus) {
      return _ie09c4o9.ReportStatus.fromJson(data) as T;
    }
    if (t == _ihi5zekk.ResultFile) {
      return _ihi5zekk.ResultFile.fromJson(data) as T;
    }
    if (t == _i4dv59av.ResultSnapshot) {
      return _i4dv59av.ResultSnapshot.fromJson(data) as T;
    }
    if (t == _ip5wxoe5.ResultUnavailable) {
      return _ip5wxoe5.ResultUnavailable.fromJson(data) as T;
    }
    if (t == _idhahere.SeatCheck) {
      return _idhahere.SeatCheck.fromJson(data) as T;
    }
    if (t == _i1fk3nml.SectionCheck) {
      return _i1fk3nml.SectionCheck.fromJson(data) as T;
    }
    if (t == _i4rww364.SectionFile) {
      return _i4rww364.SectionFile.fromJson(data) as T;
    }
    if (t == _igdizl70.SectionFileInfo) {
      return _igdizl70.SectionFileInfo.fromJson(data) as T;
    }
    if (t == _iakf100n.SectionNotFoundException) {
      return _iakf100n.SectionNotFoundException.fromJson(data) as T;
    }
    if (t == _i64rlb21.SectionReport) {
      return _i64rlb21.SectionReport.fromJson(data) as T;
    }
    if (t == _i8oamffp.SectionUnavailableException) {
      return _i8oamffp.SectionUnavailableException.fromJson(data) as T;
    }
    if (t == _iomwgc6v.SignatureStatus) {
      return _iomwgc6v.SignatureStatus.fromJson(data) as T;
    }
    if (t == _iiyd8otz.TallyFrame) {
      return _iiyd8otz.TallyFrame.fromJson(data) as T;
    }
    if (t == _i4neo0h8.TimelinePoint) {
      return _i4neo0h8.TimelinePoint.fromJson(data) as T;
    }
    if (t == _icbf2ppq.UfProgress) {
      return _icbf2ppq.UfProgress.fromJson(data) as T;
    }
    if (t == _i343iyih.UrnaSignature) {
      return _i343iyih.UrnaSignature.fromJson(data) as T;
    }
    if (t == _iuhijha9.VotoResult) {
      return _iuhijha9.VotoResult.fromJson(data) as T;
    }
    if (t == _is.getType<_ijbwnxcy.BuCheck?>()) {
      return (data != null ? _ijbwnxcy.BuCheck.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irnb9urg.Candidate?>()) {
      return (data != null ? _irnb9urg.Candidate.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8xvblpk.CandidateReport?>()) {
      return (data != null ? _i8xvblpk.CandidateReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixvsuy9r.CandidateTally?>()) {
      return (data != null ? _ixvsuy9r.CandidateTally.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iurxdm15.CandidateVotes?>()) {
      return (data != null ? _iurxdm15.CandidateVotes.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i77b8h6f.CargoResult?>()) {
      return (data != null ? _i77b8h6f.CargoResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igvtxk1g.ChamberReport?>()) {
      return (data != null ? _igvtxk1g.ChamberReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2ilnjuc.DataOrigin?>()) {
      return (data != null ? _i2ilnjuc.DataOrigin.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3f5hnmb.DivergenceEvent?>()) {
      return (data != null ? _i3f5hnmb.DivergenceEvent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ipxcqqyf.ElectionSummary?>()) {
      return (data != null ? _ipxcqqyf.ElectionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0m7v5qb.FileNotStoredException?>()) {
      return (data != null
              ? _i0m7v5qb.FileNotStoredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ikk6q8b9.FileVerification?>()) {
      return (data != null ? _ikk6q8b9.FileVerification.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i49o1wen.ListReport?>()) {
      return (data != null ? _i49o1wen.ListReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5q61ine.LiveStatus?>()) {
      return (data != null ? _i5q61ine.LiveStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1gec43k.VoterPlace?>()) {
      return (data != null ? _i1gec43k.VoterPlace.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i663s1cn.MunicipioRef?>()) {
      return (data != null ? _i663s1cn.MunicipioRef.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie6yu1i3.OfficeReport?>()) {
      return (data != null ? _ie6yu1i3.OfficeReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1vi4thm.ReplayNight?>()) {
      return (data != null ? _i1vi4thm.ReplayNight.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6npibdt.ReplayUnavailableException?>()) {
      return (data != null
              ? _i6npibdt.ReplayUnavailableException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_imbon9w7.ReportBreakdown?>()) {
      return (data != null ? _imbon9w7.ReportBreakdown.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivpf0ztf.ReportPlace?>()) {
      return (data != null ? _ivpf0ztf.ReportPlace.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii4sj20c.ReportPlaceKind?>()) {
      return (data != null ? _ii4sj20c.ReportPlaceKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_incjw5yy.ReportQuote?>()) {
      return (data != null ? _incjw5yy.ReportQuote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ic38joef.ReportRefused?>()) {
      return (data != null ? _ic38joef.ReportRefused.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixixo8eu.ReportRequest?>()) {
      return (data != null ? _ixixo8eu.ReportRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8pq152b.ReportSpec?>()) {
      return (data != null ? _i8pq152b.ReportSpec.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie09c4o9.ReportStatus?>()) {
      return (data != null ? _ie09c4o9.ReportStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihi5zekk.ResultFile?>()) {
      return (data != null ? _ihi5zekk.ResultFile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4dv59av.ResultSnapshot?>()) {
      return (data != null ? _i4dv59av.ResultSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip5wxoe5.ResultUnavailable?>()) {
      return (data != null ? _ip5wxoe5.ResultUnavailable.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idhahere.SeatCheck?>()) {
      return (data != null ? _idhahere.SeatCheck.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1fk3nml.SectionCheck?>()) {
      return (data != null ? _i1fk3nml.SectionCheck.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4rww364.SectionFile?>()) {
      return (data != null ? _i4rww364.SectionFile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igdizl70.SectionFileInfo?>()) {
      return (data != null ? _igdizl70.SectionFileInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iakf100n.SectionNotFoundException?>()) {
      return (data != null
              ? _iakf100n.SectionNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i64rlb21.SectionReport?>()) {
      return (data != null ? _i64rlb21.SectionReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8oamffp.SectionUnavailableException?>()) {
      return (data != null
              ? _i8oamffp.SectionUnavailableException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iomwgc6v.SignatureStatus?>()) {
      return (data != null ? _iomwgc6v.SignatureStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iiyd8otz.TallyFrame?>()) {
      return (data != null ? _iiyd8otz.TallyFrame.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4neo0h8.TimelinePoint?>()) {
      return (data != null ? _i4neo0h8.TimelinePoint.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icbf2ppq.UfProgress?>()) {
      return (data != null ? _icbf2ppq.UfProgress.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i343iyih.UrnaSignature?>()) {
      return (data != null ? _i343iyih.UrnaSignature.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iuhijha9.VotoResult?>()) {
      return (data != null ? _iuhijha9.VotoResult.fromJson(data) : null) as T;
    }
    if (t == List<_iuhijha9.VotoResult>) {
      return (data as List)
              .map((e) => deserialize<_iuhijha9.VotoResult>(e))
              .toList()
          as T;
    }
    if (t == List<_i49o1wen.ListReport>) {
      return (data as List)
              .map((e) => deserialize<_i49o1wen.ListReport>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i4neo0h8.TimelinePoint>) {
      return (data as List)
              .map((e) => deserialize<_i4neo0h8.TimelinePoint>(e))
              .toList()
          as T;
    }
    if (t == List<_i3f5hnmb.DivergenceEvent>) {
      return (data as List)
              .map((e) => deserialize<_i3f5hnmb.DivergenceEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i8xvblpk.CandidateReport>) {
      return (data as List)
              .map((e) => deserialize<_i8xvblpk.CandidateReport>(e))
              .toList()
          as T;
    }
    if (t == List<_ivpf0ztf.ReportPlace>) {
      return (data as List)
              .map((e) => deserialize<_ivpf0ztf.ReportPlace>(e))
              .toList()
          as T;
    }
    if (t == List<_ixvsuy9r.CandidateTally>) {
      return (data as List)
              .map((e) => deserialize<_ixvsuy9r.CandidateTally>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ixvsuy9r.CandidateTally>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ixvsuy9r.CandidateTally>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i4rww364.SectionFile>) {
      return (data as List)
              .map((e) => deserialize<_i4rww364.SectionFile>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i4rww364.SectionFile>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i4rww364.SectionFile>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i77b8h6f.CargoResult>) {
      return (data as List)
              .map((e) => deserialize<_i77b8h6f.CargoResult>(e))
              .toList()
          as T;
    }
    if (t == List<_igdizl70.SectionFileInfo>) {
      return (data as List)
              .map((e) => deserialize<_igdizl70.SectionFileInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iurxdm15.CandidateVotes>) {
      return (data as List)
              .map((e) => deserialize<_iurxdm15.CandidateVotes>(e))
              .toList()
          as T;
    }
    if (t == List<_icbf2ppq.UfProgress>) {
      return (data as List)
              .map((e) => deserialize<_icbf2ppq.UfProgress>(e))
              .toList()
          as T;
    }
    if (t == List<_ir3q3hqp.TimelinePoint>) {
      return (data as List)
              .map((e) => deserialize<_ir3q3hqp.TimelinePoint>(e))
              .toList()
          as T;
    }
    if (t == List<_it5gv87d.DivergenceEvent>) {
      return (data as List)
              .map((e) => deserialize<_it5gv87d.DivergenceEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_iwe7yug1.ReportRequest>) {
      return (data as List)
              .map((e) => deserialize<_iwe7yug1.ReportRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i22tx4kq.ElectionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i22tx4kq.ElectionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i5vkvva1.MunicipioRef>) {
      return (data as List)
              .map((e) => deserialize<_i5vkvva1.MunicipioRef>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i5a4izj1.FileVerification>) {
      return (data as List)
              .map((e) => deserialize<_i5a4izj1.FileVerification>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ijbwnxcy.BuCheck => 'BuCheck',
      _irnb9urg.Candidate => 'Candidate',
      _i8xvblpk.CandidateReport => 'CandidateReport',
      _ixvsuy9r.CandidateTally => 'CandidateTally',
      _iurxdm15.CandidateVotes => 'CandidateVotes',
      _i77b8h6f.CargoResult => 'CargoResult',
      _igvtxk1g.ChamberReport => 'ChamberReport',
      _i2ilnjuc.DataOrigin => 'DataOrigin',
      _i3f5hnmb.DivergenceEvent => 'DivergenceEvent',
      _ipxcqqyf.ElectionSummary => 'ElectionSummary',
      _i0m7v5qb.FileNotStoredException => 'FileNotStoredException',
      _ikk6q8b9.FileVerification => 'FileVerification',
      _i49o1wen.ListReport => 'ListReport',
      _i5q61ine.LiveStatus => 'LiveStatus',
      _i1gec43k.VoterPlace => 'VoterPlace',
      _i663s1cn.MunicipioRef => 'MunicipioRef',
      _ie6yu1i3.OfficeReport => 'OfficeReport',
      _i1vi4thm.ReplayNight => 'ReplayNight',
      _i6npibdt.ReplayUnavailableException => 'ReplayUnavailableException',
      _imbon9w7.ReportBreakdown => 'ReportBreakdown',
      _ivpf0ztf.ReportPlace => 'ReportPlace',
      _ii4sj20c.ReportPlaceKind => 'ReportPlaceKind',
      _incjw5yy.ReportQuote => 'ReportQuote',
      _ic38joef.ReportRefused => 'ReportRefused',
      _ixixo8eu.ReportRequest => 'ReportRequest',
      _i8pq152b.ReportSpec => 'ReportSpec',
      _ie09c4o9.ReportStatus => 'ReportStatus',
      _ihi5zekk.ResultFile => 'ResultFile',
      _i4dv59av.ResultSnapshot => 'ResultSnapshot',
      _ip5wxoe5.ResultUnavailable => 'ResultUnavailable',
      _idhahere.SeatCheck => 'SeatCheck',
      _i1fk3nml.SectionCheck => 'SectionCheck',
      _i4rww364.SectionFile => 'SectionFile',
      _igdizl70.SectionFileInfo => 'SectionFileInfo',
      _iakf100n.SectionNotFoundException => 'SectionNotFoundException',
      _i64rlb21.SectionReport => 'SectionReport',
      _i8oamffp.SectionUnavailableException => 'SectionUnavailableException',
      _iomwgc6v.SignatureStatus => 'SignatureStatus',
      _iiyd8otz.TallyFrame => 'TallyFrame',
      _i4neo0h8.TimelinePoint => 'TimelinePoint',
      _icbf2ppq.UfProgress => 'UfProgress',
      _i343iyih.UrnaSignature => 'UrnaSignature',
      _iuhijha9.VotoResult => 'VotoResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('urna_aberta.', '');
    }

    switch (data) {
      case _ijbwnxcy.BuCheck():
        return 'BuCheck';
      case _irnb9urg.Candidate():
        return 'Candidate';
      case _i8xvblpk.CandidateReport():
        return 'CandidateReport';
      case _ixvsuy9r.CandidateTally():
        return 'CandidateTally';
      case _iurxdm15.CandidateVotes():
        return 'CandidateVotes';
      case _i77b8h6f.CargoResult():
        return 'CargoResult';
      case _igvtxk1g.ChamberReport():
        return 'ChamberReport';
      case _i2ilnjuc.DataOrigin():
        return 'DataOrigin';
      case _i3f5hnmb.DivergenceEvent():
        return 'DivergenceEvent';
      case _ipxcqqyf.ElectionSummary():
        return 'ElectionSummary';
      case _i0m7v5qb.FileNotStoredException():
        return 'FileNotStoredException';
      case _ikk6q8b9.FileVerification():
        return 'FileVerification';
      case _i49o1wen.ListReport():
        return 'ListReport';
      case _i5q61ine.LiveStatus():
        return 'LiveStatus';
      case _i1gec43k.VoterPlace():
        return 'VoterPlace';
      case _i663s1cn.MunicipioRef():
        return 'MunicipioRef';
      case _ie6yu1i3.OfficeReport():
        return 'OfficeReport';
      case _i1vi4thm.ReplayNight():
        return 'ReplayNight';
      case _i6npibdt.ReplayUnavailableException():
        return 'ReplayUnavailableException';
      case _imbon9w7.ReportBreakdown():
        return 'ReportBreakdown';
      case _ivpf0ztf.ReportPlace():
        return 'ReportPlace';
      case _ii4sj20c.ReportPlaceKind():
        return 'ReportPlaceKind';
      case _incjw5yy.ReportQuote():
        return 'ReportQuote';
      case _ic38joef.ReportRefused():
        return 'ReportRefused';
      case _ixixo8eu.ReportRequest():
        return 'ReportRequest';
      case _i8pq152b.ReportSpec():
        return 'ReportSpec';
      case _ie09c4o9.ReportStatus():
        return 'ReportStatus';
      case _ihi5zekk.ResultFile():
        return 'ResultFile';
      case _i4dv59av.ResultSnapshot():
        return 'ResultSnapshot';
      case _ip5wxoe5.ResultUnavailable():
        return 'ResultUnavailable';
      case _idhahere.SeatCheck():
        return 'SeatCheck';
      case _i1fk3nml.SectionCheck():
        return 'SectionCheck';
      case _i4rww364.SectionFile():
        return 'SectionFile';
      case _igdizl70.SectionFileInfo():
        return 'SectionFileInfo';
      case _iakf100n.SectionNotFoundException():
        return 'SectionNotFoundException';
      case _i64rlb21.SectionReport():
        return 'SectionReport';
      case _i8oamffp.SectionUnavailableException():
        return 'SectionUnavailableException';
      case _iomwgc6v.SignatureStatus():
        return 'SignatureStatus';
      case _iiyd8otz.TallyFrame():
        return 'TallyFrame';
      case _i4neo0h8.TimelinePoint():
        return 'TimelinePoint';
      case _icbf2ppq.UfProgress():
        return 'UfProgress';
      case _i343iyih.UrnaSignature():
        return 'UrnaSignature';
      case _iuhijha9.VotoResult():
        return 'VotoResult';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BuCheck') {
      return deserialize<_ijbwnxcy.BuCheck>(data['data']);
    }
    if (dataClassName == 'Candidate') {
      return deserialize<_irnb9urg.Candidate>(data['data']);
    }
    if (dataClassName == 'CandidateReport') {
      return deserialize<_i8xvblpk.CandidateReport>(data['data']);
    }
    if (dataClassName == 'CandidateTally') {
      return deserialize<_ixvsuy9r.CandidateTally>(data['data']);
    }
    if (dataClassName == 'CandidateVotes') {
      return deserialize<_iurxdm15.CandidateVotes>(data['data']);
    }
    if (dataClassName == 'CargoResult') {
      return deserialize<_i77b8h6f.CargoResult>(data['data']);
    }
    if (dataClassName == 'ChamberReport') {
      return deserialize<_igvtxk1g.ChamberReport>(data['data']);
    }
    if (dataClassName == 'DataOrigin') {
      return deserialize<_i2ilnjuc.DataOrigin>(data['data']);
    }
    if (dataClassName == 'DivergenceEvent') {
      return deserialize<_i3f5hnmb.DivergenceEvent>(data['data']);
    }
    if (dataClassName == 'ElectionSummary') {
      return deserialize<_ipxcqqyf.ElectionSummary>(data['data']);
    }
    if (dataClassName == 'FileNotStoredException') {
      return deserialize<_i0m7v5qb.FileNotStoredException>(data['data']);
    }
    if (dataClassName == 'FileVerification') {
      return deserialize<_ikk6q8b9.FileVerification>(data['data']);
    }
    if (dataClassName == 'ListReport') {
      return deserialize<_i49o1wen.ListReport>(data['data']);
    }
    if (dataClassName == 'LiveStatus') {
      return deserialize<_i5q61ine.LiveStatus>(data['data']);
    }
    if (dataClassName == 'VoterPlace') {
      return deserialize<_i1gec43k.VoterPlace>(data['data']);
    }
    if (dataClassName == 'MunicipioRef') {
      return deserialize<_i663s1cn.MunicipioRef>(data['data']);
    }
    if (dataClassName == 'OfficeReport') {
      return deserialize<_ie6yu1i3.OfficeReport>(data['data']);
    }
    if (dataClassName == 'ReplayNight') {
      return deserialize<_i1vi4thm.ReplayNight>(data['data']);
    }
    if (dataClassName == 'ReplayUnavailableException') {
      return deserialize<_i6npibdt.ReplayUnavailableException>(data['data']);
    }
    if (dataClassName == 'ReportBreakdown') {
      return deserialize<_imbon9w7.ReportBreakdown>(data['data']);
    }
    if (dataClassName == 'ReportPlace') {
      return deserialize<_ivpf0ztf.ReportPlace>(data['data']);
    }
    if (dataClassName == 'ReportPlaceKind') {
      return deserialize<_ii4sj20c.ReportPlaceKind>(data['data']);
    }
    if (dataClassName == 'ReportQuote') {
      return deserialize<_incjw5yy.ReportQuote>(data['data']);
    }
    if (dataClassName == 'ReportRefused') {
      return deserialize<_ic38joef.ReportRefused>(data['data']);
    }
    if (dataClassName == 'ReportRequest') {
      return deserialize<_ixixo8eu.ReportRequest>(data['data']);
    }
    if (dataClassName == 'ReportSpec') {
      return deserialize<_i8pq152b.ReportSpec>(data['data']);
    }
    if (dataClassName == 'ReportStatus') {
      return deserialize<_ie09c4o9.ReportStatus>(data['data']);
    }
    if (dataClassName == 'ResultFile') {
      return deserialize<_ihi5zekk.ResultFile>(data['data']);
    }
    if (dataClassName == 'ResultSnapshot') {
      return deserialize<_i4dv59av.ResultSnapshot>(data['data']);
    }
    if (dataClassName == 'ResultUnavailable') {
      return deserialize<_ip5wxoe5.ResultUnavailable>(data['data']);
    }
    if (dataClassName == 'SeatCheck') {
      return deserialize<_idhahere.SeatCheck>(data['data']);
    }
    if (dataClassName == 'SectionCheck') {
      return deserialize<_i1fk3nml.SectionCheck>(data['data']);
    }
    if (dataClassName == 'SectionFile') {
      return deserialize<_i4rww364.SectionFile>(data['data']);
    }
    if (dataClassName == 'SectionFileInfo') {
      return deserialize<_igdizl70.SectionFileInfo>(data['data']);
    }
    if (dataClassName == 'SectionNotFoundException') {
      return deserialize<_iakf100n.SectionNotFoundException>(data['data']);
    }
    if (dataClassName == 'SectionReport') {
      return deserialize<_i64rlb21.SectionReport>(data['data']);
    }
    if (dataClassName == 'SectionUnavailableException') {
      return deserialize<_i8oamffp.SectionUnavailableException>(data['data']);
    }
    if (dataClassName == 'SignatureStatus') {
      return deserialize<_iomwgc6v.SignatureStatus>(data['data']);
    }
    if (dataClassName == 'TallyFrame') {
      return deserialize<_iiyd8otz.TallyFrame>(data['data']);
    }
    if (dataClassName == 'TimelinePoint') {
      return deserialize<_i4neo0h8.TimelinePoint>(data['data']);
    }
    if (dataClassName == 'UfProgress') {
      return deserialize<_icbf2ppq.UfProgress>(data['data']);
    }
    if (dataClassName == 'UrnaSignature') {
      return deserialize<_i343iyih.UrnaSignature>(data['data']);
    }
    if (dataClassName == 'VotoResult') {
      return deserialize<_iuhijha9.VotoResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('urna_aberta', this);
    _iacs.Protocol().registerHostProtocol('urna_aberta', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _irnb9urg.Candidate:
        return _irnb9urg.Candidate.t;
      case _ixvsuy9r.CandidateTally:
        return _ixvsuy9r.CandidateTally.t;
      case _i3f5hnmb.DivergenceEvent:
        return _i3f5hnmb.DivergenceEvent.t;
      case _i1gec43k.VoterPlace:
        return _i1gec43k.VoterPlace.t;
      case _ixixo8eu.ReportRequest:
        return _ixixo8eu.ReportRequest.t;
      case _ihi5zekk.ResultFile:
        return _ihi5zekk.ResultFile.t;
      case _i4dv59av.ResultSnapshot:
        return _i4dv59av.ResultSnapshot.t;
      case _i1fk3nml.SectionCheck:
        return _i1fk3nml.SectionCheck.t;
      case _i4rww364.SectionFile:
        return _i4rww364.SectionFile.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'urna_aberta';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
