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
import 'result_snapshot.dart' as _i4dv59av;

/// Votes for one candidate in one [ResultSnapshot].
abstract class CandidateTally
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CandidateTally._({
    this.id,
    required this.snapshotId,
    this.snapshot,
    required this.candidateNumber,
    required this.votes,
  });

  factory CandidateTally({
    int? id,
    required int snapshotId,
    _i4dv59av.ResultSnapshot? snapshot,
    required int candidateNumber,
    required int votes,
  }) = _CandidateTallyImpl;

  factory CandidateTally.fromJson(Map<String, dynamic> jsonSerialization) {
    return CandidateTally(
      id: jsonSerialization['id'] as int?,
      snapshotId: jsonSerialization['snapshotId'] as int,
      snapshot: jsonSerialization['snapshot'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<_i4dv59av.ResultSnapshot>(
              jsonSerialization['snapshot'],
            ),
      candidateNumber: jsonSerialization['candidateNumber'] as int,
      votes: jsonSerialization['votes'] as int,
    );
  }

  static final t = CandidateTallyTable();

  static const db = CandidateTallyRepository._();

  @override
  int? id;

  int snapshotId;

  _i4dv59av.ResultSnapshot? snapshot;

  int candidateNumber;

  int votes;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CandidateTally]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CandidateTally copyWith({
    int? id,
    int? snapshotId,
    _i4dv59av.ResultSnapshot? snapshot,
    int? candidateNumber,
    int? votes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CandidateTally',
      if (id != null) 'id': id,
      'snapshotId': snapshotId,
      if (snapshot != null) 'snapshot': snapshot?.toJson(),
      'candidateNumber': candidateNumber,
      'votes': votes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CandidateTally',
      if (id != null) 'id': id,
      'snapshotId': snapshotId,
      if (snapshot != null) 'snapshot': snapshot?.toJsonForProtocol(),
      'candidateNumber': candidateNumber,
      'votes': votes,
    };
  }

  static CandidateTallyInclude include({
    _i4dv59av.ResultSnapshotInclude? snapshot,
  }) {
    return CandidateTallyInclude._(snapshot: snapshot);
  }

  static CandidateTallyIncludeList includeList({
    _is.WhereExpressionBuilder<CandidateTallyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CandidateTallyTable>? orderBy,
    _is.OrderByListBuilder<CandidateTallyTable>? orderByList,
    CandidateTallyInclude? include,
  }) {
    return CandidateTallyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CandidateTally.t),
      orderByList: orderByList?.call(CandidateTally.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CandidateTallyImpl extends CandidateTally {
  _CandidateTallyImpl({
    int? id,
    required int snapshotId,
    _i4dv59av.ResultSnapshot? snapshot,
    required int candidateNumber,
    required int votes,
  }) : super._(
         id: id,
         snapshotId: snapshotId,
         snapshot: snapshot,
         candidateNumber: candidateNumber,
         votes: votes,
       );

  /// Returns a shallow copy of this [CandidateTally]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CandidateTally copyWith({
    Object? id = _Undefined,
    int? snapshotId,
    Object? snapshot = _Undefined,
    int? candidateNumber,
    int? votes,
  }) {
    return CandidateTally(
      id: id is int? ? id : this.id,
      snapshotId: snapshotId ?? this.snapshotId,
      snapshot: snapshot is _i4dv59av.ResultSnapshot?
          ? snapshot
          : this.snapshot?.copyWith(),
      candidateNumber: candidateNumber ?? this.candidateNumber,
      votes: votes ?? this.votes,
    );
  }
}

class CandidateTallyUpdateTable extends _is.UpdateTable<CandidateTallyTable> {
  CandidateTallyUpdateTable(super.table);

  _is.ColumnValue<int, int> snapshotId(int value) => _is.ColumnValue(
    table.snapshotId,
    value,
  );

  _is.ColumnValue<int, int> candidateNumber(int value) => _is.ColumnValue(
    table.candidateNumber,
    value,
  );

  _is.ColumnValue<int, int> votes(int value) => _is.ColumnValue(
    table.votes,
    value,
  );
}

