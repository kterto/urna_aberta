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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:urna_aberta_server/src/generated/protocol.dart' as _iyugoj1j;
import 'section_check.dart' as _i1fk3nml;

/// A raw TSE file stored exactly as fetched.
abstract class SectionFile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SectionFile._({
    this.id,
    required this.checkId,
    this.check,
    required this.kind,
    required this.name,
    required this.url,
    required this.sha256,
    required this.content,
    this.receivedAt,
  });

  factory SectionFile({
    int? id,
    required int checkId,
    _i1fk3nml.SectionCheck? check,
    required String kind,
    required String name,
    required String url,
    required String sha256,
    required _idt.ByteData content,
    DateTime? receivedAt,
  }) = _SectionFileImpl;

  factory SectionFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return SectionFile(
      id: jsonSerialization['id'] as int?,
      checkId: jsonSerialization['checkId'] as int,
      check: jsonSerialization['check'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<_i1fk3nml.SectionCheck>(
              jsonSerialization['check'],
            ),
      kind: jsonSerialization['kind'] as String,
      name: jsonSerialization['name'] as String,
      url: jsonSerialization['url'] as String,
      sha256: jsonSerialization['sha256'] as String,
      content: _is.ByteDataJsonExtension.fromJson(jsonSerialization['content']),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
    );
  }

  static final t = SectionFileTable();

  static const db = SectionFileRepository._();

  @override
  int? id;

  int checkId;

  _i1fk3nml.SectionCheck? check;

  /// aux, bu or vota.
  String kind;

  String name;

  String url;

  String sha256;

  _idt.ByteData content;

  /// When TSE received the urna files (UTC); null for the aux file.
  DateTime? receivedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SectionFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SectionFile copyWith({
    int? id,
    int? checkId,
    _i1fk3nml.SectionCheck? check,
    String? kind,
    String? name,
    String? url,
    String? sha256,
    _idt.ByteData? content,
    DateTime? receivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SectionFile',
      if (id != null) 'id': id,
      'checkId': checkId,
      if (check != null) 'check': check?.toJson(),
      'kind': kind,
      'name': name,
      'url': url,
      'sha256': sha256,
      'content': content.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SectionFile',
      if (id != null) 'id': id,
      'checkId': checkId,
      if (check != null) 'check': check?.toJsonForProtocol(),
      'kind': kind,
      'name': name,
      'url': url,
      'sha256': sha256,
      'content': content.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
    };
  }

  static SectionFileInclude include({_i1fk3nml.SectionCheckInclude? check}) {
    return SectionFileInclude._(check: check);
  }

  static SectionFileIncludeList includeList({
    _is.WhereExpressionBuilder<SectionFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectionFileTable>? orderBy,
    _is.OrderByListBuilder<SectionFileTable>? orderByList,
    SectionFileInclude? include,
  }) {
    return SectionFileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SectionFile.t),
      orderByList: orderByList?.call(SectionFile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectionFileImpl extends SectionFile {
  _SectionFileImpl({
    int? id,
    required int checkId,
    _i1fk3nml.SectionCheck? check,
    required String kind,
    required String name,
    required String url,
    required String sha256,
    required _idt.ByteData content,
    DateTime? receivedAt,
  }) : super._(
         id: id,
         checkId: checkId,
         check: check,
         kind: kind,
         name: name,
         url: url,
         sha256: sha256,
         content: content,
         receivedAt: receivedAt,
       );

  /// Returns a shallow copy of this [SectionFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SectionFile copyWith({
    Object? id = _Undefined,
    int? checkId,
    Object? check = _Undefined,
    String? kind,
    String? name,
    String? url,
    String? sha256,
    _idt.ByteData? content,
    Object? receivedAt = _Undefined,
  }) {
    return SectionFile(
      id: id is int? ? id : this.id,
      checkId: checkId ?? this.checkId,
      check: check is _i1fk3nml.SectionCheck? ? check : this.check?.copyWith(),
      kind: kind ?? this.kind,
      name: name ?? this.name,
      url: url ?? this.url,
      sha256: sha256 ?? this.sha256,
      content: content ?? this.content.clone(),
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
    );
  }
}

