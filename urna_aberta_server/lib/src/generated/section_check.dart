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
import 'section_file.dart' as _i4rww364;

/// One looked-up polling section, with the raw TSE files it was built from.
abstract class SectionCheck
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SectionCheck._({
    this.id,
    required this.pleito,
    required this.uf,
    required this.municipio,
    required this.zona,
    required this.secao,
    required this.auxStatus,
    required this.auxGeneratedAt,
    required this.fetchedAt,
    this.files,
  });

  factory SectionCheck({
    int? id,
    required int pleito,
    required String uf,
    required int municipio,
    required int zona,
    required int secao,
    required String auxStatus,
    required DateTime auxGeneratedAt,
    required DateTime fetchedAt,
    List<_i4rww364.SectionFile>? files,
  }) = _SectionCheckImpl;

  factory SectionCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return SectionCheck(
      id: jsonSerialization['id'] as int?,
      pleito: jsonSerialization['pleito'] as int,
      uf: jsonSerialization['uf'] as String,
      municipio: jsonSerialization['municipio'] as int,
      zona: jsonSerialization['zona'] as int,
      secao: jsonSerialization['secao'] as int,
      auxStatus: jsonSerialization['auxStatus'] as String,
      auxGeneratedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['auxGeneratedAt'],
      ),
      fetchedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['fetchedAt'],
      ),
      files: jsonSerialization['files'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<List<_i4rww364.SectionFile>>(
              jsonSerialization['files'],
            ),
    );
  }

  static final t = SectionCheckTable();

  static const db = SectionCheckRepository._();

  @override
  int? id;

  int pleito;

  String uf;

  int municipio;

  int zona;

  int secao;

  /// EA18 section status (Totalizada, Recebida, Anulada…).
  String auxStatus;

  DateTime auxGeneratedAt;

  DateTime fetchedAt;

  List<_i4rww364.SectionFile>? files;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SectionCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SectionCheck copyWith({
    int? id,
    int? pleito,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
    String? auxStatus,
    DateTime? auxGeneratedAt,
    DateTime? fetchedAt,
    List<_i4rww364.SectionFile>? files,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SectionCheck',
      if (id != null) 'id': id,
      'pleito': pleito,
      'uf': uf,
      'municipio': municipio,
      'zona': zona,
      'secao': secao,
      'auxStatus': auxStatus,
      'auxGeneratedAt': auxGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      if (files != null) 'files': files?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SectionCheck',
      if (id != null) 'id': id,
      'pleito': pleito,
      'uf': uf,
      'municipio': municipio,
      'zona': zona,
      'secao': secao,
      'auxStatus': auxStatus,
      'auxGeneratedAt': auxGeneratedAt.toJson(),
      'fetchedAt': fetchedAt.toJson(),
      if (files != null)
        'files': files?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static SectionCheckInclude include({
    _i4rww364.SectionFileIncludeList? files,
  }) {
    return SectionCheckInclude._(files: files);
  }

  static SectionCheckIncludeList includeList({
    _is.WhereExpressionBuilder<SectionCheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectionCheckTable>? orderBy,
    _is.OrderByListBuilder<SectionCheckTable>? orderByList,
    SectionCheckInclude? include,
  }) {
    return SectionCheckIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SectionCheck.t),
      orderByList: orderByList?.call(SectionCheck.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectionCheckImpl extends SectionCheck {
  _SectionCheckImpl({
    int? id,
    required int pleito,
    required String uf,
    required int municipio,
    required int zona,
    required int secao,
    required String auxStatus,
    required DateTime auxGeneratedAt,
    required DateTime fetchedAt,
    List<_i4rww364.SectionFile>? files,
  }) : super._(
         id: id,
         pleito: pleito,
         uf: uf,
         municipio: municipio,
         zona: zona,
         secao: secao,
         auxStatus: auxStatus,
         auxGeneratedAt: auxGeneratedAt,
         fetchedAt: fetchedAt,
         files: files,
       );

  /// Returns a shallow copy of this [SectionCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SectionCheck copyWith({
    Object? id = _Undefined,
    int? pleito,
    String? uf,
    int? municipio,
    int? zona,
    int? secao,
    String? auxStatus,
    DateTime? auxGeneratedAt,
    DateTime? fetchedAt,
    Object? files = _Undefined,
  }) {
    return SectionCheck(
      id: id is int? ? id : this.id,
      pleito: pleito ?? this.pleito,
      uf: uf ?? this.uf,
      municipio: municipio ?? this.municipio,
      zona: zona ?? this.zona,
      secao: secao ?? this.secao,
      auxStatus: auxStatus ?? this.auxStatus,
      auxGeneratedAt: auxGeneratedAt ?? this.auxGeneratedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      files: files is List<_i4rww364.SectionFile>?
          ? files
          : this.files?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class SectionCheckUpdateTable extends _is.UpdateTable<SectionCheckTable> {
  SectionCheckUpdateTable(super.table);

  _is.ColumnValue<int, int> pleito(int value) => _is.ColumnValue(
    table.pleito,
    value,
  );

  _is.ColumnValue<String, String> uf(String value) => _is.ColumnValue(
    table.uf,
    value,
  );

  _is.ColumnValue<int, int> municipio(int value) => _is.ColumnValue(
    table.municipio,
    value,
  );

  _is.ColumnValue<int, int> zona(int value) => _is.ColumnValue(
    table.zona,
    value,
  );

  _is.ColumnValue<int, int> secao(int value) => _is.ColumnValue(
    table.secao,
    value,
  );

  _is.ColumnValue<String, String> auxStatus(String value) => _is.ColumnValue(
    table.auxStatus,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> auxGeneratedAt(DateTime value) =>
      _is.ColumnValue(
        table.auxGeneratedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> fetchedAt(DateTime value) =>
      _is.ColumnValue(
        table.fetchedAt,
        value,
      );
}

class SectionCheckTable extends _is.Table<int?> {
  SectionCheckTable({super.tableRelation}) : super(tableName: 'section_check') {
    updateTable = SectionCheckUpdateTable(this);
    pleito = _is.ColumnInt(
      'pleito',
      this,
    );
    uf = _is.ColumnString(
      'uf',
      this,
    );
    municipio = _is.ColumnInt(
      'municipio',
      this,
    );
    zona = _is.ColumnInt(
      'zona',
      this,
    );
    secao = _is.ColumnInt(
      'secao',
      this,
    );
    auxStatus = _is.ColumnString(
      'auxStatus',
      this,
    );
    auxGeneratedAt = _is.ColumnDateTime(
      'auxGeneratedAt',
      this,
    );
    fetchedAt = _is.ColumnDateTime(
      'fetchedAt',
      this,
    );
  }

  late final SectionCheckUpdateTable updateTable;

  late final _is.ColumnInt pleito;

  late final _is.ColumnString uf;

  late final _is.ColumnInt municipio;

  late final _is.ColumnInt zona;

  late final _is.ColumnInt secao;

  /// EA18 section status (Totalizada, Recebida, Anulada…).
  late final _is.ColumnString auxStatus;

  late final _is.ColumnDateTime auxGeneratedAt;

  late final _is.ColumnDateTime fetchedAt;

  _i4rww364.SectionFileTable? ___files;

  _is.ManyRelation<_i4rww364.SectionFileTable>? _files;

  _i4rww364.SectionFileTable get __files {
    if (___files != null) return ___files!;
    ___files = _is.createRelationTable(
      relationFieldName: '__files',
      field: SectionCheck.t.id,
      foreignField: _i4rww364.SectionFile.t.checkId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4rww364.SectionFileTable(tableRelation: foreignTableRelation),
    );
    return ___files!;
  }

  _is.ManyRelation<_i4rww364.SectionFileTable> get files {
    if (_files != null) return _files!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'files',
      field: SectionCheck.t.id,
      foreignField: _i4rww364.SectionFile.t.checkId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4rww364.SectionFileTable(tableRelation: foreignTableRelation),
    );
    _files = _is.ManyRelation<_i4rww364.SectionFileTable>(
      tableWithRelations: relationTable,
      table: _i4rww364.SectionFileTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _files!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    pleito,
    uf,
    municipio,
    zona,
    secao,
    auxStatus,
    auxGeneratedAt,
    fetchedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'files') {
      return __files;
    }
    return null;
  }
}

class SectionCheckInclude extends _is.IncludeObject {
  SectionCheckInclude._({_i4rww364.SectionFileIncludeList? files}) {
    _files = files;
  }

  _i4rww364.SectionFileIncludeList? _files;

  @override
  Map<String, _is.Include?> get includes => {'files': _files};

  @override
  _is.Table<int?> get table => SectionCheck.t;
}

class SectionCheckIncludeList extends _is.IncludeList {
  SectionCheckIncludeList._({
    _is.WhereExpressionBuilder<SectionCheckTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SectionCheck.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SectionCheck.t;
}

class SectionCheckRepository {
  const SectionCheckRepository._();

  final attach = const SectionCheckAttachRepository._();

  final attachRow = const SectionCheckAttachRowRepository._();

  /// Returns a list of [SectionCheck]s matching the given query parameters.
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
  Future<List<SectionCheck>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectionCheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectionCheckTable>? orderBy,
    _is.OrderByListBuilder<SectionCheckTable>? orderByList,
    _is.Transaction? transaction,
    SectionCheckInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SectionCheck>(
      where: where?.call(SectionCheck.t),
      orderBy: orderBy?.call(SectionCheck.t),
      orderByList: orderByList?.call(SectionCheck.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SectionCheck] matching the given query parameters.
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
  Future<SectionCheck?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectionCheckTable>? where,
    int? offset,
    _is.OrderByBuilder<SectionCheckTable>? orderBy,
    _is.OrderByListBuilder<SectionCheckTable>? orderByList,
    _is.Transaction? transaction,
    SectionCheckInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SectionCheck>(
      where: where?.call(SectionCheck.t),
      orderBy: orderBy?.call(SectionCheck.t),
      orderByList: orderByList?.call(SectionCheck.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SectionCheck] by its [id] or null if no such row exists.
  Future<SectionCheck?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SectionCheckInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SectionCheck>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SectionCheck]s in the list and returns the inserted rows.
  ///
  /// The returned [SectionCheck]s will have their `id` fields set.
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
  Future<List<SectionCheck>> insert(
    _is.DatabaseSession session,
    List<SectionCheck> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SectionCheck>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SectionCheck] and returns the inserted row.
  ///
  /// The returned [SectionCheck] will have its `id` field set.
  Future<SectionCheck> insertRow(
    _is.DatabaseSession session,
    SectionCheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SectionCheck>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SectionCheck]s in the list and returns the resulting rows.
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
  /// The returned [SectionCheck]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SectionCheck>> upsert(
    _is.DatabaseSession session,
    List<SectionCheck> rows, {
    required _is.ColumnSelections<SectionCheckTable> conflictColumns,
    _is.ColumnSelections<SectionCheckTable>? updateColumns,
    _is.WhereExpressionBuilder<SectionCheckTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SectionCheck>(
      rows,
      conflictColumns: conflictColumns(SectionCheck.t),
      updateColumns: updateColumns?.call(SectionCheck.t),
      updateWhere: updateWhere?.call(SectionCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SectionCheck] and returns the resulting row.
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
  /// The returned [SectionCheck] will have its `id` field set.
  Future<SectionCheck?> upsertRow(
    _is.DatabaseSession session,
    SectionCheck row, {
    required _is.ColumnSelections<SectionCheckTable> conflictColumns,
    _is.ColumnSelections<SectionCheckTable>? updateColumns,
    _is.WhereExpressionBuilder<SectionCheckTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SectionCheck>(
      row,
      conflictColumns: conflictColumns(SectionCheck.t),
      updateColumns: updateColumns?.call(SectionCheck.t),
      updateWhere: updateWhere?.call(SectionCheck.t),
      transaction: transaction,
    );
  }

  /// Updates all [SectionCheck]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SectionCheck>> update(
    _is.DatabaseSession session,
    List<SectionCheck> rows, {
    _is.ColumnSelections<SectionCheckTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SectionCheck>(
      rows,
      columns: columns?.call(SectionCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SectionCheck]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SectionCheck> updateRow(
    _is.DatabaseSession session,
    SectionCheck row, {
    _is.ColumnSelections<SectionCheckTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SectionCheck>(
      row,
      columns: columns?.call(SectionCheck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SectionCheck] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SectionCheck?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SectionCheckUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SectionCheck>(
      id,
      columnValues: columnValues(SectionCheck.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SectionCheck]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SectionCheck>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SectionCheckUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SectionCheckTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectionCheckTable>? orderBy,
    _is.OrderByListBuilder<SectionCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SectionCheck>(
      columnValues: columnValues(SectionCheck.t.updateTable),
      where: where(SectionCheck.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SectionCheck.t),
      orderByList: orderByList?.call(SectionCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SectionCheck]s in the list and returns the deleted rows.
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
  Future<List<SectionCheck>> delete(
    _is.DatabaseSession session,
    List<SectionCheck> rows, {
    _is.OrderByBuilder<SectionCheckTable>? orderBy,
    _is.OrderByListBuilder<SectionCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SectionCheck>(
      rows,
      orderBy: orderBy?.call(SectionCheck.t),
      orderByList: orderByList?.call(SectionCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SectionCheck].
  Future<SectionCheck> deleteRow(
    _is.DatabaseSession session,
    SectionCheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SectionCheck>(
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
  Future<List<SectionCheck>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SectionCheckTable> where,
    _is.OrderByBuilder<SectionCheckTable>? orderBy,
    _is.OrderByListBuilder<SectionCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SectionCheck>(
      where: where(SectionCheck.t),
      orderBy: orderBy?.call(SectionCheck.t),
      orderByList: orderByList?.call(SectionCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectionCheckTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SectionCheck>(
      where: where?.call(SectionCheck.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SectionCheck] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SectionCheckTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SectionCheck>(
      where: where(SectionCheck.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SectionCheckAttachRepository {
  const SectionCheckAttachRepository._();

  /// Creates a relation between this [SectionCheck] and the given [SectionFile]s
  /// by setting each [SectionFile]'s foreign key `checkId` to refer to this [SectionCheck].
  Future<void> files(
    _is.DatabaseSession session,
    SectionCheck sectionCheck,
    List<_i4rww364.SectionFile> sectionFile, {
    _is.Transaction? transaction,
  }) async {
    if (sectionFile.any((e) => e.id == null)) {
      throw ArgumentError.notNull('sectionFile.id');
    }
    if (sectionCheck.id == null) {
      throw ArgumentError.notNull('sectionCheck.id');
    }

    var $sectionFile = sectionFile
        .map((e) => e.copyWith(checkId: sectionCheck.id))
        .toList();
    await session.db.update<_i4rww364.SectionFile>(
      $sectionFile,
      columns: [_i4rww364.SectionFile.t.checkId],
      transaction: transaction,
    );
  }
}

class SectionCheckAttachRowRepository {
  const SectionCheckAttachRowRepository._();

  /// Creates a relation between this [SectionCheck] and the given [SectionFile]
  /// by setting the [SectionFile]'s foreign key `checkId` to refer to this [SectionCheck].
  Future<void> files(
    _is.DatabaseSession session,
    SectionCheck sectionCheck,
    _i4rww364.SectionFile sectionFile, {
    _is.Transaction? transaction,
  }) async {
    if (sectionFile.id == null) {
      throw ArgumentError.notNull('sectionFile.id');
    }
    if (sectionCheck.id == null) {
      throw ArgumentError.notNull('sectionCheck.id');
    }

    var $sectionFile = sectionFile.copyWith(checkId: sectionCheck.id);
    await session.db.updateRow<_i4rww364.SectionFile>(
      $sectionFile,
      columns: [_i4rww364.SectionFile.t.checkId],
      transaction: transaction,
    );
  }
}
