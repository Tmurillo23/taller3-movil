// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nombreProductoMeta = const VerificationMeta(
    'nombreProducto',
  );
  @override
  late final GeneratedColumn<String> nombreProducto = GeneratedColumn<String>(
    'nombre_producto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaRestockMeta = const VerificationMeta(
    'fechaRestock',
  );
  @override
  late final GeneratedColumn<DateTime> fechaRestock = GeneratedColumn<DateTime>(
    'fecha_restock',
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
    nombreProducto,
    stock,
    categoria,
    fechaRestock,
    pendingSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_producto')) {
      context.handle(
        _nombreProductoMeta,
        nombreProducto.isAcceptableOrUnknown(
          data['nombre_producto']!,
          _nombreProductoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreProductoMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('fecha_restock')) {
      context.handle(
        _fechaRestockMeta,
        fechaRestock.isAcceptableOrUnknown(
          data['fecha_restock']!,
          _fechaRestockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaRestockMeta);
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
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombreProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_producto'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      fechaRestock: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_restock'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final String nombreProducto;
  final int stock;
  final String categoria;
  final DateTime fechaRestock;
  final bool pendingSync;
  const Producto({
    required this.id,
    required this.nombreProducto,
    required this.stock,
    required this.categoria,
    required this.fechaRestock,
    required this.pendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_producto'] = Variable<String>(nombreProducto);
    map['stock'] = Variable<int>(stock);
    map['categoria'] = Variable<String>(categoria);
    map['fecha_restock'] = Variable<DateTime>(fechaRestock);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombreProducto: Value(nombreProducto),
      stock: Value(stock),
      categoria: Value(categoria),
      fechaRestock: Value(fechaRestock),
      pendingSync: Value(pendingSync),
    );
  }

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      nombreProducto: serializer.fromJson<String>(json['nombreProducto']),
      stock: serializer.fromJson<int>(json['stock']),
      categoria: serializer.fromJson<String>(json['categoria']),
      fechaRestock: serializer.fromJson<DateTime>(json['fechaRestock']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreProducto': serializer.toJson<String>(nombreProducto),
      'stock': serializer.toJson<int>(stock),
      'categoria': serializer.toJson<String>(categoria),
      'fechaRestock': serializer.toJson<DateTime>(fechaRestock),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  Producto copyWith({
    int? id,
    String? nombreProducto,
    int? stock,
    String? categoria,
    DateTime? fechaRestock,
    bool? pendingSync,
  }) => Producto(
    id: id ?? this.id,
    nombreProducto: nombreProducto ?? this.nombreProducto,
    stock: stock ?? this.stock,
    categoria: categoria ?? this.categoria,
    fechaRestock: fechaRestock ?? this.fechaRestock,
    pendingSync: pendingSync ?? this.pendingSync,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      nombreProducto: data.nombreProducto.present
          ? data.nombreProducto.value
          : this.nombreProducto,
      stock: data.stock.present ? data.stock.value : this.stock,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      fechaRestock: data.fechaRestock.present
          ? data.fechaRestock.value
          : this.fechaRestock,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('stock: $stock, ')
          ..write('categoria: $categoria, ')
          ..write('fechaRestock: $fechaRestock, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreProducto,
    stock,
    categoria,
    fechaRestock,
    pendingSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.nombreProducto == this.nombreProducto &&
          other.stock == this.stock &&
          other.categoria == this.categoria &&
          other.fechaRestock == this.fechaRestock &&
          other.pendingSync == this.pendingSync);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<String> nombreProducto;
  final Value<int> stock;
  final Value<String> categoria;
  final Value<DateTime> fechaRestock;
  final Value<bool> pendingSync;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombreProducto = const Value.absent(),
    this.stock = const Value.absent(),
    this.categoria = const Value.absent(),
    this.fechaRestock = const Value.absent(),
    this.pendingSync = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required String nombreProducto,
    required int stock,
    required String categoria,
    required DateTime fechaRestock,
    this.pendingSync = const Value.absent(),
  }) : nombreProducto = Value(nombreProducto),
       stock = Value(stock),
       categoria = Value(categoria),
       fechaRestock = Value(fechaRestock);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<String>? nombreProducto,
    Expression<int>? stock,
    Expression<String>? categoria,
    Expression<DateTime>? fechaRestock,
    Expression<bool>? pendingSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreProducto != null) 'nombre_producto': nombreProducto,
      if (stock != null) 'stock': stock,
      if (categoria != null) 'categoria': categoria,
      if (fechaRestock != null) 'fecha_restock': fechaRestock,
      if (pendingSync != null) 'pending_sync': pendingSync,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombreProducto,
    Value<int>? stock,
    Value<String>? categoria,
    Value<DateTime>? fechaRestock,
    Value<bool>? pendingSync,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
      fechaRestock: fechaRestock ?? this.fechaRestock,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreProducto.present) {
      map['nombre_producto'] = Variable<String>(nombreProducto.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (fechaRestock.present) {
      map['fecha_restock'] = Variable<DateTime>(fechaRestock.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('stock: $stock, ')
          ..write('categoria: $categoria, ')
          ..write('fechaRestock: $fechaRestock, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosTable productos = $ProductosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [productos];
}

typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      required String nombreProducto,
      required int stock,
      required String categoria,
      required DateTime fechaRestock,
      Value<bool> pendingSync,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      Value<String> nombreProducto,
      Value<int> stock,
      Value<String> categoria,
      Value<DateTime> fechaRestock,
      Value<bool> pendingSync,
    });

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
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

  ColumnFilters<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaRestock => $composableBuilder(
    column: $table.fechaRestock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
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

  ColumnOrderings<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaRestock => $composableBuilder(
    column: $table.fechaRestock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaRestock => $composableBuilder(
    column: $table.fechaRestock,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
          Producto,
          PrefetchHooks Function()
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreProducto = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<DateTime> fechaRestock = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombreProducto: nombreProducto,
                stock: stock,
                categoria: categoria,
                fechaRestock: fechaRestock,
                pendingSync: pendingSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombreProducto,
                required int stock,
                required String categoria,
                required DateTime fechaRestock,
                Value<bool> pendingSync = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombreProducto: nombreProducto,
                stock: stock,
                categoria: categoria,
                fechaRestock: fechaRestock,
                pendingSync: pendingSync,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
      Producto,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
}