class CandidateTallyTable extends _is.Table<int?> {
  CandidateTallyTable({super.tableRelation})
    : super(tableName: 'candidate_tally') {
    updateTable = CandidateTallyUpdateTable(this);
    snapshotId = _is.ColumnInt(
      'snapshotId',
      this,
    );
    candidateNumber = _is.ColumnInt(
      'candidateNumber',
      this,
    );
    votes = _is.ColumnInt(
      'votes',
      this,
    );
  }

  late final CandidateTallyUpdateTable updateTable;

  late final _is.ColumnInt snapshotId;

  _i4dv59av.ResultSnapshotTable? _snapshot;

  late final _is.ColumnInt candidateNumber;

  late final _is.ColumnInt votes;

  _i4dv59av.ResultSnapshotTable get snapshot {
    if (_snapshot != null) return _snapshot!;
    _snapshot = _is.createRelationTable(
      relationFieldName: 'snapshot',
      field: CandidateTally.t.snapshotId,
      foreignField: _i4dv59av.ResultSnapshot.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4dv59av.ResultSnapshotTable(tableRelation: foreignTableRelation),
    );
    return _snapshot!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    snapshotId,
    candidateNumber,
    votes,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'snapshot') {
      return snapshot;
    }
    return null;
  }
}

class CandidateTallyInclude extends _is.IncludeObject {
  CandidateTallyInclude._({_i4dv59av.ResultSnapshotInclude? snapshot}) {
    _snapshot = snapshot;
  }

  _i4dv59av.ResultSnapshotInclude? _snapshot;

  @override
  Map<String, _is.Include?> get includes => {'snapshot': _snapshot};

  @override
  _is.Table<int?> get table => CandidateTally.t;
}

