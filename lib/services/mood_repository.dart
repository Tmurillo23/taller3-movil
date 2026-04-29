import '../data/app_database.dart';
import '../models/mood_model.dart';
import 'app_logger.dart';
import 'mood_remote_service.dart';

class MoodRepository {
  final AppDatabase localDb;
  final MoodRemoteService remoteService;

  MoodRepository({required this.localDb, required this.remoteService});

  Stream<List<MoodModel>> watchMoods() {
    AppLogger.debug('Escuchando estados de ánimo desde Drift');
    return localDb.watchMoods();
  }

  Future<void> loadInitialData() async {
    AppLogger.info('Cargando datos iniciales');
    await refreshFromRemote();
    await syncPendingMoods();
  }

  Future<void> addMood({
    required String nombre,
    required String emocion,
    String? nota,
  }) async {
    AppLogger.info('Creando nuevo estado de ánimo local');
    final localMood = MoodModel(
      nombre: nombre,
      emocion: emocion,
      nota: nota,
      fechaCreacion: DateTime.now(),
      pendingSync: true,
    );
    final inserted = await localDb.insertMood(localMood);
    AppLogger.info('Estado de ánimo creado localmente con id: ${inserted.id}');

    try {
      await remoteService.upsertMood(inserted);
      if (inserted.id != null) {
        await localDb.markAsSynced(inserted.id!);
        AppLogger.info('Sincronización exitosa: ${inserted.id}');
      }
    } catch (e, st) {
      AppLogger.warning(
        'Estado de ánimo guardado localmente, pendiente de sincronización',
      );
      AppLogger.error(
        'Error al sincronizar nuevo estado de ánimo',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> updateMoodNote({
    required MoodModel mood,
    required String? nota,
  }) async {
    if (mood.id == null) {
      AppLogger.warning('No se puede actualizar un estado de ánimo sin id');
      return;
    }

    AppLogger.info('Actualizando nota del estado de ánimo: ${mood.id}');
    final updatedMood = mood.copyWith(
      nota: nota,
      pendingSync: true,
    );

    await localDb.updateMood(updatedMood);

    try {
      await remoteService.upsertMood(updatedMood);
      await localDb.markAsSynced(updatedMood.id!);
      AppLogger.info('Nota sincronizada correctamente: ${updatedMood.id}');
    } catch (e, st) {
      AppLogger.warning(
        'La nota se actualizó localmente, pendiente de sincronización',
      );
      AppLogger.error(
        'Error al sincronizar la nota actualizada',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> deleteMood(int id) async {
    AppLogger.info('Eliminando estado de ánimo: $id');
    await localDb.deleteMood(id);
  }

  Future<void> refreshFromRemote() async {
    AppLogger.info('Refrescando desde Firebase');
    try {
      final remoteMoods = await remoteService.fetchMoods();
      for (final mood in remoteMoods) {
        await localDb.upsertFromRemote(mood);
      }
      AppLogger.info(
        'Refresco completado. Documentos procesados: ${remoteMoods.length}',
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al obtener datos remotos',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> syncPendingMoods() async {
    AppLogger.info('Sincronizando estados de ánimo pendientes');
    final pending = await localDb.getPendingMoods();
    AppLogger.info('Pendientes por sincronizar: ${pending.length}');
    for (final mood in pending) {
      try {
        await remoteService.upsertMood(mood);
        if (mood.id != null) {
          await localDb.markAsSynced(mood.id!);
          AppLogger.info('Sincronizado: ${mood.id}');
        }
      } catch (e, st) {
        AppLogger.error(
          'Error sincronizando pendiente ${mood.id}',
          error: e,
          stackTrace: st,
        );
      }
    }
  }
}