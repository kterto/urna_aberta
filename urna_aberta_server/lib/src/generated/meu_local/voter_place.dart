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

/// A signed-in viewer's own polling place, as they entered it. Deleted with
/// their account.
abstract class VoterPlace
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  VoterPlace._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.uf,
    required this.municipio,
    required this.municipioNome,
    this.zona,
    this.secao,
    required this.updatedAt,
  });

  factory VoterPlace({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String uf,
    required int municipio,
    required String municipioNome,
    int? zona,
    int? secao,
    required DateTime updatedAt,
  }) = _VoterPlaceImpl;

  factory VoterPlace.fromJson(Map<String, dynamic> jsonSerialization) {
    return VoterPlace(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _iyugoj1j.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      uf: jsonSerialization['uf'] as String,
      municipio: jsonSerialization['municipio'] as int,
      municipioNome: jsonSerialization['municipioNome'] as String,
      zona: jsonSerialization['zona'] as int?,
      secao: jsonSerialization['secao'] as int?,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = VoterPlaceTable();

  static const db = VoterPlaceRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  /// TSE's lowercase UF code ('zz' is abroad).
  String uf;

  /// TSE's 5-digit municipality code.
  int municipio;

  String municipioNome;

  int? zona;

  int? secao;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [VoterPlace]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VoterPlace copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? uf,
    int? municipio,
    String? municipioNome,
    int? zona,
    int? secao,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VoterPlace',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'uf': uf,
      'municipio': municipio,
      'municipioNome': municipioNome,
      if (zona != null) 'zona': zona,
      if (secao != null) 'secao': secao,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VoterPlace',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'uf': uf,
      'municipio': municipio,
      'municipioNome': municipioNome,
      if (zona != null) 'zona': zona,
      if (secao != null) 'secao': secao,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static VoterPlaceInclude include({_iacs.AuthUserInclude? authUser}) {
    return VoterPlaceInclude._(authUser: authUser);
  }

  static VoterPlaceIncludeList includeList({
    _is.WhereExpressionBuilder<VoterPlaceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoterPlaceTable>? orderBy,
    _is.OrderByListBuilder<VoterPlaceTable>? orderByList,
    VoterPlaceInclude? include,
  }) {
    return VoterPlaceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VoterPlace.t),
      orderByList: orderByList?.call(VoterPlace.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VoterPlaceImpl extends VoterPlace {
  _VoterPlaceImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String uf,
    required int municipio,
    required String municipioNome,
    int? zona,
    int? secao,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         uf: uf,
         municipio: municipio,
         municipioNome: municipioNome,
         zona: zona,
         secao: secao,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [VoterPlace]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VoterPlace copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? uf,
    int? municipio,
    String? municipioNome,
    Object? zona = _Undefined,
    Object? secao = _Undefined,
    DateTime? updatedAt,
  }) {
    return VoterPlace(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      uf: uf ?? this.uf,
      municipio: municipio ?? this.municipio,
      municipioNome: municipioNome ?? this.municipioNome,
      zona: zona is int? ? zona : this.zona,
      secao: secao is int? ? secao : this.secao,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class VoterPlaceUpdateTable extends _is.UpdateTable<VoterPlaceTable> {
  VoterPlaceUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
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

  _is.ColumnValue<String, String> municipioNome(String value) =>
      _is.ColumnValue(
        table.municipioNome,
        value,
      );

  _is.ColumnValue<int, int> zona(int? value) => _is.ColumnValue(
    table.zona,
    value,
  );

  _is.ColumnValue<int, int> secao(int? value) => _is.ColumnValue(
    table.secao,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class VoterPlaceTable extends _is.Table<int?> {
  VoterPlaceTable({super.tableRelation}) : super(tableName: 'voter_place') {
    updateTable = VoterPlaceUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
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
    municipioNome = _is.ColumnString(
      'municipioNome',
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
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final VoterPlaceUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  /// TSE's lowercase UF code ('zz' is abroad).
  late final _is.ColumnString uf;

  /// TSE's 5-digit municipality code.
  late final _is.ColumnInt municipio;

  late final _is.ColumnString municipioNome;

  late final _is.ColumnInt zona;

  late final _is.ColumnInt secao;

  late final _is.ColumnDateTime updatedAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: VoterPlace.t.authUserId,
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
    uf,
    municipio,
    municipioNome,
    zona,
    secao,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class VoterPlaceInclude extends _is.IncludeObject {
  VoterPlaceInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => VoterPlace.t;
}

class VoterPlaceIncludeList extends _is.IncludeList {
  VoterPlaceIncludeList._({
    _is.WhereExpressionBuilder<VoterPlaceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VoterPlace.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => VoterPlace.t;
}

class VoterPlaceRepository {
  const VoterPlaceRepository._();

  final attachRow = const VoterPlaceAttachRowRepository._();

  /// Returns a list of [VoterPlace]s matching the given query parameters.
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
  Future<List<VoterPlace>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoterPlaceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoterPlaceTable>? orderBy,
    _is.OrderByListBuilder<VoterPlaceTable>? orderByList,
    _is.Transaction? transaction,
    VoterPlaceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VoterPlace>(
      where: where?.call(VoterPlace.t),
      orderBy: orderBy?.call(VoterPlace.t),
      orderByList: orderByList?.call(VoterPlace.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VoterPlace] matching the given query parameters.
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
  Future<VoterPlace?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoterPlaceTable>? where,
    int? offset,
    _is.OrderByBuilder<VoterPlaceTable>? orderBy,
    _is.OrderByListBuilder<VoterPlaceTable>? orderByList,
    _is.Transaction? transaction,
    VoterPlaceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VoterPlace>(
      where: where?.call(VoterPlace.t),
      orderBy: orderBy?.call(VoterPlace.t),
      orderByList: orderByList?.call(VoterPlace.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VoterPlace] by its [id] or null if no such row exists.
  Future<VoterPlace?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    VoterPlaceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VoterPlace>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VoterPlace]s in the list and returns the inserted rows.
  ///
  /// The returned [VoterPlace]s will have their `id` fields set.
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
  Future<List<VoterPlace>> insert(
    _is.DatabaseSession session,
    List<VoterPlace> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<VoterPlace>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [VoterPlace] and returns the inserted row.
  ///
  /// The returned [VoterPlace] will have its `id` field set.
  Future<VoterPlace> insertRow(
    _is.DatabaseSession session,
    VoterPlace row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<VoterPlace>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [VoterPlace]s in the list and returns the resulting rows.
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
  /// The returned [VoterPlace]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<VoterPlace>> upsert(
    _is.DatabaseSession session,
    List<VoterPlace> rows, {
    required _is.ColumnSelections<VoterPlaceTable> conflictColumns,
    _is.ColumnSelections<VoterPlaceTable>? updateColumns,
    _is.WhereExpressionBuilder<VoterPlaceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<VoterPlace>(
      rows,
      conflictColumns: conflictColumns(VoterPlace.t),
      updateColumns: updateColumns?.call(VoterPlace.t),
      updateWhere: updateWhere?.call(VoterPlace.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [VoterPlace] and returns the resulting row.
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
  /// The returned [VoterPlace] will have its `id` field set.
  Future<VoterPlace?> upsertRow(
    _is.DatabaseSession session,
    VoterPlace row, {
    required _is.ColumnSelections<VoterPlaceTable> conflictColumns,
    _is.ColumnSelections<VoterPlaceTable>? updateColumns,
    _is.WhereExpressionBuilder<VoterPlaceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<VoterPlace>(
      row,
      conflictColumns: conflictColumns(VoterPlace.t),
      updateColumns: updateColumns?.call(VoterPlace.t),
      updateWhere: updateWhere?.call(VoterPlace.t),
      transaction: transaction,
    );
  }

  /// Updates all [VoterPlace]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<VoterPlace>> update(
    _is.DatabaseSession session,
    List<VoterPlace> rows, {
    _is.ColumnSelections<VoterPlaceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<VoterPlace>(
      rows,
      columns: columns?.call(VoterPlace.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [VoterPlace]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VoterPlace> updateRow(
    _is.DatabaseSession session,
    VoterPlace row, {
    _is.ColumnSelections<VoterPlaceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<VoterPlace>(
      row,
      columns: columns?.call(VoterPlace.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VoterPlace] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VoterPlace?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<VoterPlaceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<VoterPlace>(
      id,
      columnValues: columnValues(VoterPlace.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VoterPlace]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<VoterPlace>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<VoterPlaceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<VoterPlaceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoterPlaceTable>? orderBy,
    _is.OrderByListBuilder<VoterPlaceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<VoterPlace>(
      columnValues: columnValues(VoterPlace.t.updateTable),
      where: where(VoterPlace.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VoterPlace.t),
      orderByList: orderByList?.call(VoterPlace.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [VoterPlace]s in the list and returns the deleted rows.
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
  Future<List<VoterPlace>> delete(
    _is.DatabaseSession session,
    List<VoterPlace> rows, {
    _is.OrderByBuilder<VoterPlaceTable>? orderBy,
    _is.OrderByListBuilder<VoterPlaceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<VoterPlace>(
      rows,
      orderBy: orderBy?.call(VoterPlace.t),
      orderByList: orderByList?.call(VoterPlace.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [VoterPlace].
  Future<VoterPlace> deleteRow(
    _is.DatabaseSession session,
    VoterPlace row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VoterPlace>(
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
  Future<List<VoterPlace>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VoterPlaceTable> where,
    _is.OrderByBuilder<VoterPlaceTable>? orderBy,
    _is.OrderByListBuilder<VoterPlaceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<VoterPlace>(
      where: where(VoterPlace.t),
      orderBy: orderBy?.call(VoterPlace.t),
      orderByList: orderByList?.call(VoterPlace.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoterPlaceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<VoterPlace>(
      where: where?.call(VoterPlace.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VoterPlace] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VoterPlaceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VoterPlace>(
      where: where(VoterPlace.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class VoterPlaceAttachRowRepository {
  const VoterPlaceAttachRowRepository._();

  /// Creates a relation between the given [VoterPlace] and [AuthUser]
  /// by setting the [VoterPlace]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    VoterPlace voterPlace,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (voterPlace.id == null) {
      throw ArgumentError.notNull('voterPlace.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $voterPlace = voterPlace.copyWith(authUserId: authUser.id);
    await session.db.updateRow<VoterPlace>(
      $voterPlace,
      columns: [VoterPlace.t.authUserId],
      transaction: transaction,
    );
  }
}