class CandidateTallyIncludeList extends _is.IncludeList {
  CandidateTallyIncludeList._({
    _is.WhereExpressionBuilder<CandidateTallyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CandidateTally.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CandidateTally.t;
}

class CandidateTallyRepository {
  const CandidateTallyRepository._();

  final attachRow = const CandidateTallyAttachRowRepository._();

  /// Returns a list of [CandidateTally]s matching the given query parameters.
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
  Future<List<CandidateTally>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CandidateTallyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CandidateTallyTable>? orderBy,
    _is.OrderByListBuilder<CandidateTallyTable>? orderByList,
    _is.Transaction? transaction,
    CandidateTallyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CandidateTally>(
      where: where?.call(CandidateTally.t),
      orderBy: orderBy?.call(CandidateTally.t),
      orderByList: orderByList?.call(CandidateTally.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CandidateTally] matching the given query parameters.
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
  Future<CandidateTally?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CandidateTallyTable>? where,
    int? offset,
    _is.OrderByBuilder<CandidateTallyTable>? orderBy,
    _is.OrderByListBuilder<CandidateTallyTable>? orderByList,
    _is.Transaction? transaction,
    CandidateTallyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CandidateTally>(
      where: where?.call(CandidateTally.t),
      orderBy: orderBy?.call(CandidateTally.t),
      orderByList: orderByList?.call(CandidateTally.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CandidateTally] by its [id] or null if no such row exists.
  Future<CandidateTally?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CandidateTallyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CandidateTally>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CandidateTally]s in the list and returns the inserted rows.
  ///
  /// The returned [CandidateTally]s will have their `id` fields set.
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
  Future<List<CandidateTally>> insert(
    _is.DatabaseSession session,
    List<CandidateTally> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CandidateTally>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CandidateTally] and returns the inserted row.
  ///
  /// The returned [CandidateTally] will have its `id` field set.
  Future<CandidateTally> insertRow(
    _is.DatabaseSession session,
    CandidateTally row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CandidateTally>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CandidateTally]s in the list and returns the resulting rows.
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
  /// The returned [CandidateTally]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CandidateTally>> upsert(
    _is.DatabaseSession session,
    List<CandidateTally> rows, {
    required _is.ColumnSelections<CandidateTallyTable> conflictColumns,
    _is.ColumnSelections<CandidateTallyTable>? updateColumns,
    _is.WhereExpressionBuilder<CandidateTallyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CandidateTally>(
      rows,
      conflictColumns: conflictColumns(CandidateTally.t),
      updateColumns: updateColumns?.call(CandidateTally.t),
      updateWhere: updateWhere?.call(CandidateTally.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CandidateTally] and returns the resulting row.
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
  /// The returned [CandidateTally] will have its `id` field set.
  Future<CandidateTally?> upsertRow(
    _is.DatabaseSession session,
    CandidateTally row, {
    required _is.ColumnSelections<CandidateTallyTable> conflictColumns,
    _is.ColumnSelections<CandidateTallyTable>? updateColumns,
    _is.WhereExpressionBuilder<CandidateTallyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CandidateTally>(
      row,
      conflictColumns: conflictColumns(CandidateTally.t),
      updateColumns: updateColumns?.call(CandidateTally.t),
      updateWhere: updateWhere?.call(CandidateTally.t),
      transaction: transaction,
    );
  }

  /// Updates all [CandidateTally]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CandidateTally>> update(
    _is.DatabaseSession session,
    List<CandidateTally> rows, {
    _is.ColumnSelections<CandidateTallyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CandidateTally>(
      rows,
      columns: columns?.call(CandidateTally.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CandidateTally]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CandidateTally> updateRow(
    _is.DatabaseSession session,
    CandidateTally row, {
    _is.ColumnSelections<CandidateTallyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CandidateTally>(
      row,
      columns: columns?.call(CandidateTally.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CandidateTally] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CandidateTally?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CandidateTallyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CandidateTally>(
      id,
      columnValues: columnValues(CandidateTally.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CandidateTally]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CandidateTally>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CandidateTallyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CandidateTallyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CandidateTallyTable>? orderBy,
    _is.OrderByListBuilder<CandidateTallyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CandidateTally>(
      columnValues: columnValues(CandidateTally.t.updateTable),
      where: where(CandidateTally.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CandidateTally.t),
      orderByList: orderByList?.call(CandidateTally.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CandidateTally]s in the list and returns the deleted rows.
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
  Future<List<CandidateTally>> delete(
    _is.DatabaseSession session,
    List<CandidateTally> rows, {
    _is.OrderByBuilder<CandidateTallyTable>? orderBy,
    _is.OrderByListBuilder<CandidateTallyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CandidateTally>(
      rows,
      orderBy: orderBy?.call(CandidateTally.t),
      orderByList: orderByList?.call(CandidateTally.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CandidateTally].
  Future<CandidateTally> deleteRow(
    _is.DatabaseSession session,
    CandidateTally row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CandidateTally>(
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
  Future<List<CandidateTally>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CandidateTallyTable> where,
    _is.OrderByBuilder<CandidateTallyTable>? orderBy,
    _is.OrderByListBuilder<CandidateTallyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CandidateTally>(
      where: where(CandidateTally.t),
      orderBy: orderBy?.call(CandidateTally.t),
      orderByList: orderByList?.call(CandidateTally.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CandidateTallyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CandidateTally>(
      where: where?.call(CandidateTally.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CandidateTally] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CandidateTallyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CandidateTally>(
      where: where(CandidateTally.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CandidateTallyAttachRowRepository {
  const CandidateTallyAttachRowRepository._();

  /// Creates a relation between the given [CandidateTally] and [ResultSnapshot]
  /// by setting the [CandidateTally]'s foreign key `snapshotId` to refer to the [ResultSnapshot].
  Future<void> snapshot(
    _is.DatabaseSession session,
    CandidateTally candidateTally,
    _i4dv59av.ResultSnapshot snapshot, {
    _is.Transaction? transaction,
  }) async {
    if (candidateTally.id == null) {
      throw ArgumentError.notNull('candidateTally.id');
    }
    if (snapshot.id == null) {
      throw ArgumentError.notNull('snapshot.id');
    }

    var $candidateTally = candidateTally.copyWith(snapshotId: snapshot.id);
    await session.db.updateRow<CandidateTally>(
      $candidateTally,
      columns: [CandidateTally.t.snapshotId],
      transaction: transaction,
    );
  }
}
