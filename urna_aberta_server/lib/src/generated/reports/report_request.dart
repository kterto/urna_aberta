/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:urna_aberta_server/src/generated/protocol.dart' as _iyugoj1j;
import '../reports/report_spec.dart' as _iqf2o9z7;
import '../reports/report_status.dart' as _i5iav6pq;

/// A report a signed-in viewer asked for: its spec, its progress through
/// the queue and, once ready, its files in private storage. Deleted with
/// the account.
abstract class ReportRequest
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ReportRequest._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.spec,
    required this.status,
    required this.filesDone,
    required this.filesTotal,
    this.errorReason,
    required this.createdAt,
    this.startedAt,
    this.finishedAt,
    this.sha256,
    this.publicToken,
  });

  factory ReportRequest({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required _iqf2o9z7.ReportSpec spec,
    required _i5iav6pq.ReportStatus status,
    required int filesDone,
    required int filesTotal,
    String? errorReason,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? sha256,
    String? publicToken,
  }) = _ReportRequestImpl;

  factory ReportRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportRequest(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      spec: _iyugoj1j.Protocol().deserialize<_iqf2o9z7.ReportSpec>(
        jsonSerialization['spec'],
      ),
      status: _i5iav6pq.ReportStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      filesDone: jsonSerialization['filesDone'] as int,
      filesTotal: jsonSerialization['filesTotal'] as int,
      errorReason: jsonSerialization['errorReason'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      sha256: jsonSerialization['sha256'] as String?,
      publicToken: jsonSerialization['publicToken'] as String?,
    );
  }

  static final t = ReportRequestTable();

  static const db = ReportRequestRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  _iqf2o9z7.ReportSpec spec;

  _i5iav6pq.ReportStatus status;

  /// TSE files read so far, of those the report needs.
  int filesDone;

  int filesTotal;

  /// Why it failed: `tseUnavailable`, `invalidRequest` or `internal`.
  String? errorReason;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? finishedAt;

  /// SHA-256 of the CSV (the report's data), printed on the PDF.
  String? sha256;

  /// Set while the owner publishes it: the report is then readable by
  /// anyone at `/r/<publicToken>`.
  String? publicToken;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReportRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportRequest copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    _iqf2o9z7.ReportSpec? spec,
    _i5iav6pq.ReportStatus? status,
    int? filesDone,
    int? filesTotal,
    String? errorReason,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? sha256,
    String? publicToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportRequest',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'spec': spec.toJson(),
      'status': status.toJson(),
      'filesDone': filesDone,
      'filesTotal': filesTotal,
      if (errorReason != null) 'errorReason': errorReason,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (sha256 != null) 'sha256': sha256,
      if (publicToken != null) 'publicToken': publicToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportRequest',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'spec': spec.toJsonForProtocol(),
      'status': status.toJson(),
      'filesDone': filesDone,
      'filesTotal': filesTotal,
      if (errorReason != null) 'errorReason': errorReason,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (sha256 != null) 'sha256': sha256,
      if (publicToken != null) 'publicToken': publicToken,
    };
  }

  static ReportRequestInclude include({_iacs.AuthUserInclude? authUser}) {
    return ReportRequestInclude._(authUser: authUser);
  }

  static ReportRequestIncludeList includeList({
    _is.WhereExpressionBuilder<ReportRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportRequestTable>? orderBy,
    _is.OrderByListBuilder<ReportRequestTable>? orderByList,
    ReportRequestInclude? include,
  }) {
    return ReportRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReportRequest.t),
      orderByList: orderByList?.call(ReportRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportRequestImpl extends ReportRequest {
  _ReportRequestImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required _iqf2o9z7.ReportSpec spec,
    required _i5iav6pq.ReportStatus status,
    required int filesDone,
    required int filesTotal,
    String? errorReason,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? sha256,
    String? publicToken,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         spec: spec,
         status: status,
         filesDone: filesDone,
         filesTotal: filesTotal,
         errorReason: errorReason,
         createdAt: createdAt,
         startedAt: startedAt,
         finishedAt: finishedAt,
         sha256: sha256,
         publicToken: publicToken,
       );

  /// Returns a shallow copy of this [ReportRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportRequest copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    _iqf2o9z7.ReportSpec? spec,
    _i5iav6pq.ReportStatus? status,
    int? filesDone,
    int? filesTotal,
    Object? errorReason = _Undefined,
    DateTime? createdAt,
    Object? startedAt = _Undefined,
    Object? finishedAt = _Undefined,
    Object? sha256 = _Undefined,
    Object? publicToken = _Undefined,
  }) {
    return ReportRequest(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      spec: spec ?? this.spec.copyWith(),
      status: status ?? this.status,
      filesDone: filesDone ?? this.filesDone,
      filesTotal: filesTotal ?? this.filesTotal,
      errorReason: errorReason is String? ? errorReason : this.errorReason,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
      sha256: sha256 is String? ? sha256 : this.sha256,
      publicToken: publicToken is String? ? publicToken : this.publicToken,
    );
  }
}

