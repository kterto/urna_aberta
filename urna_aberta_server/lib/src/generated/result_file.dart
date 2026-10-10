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
import 'signature_status.dart' as _iomwgc6v;

/// A signed TSE result file (EA20) as fetched for Resultados: the raw
/// `.jws`, so every figure shown can be traced back to it.
abstract class ResultFile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ResultFile._({
    this.id,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.tseGeneratedAt,
    required this.fetchedAt,
    required this.rawSha256,
    required this.signature,
    required this.jws,
  });

  factory ResultFile({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    required _iomwgc6v.SignatureStatus signature,
    required String jws,
  }) = _ResultFileImpl;

  factory ResultFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultFile(
      id: jsonSerialization['id'] as int?,
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      tseGeneratedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['tseGeneratedAt'],
      ),
      fetchedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['fetchedAt'],
      ),
      rawSha256: jsonSerialization['rawSha256'] as String,
      signature: _iomwgc6v.SignatureStatus.fromJson(
        (jsonSerialization['signature'] as String),
      ),
      jws: jsonSerialization['jws'] as String,
    );
  }

  static final t = ResultFileTable();

  static const db = ResultFileRepository._();

  @override
  int? id;

  int electionCode;

  int officeCode;

  /// Lowercase scope: `br`, a UF, `zz`, or a municipality (`sp71072`).
  String scopeCode;

  DateTime tseGeneratedAt;

  DateTime fetchedAt;

  /// SHA-256 of the `.jws` bytes, hex.
  String rawSha256;

  _iomwgc6v.SignatureStatus signature;

  String jws;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ResultFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResultFile copyWith({
    int? id,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? jws,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultFile',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      'signature': signature.toJson(),
      'jws': jws,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultFile',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'tseGeneratedAt': tseGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      'rawSha256': rawSha256,
      'signature': signature.toJson(),
      'jws': jws,
    };
  }

  static ResultFileInclude include() {
    return ResultFileInclude._();
  }

  static ResultFileIncludeList includeList({
    _is.WhereExpressionBuilder<ResultFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResultFileTable>? orderBy,
    _is.OrderByListBuilder<ResultFileTable>? orderByList,
    ResultFileInclude? include,
  }) {
    return ResultFileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResultFile.t),
      orderByList: orderByList?.call(ResultFile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResultFileImpl extends ResultFile {
  _ResultFileImpl({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required DateTime tseGeneratedAt,
    required DateTime fetchedAt,
    required String rawSha256,
    required _iomwgc6v.SignatureStatus signature,
    required String jws,
  }) : super._(
         id: id,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         tseGeneratedAt: tseGeneratedAt,
         fetchedAt: fetchedAt,
         rawSha256: rawSha256,
         signature: signature,
         jws: jws,
       );

  /// Returns a shallow copy of this [ResultFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResultFile copyWith({
    Object? id = _Undefined,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    DateTime? tseGeneratedAt,
    DateTime? fetchedAt,
    String? rawSha256,
    _iomwgc6v.SignatureStatus? signature,
    String? jws,
  }) {
    return ResultFile(
      id: id is int? ? id : this.id,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      tseGeneratedAt: tseGeneratedAt ?? this.tseGeneratedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rawSha256: rawSha256 ?? this.rawSha256,
      signature: signature ?? this.signature,
      jws: jws ?? this.jws,
    );
  }
}

class ResultFileUpdateTable extends _is.UpdateTable<ResultFileTable> {
  ResultFileUpdateTable(super.table);

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

  _is.ColumnValue<_iomwgc6v.SignatureStatus, _iomwgc6v.SignatureStatus>
  signature(_iomwgc6v.SignatureStatus value) => _is.ColumnValue(
    table.signature,
    value,
  );

  _is.ColumnValue<String, String> jws(String value) => _is.ColumnValue(
    table.jws,
    value,
  );
}

class ResultFileTable extends _is.Table<int?> {
  ResultFileTable({super.tableRelation}) : super(tableName: 'result_file') {
    updateTable = ResultFileUpdateTable(this);
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
    signature = _is.ColumnEnum(
      'signature',
      this,
      _is.EnumSerialization.byName,
    );
    jws = _is.ColumnString(
      'jws',
      this,
    );
  }

  late final ResultFileUpdateTable updateTable;

  late final _is.ColumnInt electionCode;

  late final _is.ColumnInt officeCode;

  /// Lowercase scope: `br`, a UF, `zz`, or a municipality (`sp71072`).
  late final _is.ColumnString scopeCode;

  late final _is.ColumnDateTime tseGeneratedAt;

  late final _is.ColumnDateTime fetchedAt;

  /// SHA-256 of the `.jws` bytes, hex.
  late final _is.ColumnString rawSha256;

  late final _is.ColumnEnum<_iomwgc6v.SignatureStatus> signature;

  late final _is.ColumnString jws;

  @override
  List<_is.Column> get columns => [
    id,
    electionCode,
    officeCode,
    scopeCode,
    tseGeneratedAt,
    fetchedAt,
    rawSha256,
    signature,
    jws,
  ];
}

