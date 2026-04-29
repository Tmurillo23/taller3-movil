// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MoodsTable extends Moods with TableInfo<$MoodsTable, Mood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emocionMeta = const VerificationMeta(
    'emocion',
  );
  @override
  late final GeneratedColumn<String> emocion = GeneratedColumn<String>(
    'emocion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    emocion,
    nota,
    fechaCreacion,
    pendingSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mood> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('emocion')) {
      context.handle(
        _emocionMeta,
        emocion.isAcceptableOrUnknown(data['emocion']!, _emocionMeta),
      );
    } else if (isInserting) {
      context.missing(_emocionMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mood(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      emocion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emocion'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
    );
  }

  @override
  $MoodsTable createAlias(String alias) {
    return $MoodsTable(attachedDatabase, alias);
  }
}

class Mood extends DataClass implements Insertable<Mood> {
  final int id;
  final String nombre;
  final String emocion;
  final String? nota;
  final DateTime fechaCreacion;
  final bool pendingSync;
  const Mood({
    required this.id,
    required this.nombre,
    required this.emocion,
    this.nota,
    required this.fechaCreacion,
    required this.pendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['emocion'] = Variable<String>(emocion);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  MoodsCompanion toCompanion(bool nullToAbsent) {
    return MoodsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      emocion: Value(emocion),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      fechaCreacion: Value(fechaCreacion),
      pendingSync: Value(pendingSync),
    );
  }

  factory Mood.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mood(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      emocion: serializer.fromJson<String>(json['emocion']),
      nota: serializer.fromJson<String?>(json['nota']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'emocion': serializer.toJson<String>(emocion),
      'nota': serializer.toJson<String?>(nota),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  Mood copyWith({
    int? id,
    String? nombre,
    String? emocion,
    Value<String?> nota = const Value.absent(),
    DateTime? fechaCreacion,
    bool? pendingSync,
  }) => Mood(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    emocion: emocion ?? this.emocion,
    nota: nota.present ? nota.value : this.nota,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    pendingSync: pendingSync ?? this.pendingSync,
  );
  Mood copyWithCompanion(MoodsCompanion data) {
    return Mood(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      emocion: data.emocion.present ? data.emocion.value : this.emocion,
      nota: data.nota.present ? data.nota.value : this.nota,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mood(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('emocion: $emocion, ')
          ..write('nota: $nota, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, emocion, nota, fechaCreacion, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mood &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.emocion == this.emocion &&
          other.nota == this.nota &&
          other.fechaCreacion == this.fechaCreacion &&
          other.pendingSync == this.pendingSync);
}

class MoodsCompanion extends UpdateCompanion<Mood> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> emocion;
  final Value<String?> nota;
  final Value<DateTime> fechaCreacion;
  final Value<bool> pendingSync;
  const MoodsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.emocion = const Value.absent(),
    this.nota = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.pendingSync = const Value.absent(),
  });
  MoodsCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String emocion,
    this.nota = const Value.absent(),
    required DateTime fechaCreacion,
    this.pendingSync = const Value.absent(),
  }) : nombre = Value(nombre),
       emocion = Value(emocion),
       fechaCreacion = Value(fechaCreacion);
  static Insertable<Mood> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? emocion,
    Expression<String>? nota,
    Expression<DateTime>? fechaCreacion,
    Expression<bool>? pendingSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (emocion != null) 'emocion': emocion,
      if (nota != null) 'nota': nota,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (pendingSync != null) 'pending_sync': pendingSync,
    });
  }

  MoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? emocion,
    Value<String?>? nota,
    Value<DateTime>? fechaCreacion,
    Value<bool>? pendingSync,
  }) {
    return MoodsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      emocion: emocion ?? this.emocion,
      nota: nota ?? this.nota,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (emocion.present) {
      map['emocion'] = Variable<String>(emocion.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('emocion: $emocion, ')
          ..write('nota: $nota, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoodsTable moods = $MoodsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [moods];
}

typedef $$MoodsTableCreateCompanionBuilder =
    MoodsCompanion Function({
      Value<int> id,
      required String nombre,
      required String emocion,
      Value<String?> nota,
      required DateTime fechaCreacion,
      Value<bool> pendingSync,
    });
typedef $$MoodsTableUpdateCompanionBuilder =
    MoodsCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> emocion,
      Value<String?> nota,
      Value<DateTime> fechaCreacion,
      Value<bool> pendingSync,
    });

class $$MoodsTableFilterComposer extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emocion => $composableBuilder(
    column: $table.emocion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emocion => $composableBuilder(
    column: $table.emocion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get emocion =>
      $composableBuilder(column: $table.emocion, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );
}

class $$MoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodsTable,
          Mood,
          $$MoodsTableFilterComposer,
          $$MoodsTableOrderingComposer,
          $$MoodsTableAnnotationComposer,
          $$MoodsTableCreateCompanionBuilder,
          $$MoodsTableUpdateCompanionBuilder,
          (Mood, BaseReferences<_$AppDatabase, $MoodsTable, Mood>),
          Mood,
          PrefetchHooks Function()
        > {
  $$MoodsTableTableManager(_$AppDatabase db, $MoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> emocion = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
              }) => MoodsCompanion(
                id: id,
                nombre: nombre,
                emocion: emocion,
                nota: nota,
                fechaCreacion: fechaCreacion,
                pendingSync: pendingSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String emocion,
                Value<String?> nota = const Value.absent(),
                required DateTime fechaCreacion,
                Value<bool> pendingSync = const Value.absent(),
              }) => MoodsCompanion.insert(
                id: id,
                nombre: nombre,
                emocion: emocion,
                nota: nota,
                fechaCreacion: fechaCreacion,
                pendingSync: pendingSync,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodsTable,
      Mood,
      $$MoodsTableFilterComposer,
      $$MoodsTableOrderingComposer,
      $$MoodsTableAnnotationComposer,
      $$MoodsTableCreateCompanionBuilder,
      $$MoodsTableUpdateCompanionBuilder,
      (Mood, BaseReferences<_$AppDatabase, $MoodsTable, Mood>),
      Mood,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoodsTableTableManager get moods =>
      $$MoodsTableTableManager(_db, _db.moods);
}