class ReportRequestUpdateTable extends _is.UpdateTable<ReportRequestTable> {
  ReportRequestUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<_iqf2o9z7.ReportSpec, _iqf2o9z7.ReportSpec> spec(
    _iqf2o9z7.ReportSpec value,
  ) => _is.ColumnValue(
    table.spec,
    value,
  );

  _is.ColumnValue<_i5iav6pq.ReportStatus, _i5iav6pq.ReportStatus> status(
    _i5iav6pq.ReportStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> filesDone(int value) => _is.ColumnValue(
    table.filesDone,
    value,
  );

  _is.ColumnValue<int, int> filesTotal(int value) => _is.ColumnValue(
    table.filesTotal,
    value,
  );

  _is.ColumnValue<String, String> errorReason(String? value) => _is.ColumnValue(
    table.errorReason,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime? value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );

  _is.ColumnValue<String, String> sha256(String? value) => _is.ColumnValue(
    table.sha256,
    value,
  );

  _is.ColumnValue<String, String> publicToken(String? value) => _is.ColumnValue(
    table.publicToken,
    value,
  );
}

class ReportRequestTable extends _is.Table<int?> {
  ReportRequestTable({super.tableRelation})
    : super(tableName: 'report_request') {
    updateTable = ReportRequestUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    spec = _is.ColumnSerializable<_iqf2o9z7.ReportSpec>(
      'spec',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    filesDone = _is.ColumnInt(
      'filesDone',
      this,
    );
    filesTotal = _is.ColumnInt(
      'filesTotal',
      this,
    );
    errorReason = _is.ColumnString(
      'errorReason',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
    sha256 = _is.ColumnString(
      'sha256',
      this,
    );
    publicToken = _is.ColumnString(
      'publicToken',
      this,
    );
  }

  late final ReportRequestUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnSerializable<_iqf2o9z7.ReportSpec> spec;

  late final _is.ColumnEnum<_i5iav6pq.ReportStatus> status;

  /// TSE files read so far, of those the report needs.
  late final _is.ColumnInt filesDone;

  late final _is.ColumnInt filesTotal;

  /// Why it failed: `tseUnavailable`, `invalidRequest` or `internal`.
  late final _is.ColumnString errorReason;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime finishedAt;

  /// SHA-256 of the CSV (the report's data), printed on the PDF.
  late final _is.ColumnString sha256;

  /// Set while the owner publishes it: the report is then readable by
  /// anyone at `/r/<publicToken>`.
  late final _is.ColumnString publicToken;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: ReportRequest.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    spec,
    status,
    filesDone,
    filesTotal,
    errorReason,
    createdAt,
    startedAt,
    finishedAt,
    sha256,
    publicToken,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class ReportRequestInclude extends _is.IncludeObject {
  ReportRequestInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => ReportRequest.t;
}

class ReportRequestIncludeList extends _is.IncludeList {
  ReportRequestIncludeList._({
    _is.WhereExpressionBuilder<ReportRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReportRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ReportRequest.t;
}

class ReportRequestRepository {
  const ReportRequestRepository._();

  final attachRow = const ReportRequestAttachRowRepository._();

  /// Returns a list of [ReportRequest]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ReportRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportRequestTable>? orderBy,
    _is.OrderByListBuilder<ReportRequestTable>? orderByList,
    _is.Transaction? transaction,
    ReportRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReportRequest>(
      where: where?.call(ReportRequest.t),
      orderBy: orderBy?.call(ReportRequest.t),
      orderByList: orderByList?.call(ReportRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReportRequest] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ReportRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<ReportRequestTable>? orderBy,
    _is.OrderByListBuilder<ReportRequestTable>? orderByList,
    _is.Transaction? transaction,
    ReportRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReportRequest>(
      where: where?.call(ReportRequest.t),
      orderBy: orderBy?.call(ReportRequest.t),
      orderByList: orderByList?.call(ReportRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReportRequest] by its [id] or null if no such row exists.
  Future<ReportRequest?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ReportRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReportRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReportRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [ReportRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportRequest>> insert(
    _is.DatabaseSession session,
    List<ReportRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReportRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReportRequest] and returns the inserted row.
  ///
  /// The returned [ReportRequest] will have its `id` field set.
  Future<ReportRequest> insertRow(
    _is.DatabaseSession session,
    ReportRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReportRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReportRequest]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ReportRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportRequest>> upsert(
    _is.DatabaseSession session,
    List<ReportRequest> rows, {
    required _is.ColumnSelections<ReportRequestTable> conflictColumns,
    _is.ColumnSelections<ReportRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<ReportRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReportRequest>(
      rows,
      conflictColumns: conflictColumns(ReportRequest.t),
      updateColumns: updateColumns?.call(ReportRequest.t),
      updateWhere: updateWhere?.call(ReportRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReportRequest] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ReportRequest] will have its `id` field set.
  Future<ReportRequest?> upsertRow(
    _is.DatabaseSession session,
    ReportRequest row, {
    required _is.ColumnSelections<ReportRequestTable> conflictColumns,
    _is.ColumnSelections<ReportRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<ReportRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReportRequest>(
      row,
      conflictColumns: conflictColumns(ReportRequest.t),
      updateColumns: updateColumns?.call(ReportRequest.t),
      updateWhere: updateWhere?.call(ReportRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReportRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportRequest>> update(
    _is.DatabaseSession session,
    List<ReportRequest> rows, {
    _is.ColumnSelections<ReportRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReportRequest>(
      rows,
      columns: columns?.call(ReportRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReportRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReportRequest> updateRow(
    _is.DatabaseSession session,
    ReportRequest row, {
    _is.ColumnSelections<ReportRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReportRequest>(
      row,
      columns: columns?.call(ReportRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReportRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReportRequest?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ReportRequestUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReportRequest>(
      id,
      columnValues: columnValues(ReportRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReportRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReportRequestUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReportRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportRequestTable>? orderBy,
    _is.OrderByListBuilder<ReportRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReportRequest>(
      columnValues: columnValues(ReportRequest.t.updateTable),
      where: where(ReportRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReportRequest.t),
      orderByList: orderByList?.call(ReportRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReportRequest]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportRequest>> delete(
    _is.DatabaseSession session,
    List<ReportRequest> rows, {
    _is.OrderByBuilder<ReportRequestTable>? orderBy,
    _is.OrderByListBuilder<ReportRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReportRequest>(
      rows,
      orderBy: orderBy?.call(ReportRequest.t),
      orderByList: orderByList?.call(ReportRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReportRequest].
  Future<ReportRequest> deleteRow(
    _is.DatabaseSession session,
    ReportRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReportRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReportRequestTable> where,
    _is.OrderByBuilder<ReportRequestTable>? orderBy,
    _is.OrderByListBuilder<ReportRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReportRequest>(
      where: where(ReportRequest.t),
      orderBy: orderBy?.call(ReportRequest.t),
      orderByList: orderByList?.call(ReportRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReportRequest>(
      where: where?.call(ReportRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReportRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReportRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReportRequest>(
      where: where(ReportRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ReportRequestAttachRowRepository {
  const ReportRequestAttachRowRepository._();

  /// Creates a relation between the given [ReportRequest] and [AuthUser]
  /// by setting the [ReportRequest]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    ReportRequest reportRequest,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (reportRequest.id == null) {
      throw ArgumentError.notNull('reportRequest.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $reportRequest = reportRequest.copyWith(authUserId: authUser.id);
    await session.db.updateRow<ReportRequest>(
      $reportRequest,
      columns: [ReportRequest.t.authUserId],
      transaction: transaction,
    );
  }
}
