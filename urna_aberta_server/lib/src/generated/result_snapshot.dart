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
import 'package:urna_aberta_server/src/generated/protocol.dart' as _iyugoj1j;
import 'candidate_tally.dart' as _ixvsuy9r;
import 'data_origin.dart' as _i2ilnjuc;

/// One immutable version of a TSE EA20 result file.
abstract class ResultSnapshot
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ResultSnapshot._({
    this.id,
    required this.origin,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.sectionsTotal,
    required this.sectionsTotalized,
    required this.tseGeneratedAt,
    required this.fetchedAt,
    required this.rawSha256,
    this.signatureValid,
    this.tallies,
  });

  factory ResultSnapshot({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int sectionsTotal,
    required int sectionsTotalized,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    bool? signatureValid,
    List<_ixvsuy9r.CandidateTally>? tallies,
  }) = _ResultSnapshotImpl;

  factory ResultSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultSnapshot(
      id: jsonSerialization['id'] as int?,
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      sectionsTotal: jsonSerialization['sectionsTotal'] as int,
      sectionsTotalized: jsonSerialization['sectionsTotalized'] as int,
      tseGeneratedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['tseGeneratedAt'],
      ),
      fetchedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['fetchedAt'],
      ),
      rawSha256: jsonSerialization['rawSha256'] as String,
      signatureValid: jsonSerialization['signatureValid'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['signatureValid']),
      tallies: jsonSerialization['tallies'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<List<_ixvsuy9r.CandidateTally>>(
              jsonSerialization['tallies'],
            ),
    );
  }

  static final t = ResultSnapshotTable();

  static const db = ResultSnapshotRepository._();

  @override
  int? id;

  _i2ilnjuc.DataOrigin origin;

  /// TSE election code, e.g. 6257 (Federal, 1st round 2026).
  int electionCode;

  /// TSE office code: 1 President, 3 Governor, 5 Senator.
  int officeCode;

  /// Lowercase scope: `br`, a UF, or `zz` (exterior).
  String scopeCode;

  int sectionsTotal;

  int sectionsTotalized;

  /// When TSE generated the file (UTC).
  DateTime tseGeneratedAt;

  DateTime fetchedAt;

  /// SHA-256 of the raw file bytes, hex.
  String rawSha256;

  /// JWS check result; null until verified.
  bool? signatureValid;

  List<_ixvsuy9r.CandidateTally>? tallies;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ResultSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResultSnapshot copyWith({
    int? id,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? sectionsTotal,
    int? sectionsTotalized,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    bool? signatureValid,
    List<_ixvsuy9r.CandidateTally>? tallies,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultSnapshot',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      if (signatureValid != null) 'signatureValid': signatureValid,
      if (tallies != null)
        'tallies': tallies?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultSnapshot',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      if (signatureValid != null) 'signatureValid': signatureValid,
      if (tallies != null)
        'tallies': tallies?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ResultSnapshotInclude include({
    _ixvsuy9r.CandidateTallyIncludeList? tallies,
  }) {
    return ResultSnapshotInclude._(tallies: tallies);
  }

  static ResultSnapshotIncludeList includeList({
    _is.WhereExpressionBuilder<ResultSnapshotTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResultSnapshotTable>? orderBy,
    _is.OrderByListBuilder<ResultSnapshotTable>? orderByList,
    ResultSnapshotInclude? include,
  }) {
    return ResultSnapshotIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResultSnapshot.t),
      orderByList: orderByList?.call(ResultSnapshot.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResultSnapshotImpl extends ResultSnapshot {
  _ResultSnapshotImpl({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int sectionsTotal,
    required int sectionsTotalized,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    bool? signatureValid,
    List<_ixvsuy9r.CandidateTally>? tallies,
  }) : super._(
         id: id,
         origin: origin,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         sectionsTotal: sectionsTotal,
         sectionsTotalized: sectionsTotalized,
         tseGeneratedAt: tseGeneratedAt,
         fetchedAt: fetchedAt,
         rawSha256: rawSha256,
         signatureValid: signatureValid,
         tallies: tallies,
       );

  /// Returns a shallow copy of this [ResultSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResultSnapshot copyWith({
    Object? id = _Undefined,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? sectionsTotal,
    int? sectionsTotalized,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    Object? signatureValid = _Undefined,
    Object? tallies = _Undefined,
  }) {
    return ResultSnapshot(
      id: id is int? ? id : this.id,
      origin: origin ?? this.origin,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      sectionsTotal: sectionsTotal ?? this.sectionsTotal,
      sectionsTotalized: sectionsTotalized ?? this.sectionsTotalized,
      tseGeneratedAt: tseGeneratedAt ?? this.tseGeneratedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rawSha256: rawSha256 ?? this.rawSha256,
      signatureValid: signatureValid is bool?
          ? signatureValid
          : this.signatureValid,
      tallies: tallies is List<_ixvsuy9r.CandidateTally>?
          ? tallies
          : this.tallies?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ResultSnapshotUpdateTable extends _is.UpdateTable<ResultSnapshotTable> {
  ResultSnapshotUpdateTable(super.table);

  _is.ColumnValue<_i2ilnjuc.DataOrigin, _i2ilnjuc.DataOrigin> origin(
    _i2ilnjuc.DataOrigin value,
  ) => _is.ColumnValue(
    table.origin,
    value,
  );

  _is.ColumnValue<int, int> electionCode(int value) => _is.ColumnValue(
    table.electionCode,
    value,
  );

  _is.ColumnValue<int, int> officeCode(int value) => _is.ColumnValue(
    table.officeCode,
    value,
  );

  _is.ColumnValue<String, String> scopeCode(String value) => _is.ColumnValue(
    table.scopeCode,
    value,
  );

  _is.ColumnValue<int, int> sectionsTotal(int value) => _is.ColumnValue(
    table.sectionsTotal,
    value,
  );

  _is.ColumnValue<int, int> sectionsTotalized(int value) => _is.ColumnValue(
    table.sectionsTotalized,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> tseGeneratedAt(DateTime value) =>
      _is.ColumnValue(
        table.tseGeneratedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> fetchedAt(DateTime value) =>
      _is.ColumnValue(
        table.fetchedAt,
        value,
      );

  _is.ColumnValue<String, String> rawSha256(String value) => _is.ColumnValue(
    table.rawSha256,
    value,
  );

  _is.ColumnValue<bool, bool> signatureValid(bool? value) => _is.ColumnValue(
    table.signatureValid,
    value,
  );
}

class ResultSnapshotTable extends _is.Table<int?> {
  ResultSnapshotTable({super.tableRelation})
    : super(tableName: 'result_snapshot') {
    updateTable = ResultSnapshotUpdateTable(this);
    origin = _is.ColumnEnum(
      'origin',
      this,
      _is.EnumSerialization.byName,
    );
    electionCode = _is.ColumnInt(
      'electionCode',
      this,
    );
    officeCode = _is.ColumnInt(
      'officeCode',
      this,
    );
    scopeCode = _is.ColumnString(
      'scopeCode',
      this,
    );
    sectionsTotal = _is.ColumnInt(
      'sectionsTotal',
      this,
    );
    sectionsTotalized = _is.ColumnInt(
      'sectionsTotalized',
      this,
    );
    tseGeneratedAt = _is.ColumnDateTime(
      'tseGeneratedAt',
      this,
    );
    fetchedAt = _is.ColumnDateTime(
      'fetchedAt',
      this,
    );
    rawSha256 = _is.ColumnString(
      'rawSha256',
      this,
    );
    signatureValid = _is.ColumnBool(
      'signatureValid',
      this,
    );
  }

  late final ResultSnapshotUpdateTable updateTable;

  late final _is.ColumnEnum<_i2ilnjuc.DataOrigin> origin;

  /// TSE election code, e.g. 6257 (Federal, 1st round 2026).
  late final _is.ColumnInt electionCode;

  /// TSE office code: 1 President, 3 Governor, 5 Senator.
  late final _is.ColumnInt officeCode;

  /// Lowercase scope: `br`, a UF, or `zz` (exterior).
  late final _is.ColumnString scopeCode;

  late final _is.ColumnInt sectionsTotal;

  late final _is.ColumnInt sectionsTotalized;

  /// When TSE generated the file (UTC).
  late final _is.ColumnDateTime tseGeneratedAt;

  late final _is.ColumnDateTime fetchedAt;

  /// SHA-256 of the raw file bytes, hex.
  late final _is.ColumnString rawSha256;

  /// JWS check result; null until verified.
  late final _is.ColumnBool signatureValid;

  _ixvsuy9r.CandidateTallyTable? ___tallies;

  _is.ManyRelation<_ixvsuy9r.CandidateTallyTable>? _tallies;

  _ixvsuy9r.CandidateTallyTable get __tallies {
    if (___tallies != null) return ___tallies!;
    ___tallies = _is.createRelationTable(
      relationFieldName: '__tallies',
      field: ResultSnapshot.t.id,
      foreignField: _ixvsuy9r.CandidateTally.t.snapshotId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ixvsuy9r.CandidateTallyTable(tableRelation: foreignTableRelation),
    );
    return ___tallies!;
  }

  _is.ManyRelation<_ixvsuy9r.CandidateTallyTable> get tallies {
    if (_tallies != null) return _tallies!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'tallies',
      field: ResultSnapshot.t.id,
      foreignField: _ixvsuy9r.CandidateTally.t.snapshotId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ixvsuy9r.CandidateTallyTable(tableRelation: foreignTableRelation),
    );
    _tallies = _is.ManyRelation<_ixvsuy9r.CandidateTallyTable>(
      tableWithRelations: relationTable,
      table: _ixvsuy9r.CandidateTallyTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _tallies!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    origin,
    electionCode,
    officeCode,
    scopeCode,
    sectionsTotal,
    sectionsTotalized,
    tseGeneratedAt,
    fetchedAt,
    rawSha256,
    signatureValid,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'tallies') {
      return __tallies;
    }
    return null;
  }
}

class ResultSnapshotInclude extends _is.IncludeObject {
  ResultSnapshotInclude._({_ixvsuy9r.CandidateTallyIncludeList? tallies}) {
    _tallies = tallies;
  }

  _ixvsuy9r.CandidateTallyIncludeList? _tallies;

  @override
  Map<String, _is.Include?> get includes => {'tallies': _tallies};

  @override
  _is.Table<int?> get table => ResultSnapshot.t;
}

class ResultSnapshotIncludeList extends _is.IncludeList {
  ResultSnapshotIncludeList._({
    _is.WhereExpressionBuilder<ResultSnapshotTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ResultSnapshot.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ResultSnapshot.t;
}

class ResultSnapshotRepository {
  const ResultSnapshotRepository._();

  final attach = const ResultSnapshotAttachRepository._();

  final attachRow = const ResultSnapshotAttachRowRepository._();

  /// Returns a list of [ResultSnapshot]s matching the given query parameters.
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
  Future<List<ResultSnapshot>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResultSnapshotTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResultSnapshotTable>? orderBy,
    _is.OrderByListBuilder<ResultSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    ResultSnapshotInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ResultSnapshot>(
      where: where?.call(ResultSnapshot.t),
      orderBy: orderBy?.call(ResultSnapshot.t),
      orderByList: orderByList?.call(ResultSnapshot.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ResultSnapshot] matching the given query parameters.
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
  Future<ResultSnapshot?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResultSnapshotTable>? where,
    int? offset,
    _is.OrderByBuilder<ResultSnapshotTable>? orderBy,
    _is.OrderByListBuilder<ResultSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    ResultSnapshotInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ResultSnapshot>(
      where: where?.call(ResultSnapshot.t),
      orderBy: orderBy?.call(ResultSnapshot.t),
      orderByList: orderByList?.call(ResultSnapshot.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ResultSnapshot] by its [id] or null if no such row exists.
  Future<ResultSnapshot?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ResultSnapshotInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ResultSnapshot>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ResultSnapshot]s in the list and returns the inserted rows.
  ///
  /// The returned [ResultSnapshot]s will have their `id` fields set.
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
  Future<List<ResultSnapshot>> insert(
    _is.DatabaseSession session,
    List<ResultSnapshot> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ResultSnapshot>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ResultSnapshot] and returns the inserted row.
  ///
  /// The returned [ResultSnapshot] will have its `id` field set.
  Future<ResultSnapshot> insertRow(
    _is.DatabaseSession session,
    ResultSnapshot row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ResultSnapshot>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ResultSnapshot]s in the list and returns the resulting rows.
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
  /// The returned [ResultSnapshot]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResultSnapshot>> upsert(
    _is.DatabaseSession session,
    List<ResultSnapshot> rows, {
    required _is.ColumnSelections<ResultSnapshotTable> conflictColumns,
    _is.ColumnSelections<ResultSnapshotTable>? updateColumns,
    _is.WhereExpressionBuilder<ResultSnapshotTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ResultSnapshot>(
      rows,
      conflictColumns: conflictColumns(ResultSnapshot.t),
      updateColumns: updateColumns?.call(ResultSnapshot.t),
      updateWhere: updateWhere?.call(ResultSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ResultSnapshot] and returns the resulting row.
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
  /// The returned [ResultSnapshot] will have its `id` field set.
  Future<ResultSnapshot?> upsertRow(
    _is.DatabaseSession session,
    ResultSnapshot row, {
    required _is.ColumnSelections<ResultSnapshotTable> conflictColumns,
    _is.ColumnSelections<ResultSnapshotTable>? updateColumns,
    _is.WhereExpressionBuilder<ResultSnapshotTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ResultSnapshot>(
      row,
      conflictColumns: conflictColumns(ResultSnapshot.t),
      updateColumns: updateColumns?.call(ResultSnapshot.t),
      updateWhere: updateWhere?.call(ResultSnapshot.t),
      transaction: transaction,
    );
  }

  /// Updates all [ResultSnapshot]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResultSnapshot>> update(
    _is.DatabaseSession session,
    List<ResultSnapshot> rows, {
    _is.ColumnSelections<ResultSnapshotTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ResultSnapshot>(
      rows,
      columns: columns?.call(ResultSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ResultSnapshot]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ResultSnapshot> updateRow(
    _is.DatabaseSession session,
    ResultSnapshot row, {
    _is.ColumnSelections<ResultSnapshotTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ResultSnapshot>(
      row,
      columns: columns?.call(ResultSnapshot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ResultSnapshot] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ResultSnapshot?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ResultSnapshotUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ResultSnapshot>(
      id,
      columnValues: columnValues(ResultSnapshot.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ResultSnapshot]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResultSnapshot>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ResultSnapshotUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ResultSnapshotTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResultSnapshotTable>? orderBy,
    _is.OrderByListBuilder<ResultSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ResultSnapshot>(
      columnValues: columnValues(ResultSnapshot.t.updateTable),
      where: where(ResultSnapshot.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResultSnapshot.t),
      orderByList: orderByList?.call(ResultSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ResultSnapshot]s in the list and returns the deleted rows.
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
  Future<List<ResultSnapshot>> delete(
    _is.DatabaseSession session,
    List<ResultSnapshot> rows, {
    _is.OrderByBuilder<ResultSnapshotTable>? orderBy,
    _is.OrderByListBuilder<ResultSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ResultSnapshot>(
      rows,
      orderBy: orderBy?.call(ResultSnapshot.t),
      orderByList: orderByList?.call(ResultSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ResultSnapshot].
  Future<ResultSnapshot> deleteRow(
    _is.DatabaseSession session,
    ResultSnapshot row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ResultSnapshot>(
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
  Future<List<ResultSnapshot>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResultSnapshotTable> where,
    _is.OrderByBuilder<ResultSnapshotTable>? orderBy,
    _is.OrderByListBuilder<ResultSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ResultSnapshot>(
      where: where(ResultSnapshot.t),
      orderBy: orderBy?.call(ResultSnapshot.t),
      orderByList: orderByList?.call(ResultSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResultSnapshotTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ResultSnapshot>(
      where: where?.call(ResultSnapshot.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ResultSnapshot] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResultSnapshotTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ResultSnapshot>(
      where: where(ResultSnapshot.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ResultSnapshotAttachRepository {
  const ResultSnapshotAttachRepository._();

  /// Creates a relation between this [ResultSnapshot] and the given [CandidateTally]s
  /// by setting each [CandidateTally]'s foreign key `snapshotId` to refer to this [ResultSnapshot].
  Future<void> tallies(
    _is.DatabaseSession session,
    ResultSnapshot resultSnapshot,
    List<_ixvsuy9r.CandidateTally> candidateTally, {
    _is.Transaction? transaction,
  }) async {
    if (candidateTally.any((e) => e.id == null)) {
      throw ArgumentError.notNull('candidateTally.id');
    }
    if (resultSnapshot.id == null) {
      throw ArgumentError.notNull('resultSnapshot.id');
    }

    var $candidateTally = candidateTally
        .map((e) => e.copyWith(snapshotId: resultSnapshot.id))
        .toList();
    await session.db.update<_ixvsuy9r.CandidateTally>(
      $candidateTally,
      columns: [_ixvsuy9r.CandidateTally.t.snapshotId],
      transaction: transaction,
    );
  }
}

class ResultSnapshotAttachRowRepository {
  const ResultSnapshotAttachRowRepository._();

  /// Creates a relation between this [ResultSnapshot] and the given [CandidateTally]
  /// by setting the [CandidateTally]'s foreign key `snapshotId` to refer to this [ResultSnapshot].
  Future<void> tallies(
    _is.DatabaseSession session,
    ResultSnapshot resultSnapshot,
    _ixvsuy9r.CandidateTally candidateTally, {
    _is.Transaction? transaction,
  }) async {
    if (candidateTally.id == null) {
      throw ArgumentError.notNull('candidateTally.id');
    }
    if (resultSnapshot.id == null) {
      throw ArgumentError.notNull('resultSnapshot.id');
    }

    var $candidateTally = candidateTally.copyWith(
      snapshotId: resultSnapshot.id,
    );
    await session.db.updateRow<_ixvsuy9r.CandidateTally>(
      $candidateTally,
      columns: [_ixvsuy9r.CandidateTally.t.snapshotId],
      transaction: transaction,
    );
  }
}