class ResultFileInclude extends _is.IncludeObject {
  ResultFileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ResultFile.t;
}

class ResultFileIncludeList extends _is.IncludeList {
  ResultFileIncludeList._({
    _is.WhereExpressionBuilder<ResultFileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ResultFile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ResultFile.t;
}

class ResultFileRepository {
  const ResultFileRepository._();

  /// Returns a list of [ResultFile]s matching the given query parameters.
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
  Future<List<ResultFile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResultFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResultFileTable>? orderBy,
    _is.OrderByListBuilder<ResultFileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ResultFile>(
      where: where?.call(ResultFile.t),
      orderBy: orderBy?.call(ResultFile.t),
      orderByList: orderByList?.call(ResultFile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ResultFile] matching the given query parameters.
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
  Future<ResultFile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResultFileTable>? where,
    int? offset,
    _is.OrderByBuilder<ResultFileTable>? orderBy,
    _is.OrderByListBuilder<ResultFileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ResultFile>(
      where: where?.call(ResultFile.t),
      orderBy: orderBy?.call(ResultFile.t),
      orderByList: orderByList?.call(ResultFile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ResultFile] by its [id] or null if no such row exists.
  Future<ResultFile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ResultFile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ResultFile]s in the list and returns the inserted rows.
  ///
  /// The returned [ResultFile]s will have their `id` fields set.
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
  Future<List<ResultFile>> insert(
    _is.DatabaseSession session,
    List<ResultFile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ResultFile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ResultFile] and returns the inserted row.
  ///
  /// The returned [ResultFile] will have its `id` field set.
  Future<ResultFile> insertRow(
    _is.DatabaseSession session,
    ResultFile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ResultFile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ResultFile]s in the list and returns the resulting rows.
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
  /// The returned [ResultFile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResultFile>> upsert(
    _is.DatabaseSession session,
    List<ResultFile> rows, {
    required _is.ColumnSelections<ResultFileTable> conflictColumns,
    _is.ColumnSelections<ResultFileTable>? updateColumns,
    _is.WhereExpressionBuilder<ResultFileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ResultFile>(
      rows,
      conflictColumns: conflictColumns(ResultFile.t),
      updateColumns: updateColumns?.call(ResultFile.t),
      updateWhere: updateWhere?.call(ResultFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ResultFile] and returns the resulting row.
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
  /// The returned [ResultFile] will have its `id` field set.
  Future<ResultFile?> upsertRow(
    _is.DatabaseSession session,
    ResultFile row, {
    required _is.ColumnSelections<ResultFileTable> conflictColumns,
    _is.ColumnSelections<ResultFileTable>? updateColumns,
    _is.WhereExpressionBuilder<ResultFileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ResultFile>(
      row,
      conflictColumns: conflictColumns(ResultFile.t),
      updateColumns: updateColumns?.call(ResultFile.t),
      updateWhere: updateWhere?.call(ResultFile.t),
      transaction: transaction,
    );
  }

  /// Updates all [ResultFile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResultFile>> update(
    _is.DatabaseSession session,
    List<ResultFile> rows, {
    _is.ColumnSelections<ResultFileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ResultFile>(
      rows,
      columns: columns?.call(ResultFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ResultFile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ResultFile> updateRow(
    _is.DatabaseSession session,
    ResultFile row, {
    _is.ColumnSelections<ResultFileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ResultFile>(
      row,
      columns: columns?.call(ResultFile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ResultFile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ResultFile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ResultFileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ResultFile>(
      id,
      columnValues: columnValues(ResultFile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ResultFile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResultFile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ResultFileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ResultFileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResultFileTable>? orderBy,
    _is.OrderByListBuilder<ResultFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ResultFile>(
      columnValues: columnValues(ResultFile.t.updateTable),
      where: where(ResultFile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResultFile.t),
      orderByList: orderByList?.call(ResultFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ResultFile]s in the list and returns the deleted rows.
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
  Future<List<ResultFile>> delete(
    _is.DatabaseSession session,
    List<ResultFile> rows, {
    _is.OrderByBuilder<ResultFileTable>? orderBy,
    _is.OrderByListBuilder<ResultFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ResultFile>(
      rows,
      orderBy: orderBy?.call(ResultFile.t),
      orderByList: orderByList?.call(ResultFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ResultFile].
  Future<ResultFile> deleteRow(
    _is.DatabaseSession session,
    ResultFile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ResultFile>(
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
  Future<List<ResultFile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResultFileTable> where,
    _is.OrderByBuilder<ResultFileTable>? orderBy,
    _is.OrderByListBuilder<ResultFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ResultFile>(
      where: where(ResultFile.t),
      orderBy: orderBy?.call(ResultFile.t),
      orderByList: orderByList?.call(ResultFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResultFileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ResultFile>(
      where: where?.call(ResultFile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ResultFile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResultFileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ResultFile>(
      where: where(ResultFile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
