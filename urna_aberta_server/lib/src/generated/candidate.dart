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

/// A candidacy as listed in an EA20 file. Never given a color in the UI.
abstract class Candidate
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Candidate._({
    this.id,
    required this.electionCode,
    required this.officeCode,
    required this.scopeCode,
    required this.number,
    required this.ballotName,
    required this.party,
  });

  factory Candidate({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int number,
    required String ballotName,
    required String party,
  }) = _CandidateImpl;

  factory Candidate.fromJson(Map<String, dynamic> jsonSerialization) {
    return Candidate(
      id: jsonSerialization['id'] as int?,
      electionCode: jsonSerialization['electionCode'] as int,
      officeCode: jsonSerialization['officeCode'] as int,
      scopeCode: jsonSerialization['scopeCode'] as String,
      number: jsonSerialization['number'] as int,
      ballotName: jsonSerialization['ballotName'] as String,
      party: jsonSerialization['party'] as String,
    );
  }

  static final t = CandidateTable();

  static const db = CandidateRepository._();

  @override
  int? id;

  int electionCode;

  int officeCode;

  /// Scope of the file that lists it: `br` for President, a UF otherwise.
  String scopeCode;

  /// Ballot number.
  int number;

  /// Name on the ballot (`nmu`), as TSE writes it.
  String ballotName;

  /// Party abbreviation (`sg`).
  String party;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Candidate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Candidate copyWith({
    int? id,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? number,
    String? ballotName,
    String? party,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Candidate',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'number': number,
      'ballotName': ballotName,
      'party': party,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Candidate',
      if (id != null) 'id': id,
      'electionCode': electionCode,
      'officeCode': officeCode,
      'scopeCode': scopeCode,
      'number': number,
      'ballotName': ballotName,
      'party': party,
    };
  }

  static CandidateInclude include() {
    return CandidateInclude._();
  }

  static CandidateIncludeList includeList({
    _is.WhereExpressionBuilder<CandidateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CandidateTable>? orderBy,
    _is.OrderByListBuilder<CandidateTable>? orderByList,
    CandidateInclude? include,
  }) {
    return CandidateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Candidate.t),
      orderByList: orderByList?.call(Candidate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CandidateImpl extends Candidate {
  _CandidateImpl({
    int? id,
    required int electionCode,
    required int officeCode,
    required String scopeCode,
    required int number,
    required String ballotName,
    required String party,
  }) : super._(
         id: id,
         electionCode: electionCode,
         officeCode: officeCode,
         scopeCode: scopeCode,
         number: number,
         ballotName: ballotName,
         party: party,
       );

  /// Returns a shallow copy of this [Candidate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Candidate copyWith({
    Object? id = _Undefined,
    int? electionCode,
    int? officeCode,
    String? scopeCode,
    int? number,
    String? ballotName,
    String? party,
  }) {
    return Candidate(
      id: id is int? ? id : this.id,
      electionCode: electionCode ?? this.electionCode,
      officeCode: officeCode ?? this.officeCode,
      scopeCode: scopeCode ?? this.scopeCode,
      number: number ?? this.number,
      ballotName: ballotName ?? this.ballotName,
      party: party ?? this.party,
    );
  }
}

class CandidateUpdateTable extends _is.UpdateTable<CandidateTable> {
  CandidateUpdateTable(super.table);

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

  _is.ColumnValue<int, int> number(int value) => _is.ColumnValue(
    table.number,
    value,
  );

  _is.ColumnValue<String, String> ballotName(String value) => _is.ColumnValue(
    table.ballotName,
    value,
  );

  _is.ColumnValue<String, String> party(String value) => _is.ColumnValue(
    table.party,
    value,
  );
}

class CandidateTable extends _is.Table<int?> {
  CandidateTable({super.tableRelation}) : super(tableName: 'candidate') {
    updateTable = CandidateUpdateTable(this);
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
    number = _is.ColumnInt(
      'number',
      this,
    );
    ballotName = _is.ColumnString(
      'ballotName',
      this,
    );
    party = _is.ColumnString(
      'party',
      this,
    );
  }

  late final CandidateUpdateTable updateTable;

  late final _is.ColumnInt electionCode;

  late final _is.ColumnInt officeCode;

  /// Scope of the file that lists it: `br` for President, a UF otherwise.
  late final _is.ColumnString scopeCode;

  /// Ballot number.
  late final _is.ColumnInt number;

  /// Name on the ballot (`nmu`), as TSE writes it.
  late final _is.ColumnString ballotName;

  /// Party abbreviation (`sg`).
  late final _is.ColumnString party;

  @override
  List<_is.Column> get columns => [
    id,
    electionCode,
    officeCode,
    scopeCode,
    number,
    ballotName,
    party,
  ];
}

