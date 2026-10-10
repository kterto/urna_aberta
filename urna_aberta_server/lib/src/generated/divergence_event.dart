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
import 'data_origin.dart' as _i2ilnjuc;

/// A period when the national file lagged the sum of the per-UF files.
abstract class DivergenceEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DivergenceEvent._({
    this.id,
    required this.origin,
    required this.electionCode,
    required this.startedAt,
    this.endedAt,
    required this.nationalPctAtStart,
    required this.maxGap,
  });

  factory DivergenceEvent({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required DateTime startedAt,
    DateTime? endedAt,
    required double nationalPctAtStart,
    required double maxGap,
  }) = _DivergenceEventImpl;

  factory DivergenceEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return DivergenceEvent(
      id: jsonSerialization['id'] as int?,
      origin: _i2ilnjuc.DataOrigin.fromJson(
        (jsonSerialization['origin'] as String),
      ),
      electionCode: jsonSerialization['electionCode'] as int,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      nationalPctAtStart: (jsonSerialization['nationalPctAtStart'] as num)
          .toDouble(),
      maxGap: (jsonSerialization['maxGap'] as num).toDouble(),
    );
  }

  static final t = DivergenceEventTable();

  static const db = DivergenceEventRepository._();

  @override
  int? id;

  _i2ilnjuc.DataOrigin origin;

  int electionCode;

  DateTime startedAt;

  /// Null while the gap is still open.
  DateTime? endedAt;

  /// % sections totalized in the national file when the lag began.
  double nationalPctAtStart;

  /// Largest gap seen, in percentage points.
  double maxGap;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DivergenceEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DivergenceEvent copyWith({
    int? id,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    DateTime? startedAt,
    DateTime? endedAt,
    double? nationalPctAtStart,
    double? maxGap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DivergenceEvent',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'startedAt': startedAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'nationalPctAtStart': nationalPctAtStart,
      'maxGap': maxGap,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DivergenceEvent',
      if (id != null) 'id': id,
      'origin': origin.toJson(),
      'electionCode': electionCode,
      'startedAt': startedAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'nationalPctAtStart': nationalPctAtStart,
      'maxGap': maxGap,
    };
  }

  static DivergenceEventInclude include() {
    return DivergenceEventInclude._();
  }

  static DivergenceEventIncludeList includeList({
    _is.WhereExpressionBuilder<DivergenceEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DivergenceEventTable>? orderBy,
    _is.OrderByListBuilder<DivergenceEventTable>? orderByList,
    DivergenceEventInclude? include,
  }) {
    return DivergenceEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DivergenceEvent.t),
      orderByList: orderByList?.call(DivergenceEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DivergenceEventImpl extends DivergenceEvent {
  _DivergenceEventImpl({
    int? id,
    required _i2ilnjuc.DataOrigin origin,
    required int electionCode,
    required DateTime startedAt,
    DateTime? endedAt,
    required double nationalPctAtStart,
    required double maxGap,
  }) : super._(
         id: id,
         origin: origin,
         electionCode: electionCode,
         startedAt: startedAt,
         endedAt: endedAt,
         nationalPctAtStart: nationalPctAtStart,
         maxGap: maxGap,
       );

  /// Returns a shallow copy of this [DivergenceEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DivergenceEvent copyWith({
    Object? id = _Undefined,
    _i2ilnjuc.DataOrigin? origin,
    int? electionCode,
    DateTime? startedAt,
    Object? endedAt = _Undefined,
    double? nationalPctAtStart,
    double? maxGap,
  }) {
    return DivergenceEvent(
      id: id is int? ? id : this.id,
      origin: origin ?? this.origin,
      electionCode: electionCode ?? this.electionCode,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      nationalPctAtStart: nationalPctAtStart ?? this.nationalPctAtStart,
      maxGap: maxGap ?? this.maxGap,
    );
  }
}

class DivergenceEventUpdateTable extends _is.UpdateTable<DivergenceEventTable> {
  DivergenceEventUpdateTable(super.table);

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

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endedAt(DateTime? value) =>
      _is.ColumnValue(
        table.endedAt,
        value,
      );

  _is.ColumnValue<double, double> nationalPctAtStart(double value) =>
      _is.ColumnValue(
        table.nationalPctAtStart,
        value,
      );

  _is.ColumnValue<double, double> maxGap(double value) => _is.ColumnValue(
    table.maxGap,
    value,
  );
}