class SectionFileUpdateTable extends _is.UpdateTable<SectionFileTable> {
  SectionFileUpdateTable(super.table);

  _is.ColumnValue<int, int> checkId(int value) => _is.ColumnValue(
    table.checkId,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> url(String value) => _is.ColumnValue(
    table.url,
    value,
  );

  _is.ColumnValue<String, String> sha256(String value) => _is.ColumnValue(
    table.sha256,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> content(_idt.ByteData value) =>
      _is.ColumnValue(
        table.content,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime? value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );
}

class SectionFileTable extends _is.Table<int?> {
  SectionFileTable({super.tableRelation}) : super(tableName: 'section_file') {
    updateTable = SectionFileUpdateTable(this);
    checkId = _is.ColumnInt(
      'checkId',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    url = _is.ColumnString(
      'url',
      this,
    );
    sha256 = _is.ColumnString(
      'sha256',
      this,
    );
    content = _is.ColumnByteData(
      'content',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
    );
  }

  late final SectionFileUpdateTable updateTable;

  late final _is.ColumnInt checkId;

  _i1fk3nml.SectionCheckTable? _check;

  /// aux, bu or vota.
  late final _is.ColumnString kind;

  late final _is.ColumnString name;

  late final _is.ColumnString url;

  late final _is.ColumnString sha256;

  late final _is.ColumnByteData content;

  /// When TSE received the urna files (UTC); null for the aux file.
  late final _is.ColumnDateTime receivedAt;

  _i1fk3nml.SectionCheckTable get check {
    if (_check != null) return _check!;
    _check = _is.createRelationTable(
      relationFieldName: 'check',
      field: SectionFile.t.checkId,
      foreignField: _i1fk3nml.SectionCheck.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i1fk3nml.SectionCheckTable(tableRelation: foreignTableRelation),
    );
    return _check!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    checkId,
    kind,
    name,
    url,
    sha256,
    content,
    receivedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'check') {
      return check;
    }
    return null;
  }
}

class SectionFileInclude extends _is.IncludeObject {
  SectionFileInclude._({_i1fk3nml.SectionCheckInclude? check}) {
    _check = check;
  }

  _i1fk3nml.SectionCheckInclude? _check;

  @override
  Map<String, _is.Include?> get includes => {'check': _check};

  @override
  _is.Table<int?> get table => SectionFile.t;
}

class SectionFileIncludeList extends _is.IncludeList {
  SectionFileIncludeList._({
    _is.WhereExpressionBuilder<SectionFileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SectionFile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SectionFile.t;
}

class SectionFileRepository {
  const SectionFileRepository._();

  final attachRow = const SectionFileAttachRowRepository._();

  /// Returns a list of [SectionFile]s matching the given query parameters.
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
  Future<List<SectionFile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectionFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectionFileTable>? orderBy,
    _is.OrderByListBuilder<SectionFileTable>? orderByList,
    _is.Transaction? transaction,
    SectionFileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SectionFile>(
      where: where?.call(SectionFile.t),
      orderBy: orderBy?.call(SectionFile.t),
      orderByList: orderByList?.call(SectionFile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SectionFile] matching the given query parameters.
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
  Future<SectionFile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectionFileTable>? where,
    int? offset,
    _is.OrderByBuilder<SectionFileTable>? orderBy,
    _is.OrderByListBuilder<SectionFileTable>? orderByList,
    _is.Transaction? transaction,
    SectionFileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SectionFile>(
      where: where?.call(SectionFile.t),
      orderBy: orderBy?.call(SectionFile.t),
      orderByList: orderByList?.call(SectionFile.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SectionFile] by its [id] or null if no such row exists.
  Future<SectionFile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SectionFileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SectionFile>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SectionFile]s in the list and returns the inserted rows.
  ///
  /// The returned [SectionFile]s will have their `id` fields set.
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
  Future<List<SectionFile>> insert(
    _is.DatabaseSession session,
    List<SectionFile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SectionFile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SectionFile] and returns the inserted row.
  ///
  /// The returned [SectionFile] will have its `id` field set.
  Future<SectionFile> insertRow(
    _is.DatabaseSession session,
    SectionFile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SectionFile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SectionFile]s in the list and returns the resulting rows.
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
  /// The returned [SectionFile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SectionFile>> upsert(
    _is.DatabaseSession session,
    List<SectionFile> rows, {
    required _is.ColumnSelections<SectionFileTable> conflictColumns,
    _is.ColumnSelections<SectionFileTable>? updateColumns,
    _is.WhereExpressionBuilder<SectionFileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SectionFile>(
      rows,
      conflictColumns: conflictColumns(SectionFile.t),
      updateColumns: updateColumns?.call(SectionFile.t),
      updateWhere: updateWhere?.call(SectionFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SectionFile] and returns the resulting row.
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
  /// The returned [SectionFile] will have its `id` field set.
  Future<SectionFile?> upsertRow(
    _is.DatabaseSession session,
    SectionFile row, {
    required _is.ColumnSelections<SectionFileTable> conflictColumns,
    _is.ColumnSelections<SectionFileTable>? updateColumns,
    _is.WhereExpressionBuilder<SectionFileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SectionFile>(
      row,
      conflictColumns: conflictColumns(SectionFile.t),
      updateColumns: updateColumns?.call(SectionFile.t),
      updateWhere: updateWhere?.call(SectionFile.t),
      transaction: transaction,
    );
  }

  /// Updates all [SectionFile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SectionFile>> update(
    _is.DatabaseSession session,
    List<SectionFile> rows, {
    _is.ColumnSelections<SectionFileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SectionFile>(
      rows,
      columns: columns?.call(SectionFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SectionFile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SectionFile> updateRow(
    _is.DatabaseSession session,
    SectionFile row, {
    _is.ColumnSelections<SectionFileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SectionFile>(
      row,
      columns: columns?.call(SectionFile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SectionFile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SectionFile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SectionFileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SectionFile>(
      id,
      columnValues: columnValues(SectionFile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SectionFile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SectionFile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SectionFileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SectionFileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectionFileTable>? orderBy,
    _is.OrderByListBuilder<SectionFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SectionFile>(
      columnValues: columnValues(SectionFile.t.updateTable),
      where: where(SectionFile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SectionFile.t),
      orderByList: orderByList?.call(SectionFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SectionFile]s in the list and returns the deleted rows.
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
  Future<List<SectionFile>> delete(
    _is.DatabaseSession session,
    List<SectionFile> rows, {
    _is.OrderByBuilder<SectionFileTable>? orderBy,
    _is.OrderByListBuilder<SectionFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SectionFile>(
      rows,
      orderBy: orderBy?.call(SectionFile.t),
      orderByList: orderByList?.call(SectionFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SectionFile].
  Future<SectionFile> deleteRow(
    _is.DatabaseSession session,
    SectionFile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SectionFile>(
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
  Future<List<SectionFile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SectionFileTable> where,
    _is.OrderByBuilder<SectionFileTable>? orderBy,
    _is.OrderByListBuilder<SectionFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SectionFile>(
      where: where(SectionFile.t),
      orderBy: orderBy?.call(SectionFile.t),
      orderByList: orderByList?.call(SectionFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectionFileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SectionFile>(
      where: where?.call(SectionFile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SectionFile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SectionFileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SectionFile>(
      where: where(SectionFile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SectionFileAttachRowRepository {
  const SectionFileAttachRowRepository._();

  /// Creates a relation between the given [SectionFile] and [SectionCheck]
  /// by setting the [SectionFile]'s foreign key `checkId` to refer to the [SectionCheck].
  Future<void> check(
    _is.DatabaseSession session,
    SectionFile sectionFile,
    _i1fk3nml.SectionCheck check, {
    _is.Transaction? transaction,
  }) async {
    if (sectionFile.id == null) {
      throw ArgumentError.notNull('sectionFile.id');
    }
    if (check.id == null) {
      throw ArgumentError.notNull('check.id');
    }

    var $sectionFile = sectionFile.copyWith(checkId: check.id);
    await session.db.updateRow<SectionFile>(
      $sectionFile,
      columns: [SectionFile.t.checkId],
      transaction: transaction,
    );
  }
}