class CandidateInclude extends _is.IncludeObject {
  CandidateInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Candidate.t;
}

class CandidateIncludeList extends _is.IncludeList {
  CandidateIncludeList._({
    _is.WhereExpressionBuilder<CandidateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Candidate.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Candidate.t;
}

class CandidateRepository {
  const CandidateRepository._();

  /// Returns a list of [Candidate]s matching the given query parameters.
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
  Future<List<Candidate>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CandidateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CandidateTable>? orderBy,
    _is.OrderByListBuilder<CandidateTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Candidate>(
      where: where?.call(Candidate.t),
      orderBy: orderBy?.call(Candidate.t),
      orderByList: orderByList?.call(Candidate.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Candidate] matching the given query parameters.
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
  Future<Candidate?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CandidateTable>? where,
    int? offset,
    _is.OrderByBuilder<CandidateTable>? orderBy,
    _is.OrderByListBuilder<CandidateTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Candidate>(
      where: where?.call(Candidate.t),
      orderBy: orderBy?.call(Candidate.t),
      orderByList: orderByList?.call(Candidate.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Candidate] by its [id] or null if no such row exists.
  Future<Candidate?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Candidate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Candidate]s in the list and returns the inserted rows.
  ///
  /// The returned [Candidate]s will have their `id` fields set.
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
  Future<List<Candidate>> insert(
    _is.DatabaseSession session,
    List<Candidate> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Candidate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Candidate] and returns the inserted row.
  ///
  /// The returned [Candidate] will have its `id` field set.
  Future<Candidate> insertRow(
    _is.DatabaseSession session,
    Candidate row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Candidate>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Candidate]s in the list and returns the resulting rows.
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
  /// The returned [Candidate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Candidate>> upsert(
    _is.DatabaseSession session,
    List<Candidate> rows, {
    required _is.ColumnSelections<CandidateTable> conflictColumns,
    _is.ColumnSelections<CandidateTable>? updateColumns,
    _is.WhereExpressionBuilder<CandidateTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Candidate>(
      rows,
      conflictColumns: conflictColumns(Candidate.t),
      updateColumns: updateColumns?.call(Candidate.t),
      updateWhere: updateWhere?.call(Candidate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Candidate] and returns the resulting row.
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
  /// The returned [Candidate] will have its `id` field set.
  Future<Candidate?> upsertRow(
    _is.DatabaseSession session,
    Candidate row, {
    required _is.ColumnSelections<CandidateTable> conflictColumns,
    _is.ColumnSelections<CandidateTable>? updateColumns,
    _is.WhereExpressionBuilder<CandidateTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Candidate>(
      row,
      conflictColumns: conflictColumns(Candidate.t),
      updateColumns: updateColumns?.call(Candidate.t),
      updateWhere: updateWhere?.call(Candidate.t),
      transaction: transaction,
    );
  }

  /// Updates all [Candidate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Candidate>> update(
    _is.DatabaseSession session,
    List<Candidate> rows, {
    _is.ColumnSelections<CandidateTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Candidate>(
      rows,
      columns: columns?.call(Candidate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Candidate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Candidate> updateRow(
    _is.DatabaseSession session,
    Candidate row, {
    _is.ColumnSelections<CandidateTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Candidate>(
      row,
      columns: columns?.call(Candidate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Candidate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Candidate?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CandidateUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Candidate>(
      id,
      columnValues: columnValues(Candidate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Candidate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Candidate>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CandidateUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CandidateTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CandidateTable>? orderBy,
    _is.OrderByListBuilder<CandidateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Candidate>(
      columnValues: columnValues(Candidate.t.updateTable),
      where: where(Candidate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Candidate.t),
      orderByList: orderByList?.call(Candidate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Candidate]s in the list and returns the deleted rows.
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
  Future<List<Candidate>> delete(
    _is.DatabaseSession session,
    List<Candidate> rows, {
    _is.OrderByBuilder<CandidateTable>? orderBy,
    _is.OrderByListBuilder<CandidateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Candidate>(
      rows,
      orderBy: orderBy?.call(Candidate.t),
      orderByList: orderByList?.call(Candidate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Candidate].
  Future<Candidate> deleteRow(
    _is.DatabaseSession session,
    Candidate row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Candidate>(
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
  Future<List<Candidate>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CandidateTable> where,
    _is.OrderByBuilder<CandidateTable>? orderBy,
    _is.OrderByListBuilder<CandidateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Candidate>(
      where: where(Candidate.t),
      orderBy: orderBy?.call(Candidate.t),
      orderByList: orderByList?.call(Candidate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CandidateTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Candidate>(
      where: where?.call(Candidate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Candidate] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CandidateTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Candidate>(
      where: where(Candidate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
