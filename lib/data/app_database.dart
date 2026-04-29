import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/mood_model.dart';

part 'app_database.g.dart';

class Moods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get emocion => text()();
  TextColumn get nota => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Moods])
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

  MoodModel _mapMoodToModel(Mood row) {
    return MoodModel(
      id: row.id,
      nombre: row.nombre,
      emocion: row.emocion,
      nota: row.nota,
      fechaCreacion: row.fechaCreacion,
      pendingSync: row.pendingSync,
    );
  }

  Stream<List<MoodModel>> watchMoods() {
    final query = select(moods)
      ..orderBy([
        (m) => OrderingTerm.desc(m.fechaCreacion),
      ]);

    return query.watch().map(
      (rows) => rows.map(_mapMoodToModel).toList(),
    );
  }

  Future<List<MoodModel>> getAllMoods() async {
    final rows = await select(moods).get();
    return rows.map(_mapMoodToModel).toList();
  }

  Future<MoodModel> insertMood(MoodModel mood) async {
    final insertedId = await into(moods).insert(
      MoodsCompanion.insert(
        nombre: mood.nombre,
        emocion: mood.emocion,
        nota: Value(mood.nota),
        fechaCreacion: mood.fechaCreacion,
        pendingSync: Value(mood.pendingSync),
      ),
    );

    return mood.copyWith(id: insertedId);
  }

  Future<void> updateMood(MoodModel mood) async {
    if (mood.id == null) return;

    await update(moods).replace(
      Mood(
        id: mood.id!,
        nombre: mood.nombre,
        emocion: mood.emocion,
        nota: mood.nota,
        fechaCreacion: mood.fechaCreacion,
        pendingSync: mood.pendingSync,
      ),
    );
  }

  Future<void> deleteMood(int id) async {
    await (delete(moods)..where((m) => m.id.equals(id))).go();
  }

  Future<List<MoodModel>> getPendingMoods() async {
    final rows = await (select(moods)..where((m) => m.pendingSync.equals(true))).get();
    return rows.map(_mapMoodToModel).toList();
  }

  Future<void> markAsSynced(int id) async {
    await (update(moods)..where((m) => m.id.equals(id))).write(
      const MoodsCompanion(
        pendingSync: Value(false),
      ),
    );
  }

  Future<void> upsertFromRemote(MoodModel mood) async {
    if (mood.id == null) return;

    await into(moods).insertOnConflictUpdate(
      MoodsCompanion(
        id: Value(mood.id!),
        nombre: Value(mood.nombre),
        emocion: Value(mood.emocion),
        nota: Value(mood.nota),
        fechaCreacion: Value(mood.fechaCreacion),
        pendingSync: const Value(false),
      ),
    );
  }
}