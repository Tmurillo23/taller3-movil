import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/inventario_model.dart';

part 'app_database.g.dart';

class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreProducto => text()();
  IntColumn get stock => integer()();
  TextColumn get categoria => text()();
  DateTimeColumn get fechaRestock => dateTime()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Productos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mood_app_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  ProductoModel _mapProductoToModel(Producto row) {
    return ProductoModel(
      id: row.id,
      nombreProducto: row.nombreProducto,
      stock: row.stock,
      categoria: row.categoria,
      fechaRestock: row.fechaRestock,
      pendingSync: row.pendingSync,
    );
  }

  Stream<List<ProductoModel>> watchProductos() {
    final query = select(productos)
      ..orderBy([
        (p) => OrderingTerm.desc(p.fechaRestock),
      ]);

    return query.watch().map(
      (rows) => rows.map(_mapProductoToModel).toList(),
    );
  }

  Future<List<ProductoModel>> getAllProductos() async {
    final rows = await select(productos).get();
    return rows.map(_mapProductoToModel).toList();
  }

  Future<ProductoModel> insertProducto(ProductoModel producto) async {
    final insertedId = await into(productos).insert(
      ProductosCompanion.insert(
        nombreProducto: producto.nombreProducto,
        stock: producto.stock,
        categoria: producto.categoria,
        fechaRestock: producto.fechaRestock,
        pendingSync: Value(producto.pendingSync),
      ),
    );

    return producto.copyWith(id: insertedId);
  }

  Future<void> updateProducto(ProductoModel producto) async {
    if (producto.id == null) return;

    await update(productos).replace(
      Producto(
        id: producto.id!,
        nombreProducto: producto.nombreProducto,
        stock: producto.stock,
        categoria: producto.categoria,
        fechaRestock: producto.fechaRestock,
        pendingSync: producto.pendingSync,
      ),
    );
  }

  Future<void> deleteProducto(int id) async {
    await (delete(productos)..where((p) => p.id.equals(id))).go();
  }

  Future<List<ProductoModel>> getPendingProductos() async {
    final rows = await (select(productos)..where((p) => p.pendingSync.equals(true))).get();
    return rows.map(_mapProductoToModel).toList();
  }

  Future<void> markAsSynced(int id) async {
    await (update(productos)..where((p) => p.id.equals(id))).write(
      const ProductosCompanion(
        pendingSync: Value(false),
      ),
    );
  }

  Future<void> upsertFromRemote(ProductoModel producto) async {
    if (producto.id == null) return;

    await into(productos).insertOnConflictUpdate(
      ProductosCompanion(
        id: Value(producto.id!),
        nombreProducto: Value(producto.nombreProducto),
        stock: Value(producto.stock),
        categoria: Value(producto.categoria),
        fechaRestock: Value(producto.fechaRestock),
        pendingSync: const Value(false),
      ),
    );
  }
}