class DivergenceEventTable extends _is.Table<int?> {
  DivergenceEventTable({super.tableRelation})
    : super(tableName: 'divergence_event') {
    updateTable = DivergenceEventUpdateTable(this);
    origin = _is.ColumnEnum(
      'origin',
      this,
      _is.EnumSerialization.byName,
    );
    electionCode = _is.ColumnInt(
      'electionCode',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    endedAt = _is.ColumnDateTime(
      'endedAt',
      this,
    );
    nationalPctAtStart = _is.ColumnDouble(
      'nationalPctAtStart',
      this,
    );
    maxGap = _is.ColumnDouble(
      'maxGap',
      this,
    );
  }

  late final DivergenceEventUpdateTable updateTable;

  late final _is.ColumnEnum<_i2ilnjuc.DataOrigin> origin;

  late final _is.ColumnInt electionCode;

  late final _is.ColumnDateTime startedAt;

  /// Null while the gap is still open.
  late final _is.ColumnDateTime endedAt;

  /// % sections totalized in the national file when the lag began.
  late final _is.ColumnDouble nationalPctAtStart;

  /// Largest gap seen, in percentage points.
  late final _is.ColumnDouble maxGap;

  @override
  List<_is.Column> get columns => [
    id,
    origin,
    electionCode,
    startedAt,
    endedAt,
    nationalPctAtStart,
    maxGap,
  ];
}

class DivergenceEventInclude extends _is.IncludeObject {
  DivergenceEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DivergenceEvent.t;
}

class DivergenceEventIncludeList extends _is.IncludeList {
  DivergenceEventIncludeList._({
    _is.WhereExpressionBuilder<DivergenceEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DivergenceEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DivergenceEvent.t;
}

class DivergenceEventRepository {
  const DivergenceEventRepository._();

  /// Returns a list of [DivergenceEvent]s matching the given query parameters.
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
  Future<List<DivergenceEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DivergenceEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DivergenceEventTable>? orderBy,
    _is.OrderByListBuilder<DivergenceEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DivergenceEvent>(
      where: where?.call(DivergenceEvent.t),
      orderBy: orderBy?.call(DivergenceEvent.t),
      orderByList: orderByList?.call(DivergenceEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DivergenceEvent] matching the given query parameters.
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
  Future<DivergenceEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DivergenceEventTable>? where,
    int? offset,
    _is.OrderByBuilder<DivergenceEventTable>? orderBy,
    _is.OrderByListBuilder<DivergenceEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DivergenceEvent>(
      where: where?.call(DivergenceEvent.t),
      orderBy: orderBy?.call(DivergenceEvent.t),
      orderByList: orderByList?.call(DivergenceEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DivergenceEvent] by its [id] or null if no such row exists.
  Future<DivergenceEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DivergenceEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DivergenceEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [DivergenceEvent]s will have their `id` fields set.
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
  Future<List<DivergenceEvent>> insert(
    _is.DatabaseSession session,
    List<DivergenceEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DivergenceEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DivergenceEvent] and returns the inserted row.
  ///
  /// The returned [DivergenceEvent] will have its `id` field set.
  Future<DivergenceEvent> insertRow(
    _is.DatabaseSession session,
    DivergenceEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DivergenceEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DivergenceEvent]s in the list and returns the resulting rows.
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
  /// The returned [DivergenceEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DivergenceEvent>> upsert(
    _is.DatabaseSession session,
    List<DivergenceEvent> rows, {
    required _is.ColumnSelections<DivergenceEventTable> conflictColumns,
    _is.ColumnSelections<DivergenceEventTable>? updateColumns,
    _is.WhereExpressionBuilder<DivergenceEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DivergenceEvent>(
      rows,
      conflictColumns: conflictColumns(DivergenceEvent.t),
      updateColumns: updateColumns?.call(DivergenceEvent.t),
      updateWhere: updateWhere?.call(DivergenceEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DivergenceEvent] and returns the resulting row.
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
  /// The returned [DivergenceEvent] will have its `id` field set.
  Future<DivergenceEvent?> upsertRow(
    _is.DatabaseSession session,
    DivergenceEvent row, {
    required _is.ColumnSelections<DivergenceEventTable> conflictColumns,
    _is.ColumnSelections<DivergenceEventTable>? updateColumns,
    _is.WhereExpressionBuilder<DivergenceEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DivergenceEvent>(
      row,
      conflictColumns: conflictColumns(DivergenceEvent.t),
      updateColumns: updateColumns?.call(DivergenceEvent.t),
      updateWhere: updateWhere?.call(DivergenceEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [DivergenceEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DivergenceEvent>> update(
    _is.DatabaseSession session,
    List<DivergenceEvent> rows, {
    _is.ColumnSelections<DivergenceEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DivergenceEvent>(
      rows,
      columns: columns?.call(DivergenceEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DivergenceEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DivergenceEvent> updateRow(
    _is.DatabaseSession session,
    DivergenceEvent row, {
    _is.ColumnSelections<DivergenceEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DivergenceEvent>(
      row,
      columns: columns?.call(DivergenceEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DivergenceEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DivergenceEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DivergenceEventUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DivergenceEvent>(
      id,
      columnValues: columnValues(DivergenceEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DivergenceEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DivergenceEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DivergenceEventUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DivergenceEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DivergenceEventTable>? orderBy,
    _is.OrderByListBuilder<DivergenceEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DivergenceEvent>(
      columnValues: columnValues(DivergenceEvent.t.updateTable),
      where: where(DivergenceEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DivergenceEvent.t),
      orderByList: orderByList?.call(DivergenceEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DivergenceEvent]s in the list and returns the deleted rows.
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
  Future<List<DivergenceEvent>> delete(
    _is.DatabaseSession session,
    List<DivergenceEvent> rows, {
    _is.OrderByBuilder<DivergenceEventTable>? orderBy,
    _is.OrderByListBuilder<DivergenceEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DivergenceEvent>(
      rows,
      orderBy: orderBy?.call(DivergenceEvent.t),
      orderByList: orderByList?.call(DivergenceEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DivergenceEvent].
  Future<DivergenceEvent> deleteRow(
    _is.DatabaseSession session,
    DivergenceEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DivergenceEvent>(
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
  Future<List<DivergenceEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DivergenceEventTable> where,
    _is.OrderByBuilder<DivergenceEventTable>? orderBy,
    _is.OrderByListBuilder<DivergenceEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DivergenceEvent>(
      where: where(DivergenceEvent.t),
      orderBy: orderBy?.call(DivergenceEvent.t),
      orderByList: orderByList?.call(DivergenceEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DivergenceEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DivergenceEvent>(
      where: where?.call(DivergenceEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DivergenceEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DivergenceEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DivergenceEvent>(
      where: where(DivergenceEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
