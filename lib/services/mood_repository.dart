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
      AppLogger.warning('Estado de ánimo guardado localmente, pendiente de sincronización');
      AppLogger.error('Error al sincronizar nuevo estado de ánimo', error: e, stackTrace: st);
    }
  }

  Future<void> deleteMood(int id) async {
    AppLogger.info('Eliminando estado de ánimo: $id');
    await localDb.deleteMood(id);
    // Opcional: también podrías eliminarlo de Firebase, pero por ahora mantenemos local.
  }

  Future<void> refreshFromRemote() async {
    AppLogger.info('Refrescando desde Firebase');
    try {
      final remoteMoods = await remoteService.fetchMoods();
      for (final mood in remoteMoods) {
        await localDb.upsertFromRemote(mood);
      }
      AppLogger.info('Refresco completado. Documentos procesados: ${remoteMoods.length}');
    } catch (e, st) {
      AppLogger.error('Error al obtener datos remotos', error: e, stackTrace: st);
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
        AppLogger.error('Error sincronizando pendiente ${mood.id}', error: e, stackTrace: st);
      }
    }
  }

  // Métodos QA (solo en debug)
  Future<void> qaCreateMoodWithPermissionDenied() async {
    AppLogger.info('QA: simulando permission-denied');
    remoteService.simulatePermissionDeniedOnce();
    await addMood(nombre: 'QA', emocion: 'Feliz', nota: 'Permiso denegado');
  }

  Future<void> qaCreateMoodWithNetworkError() async {
    AppLogger.info('QA: simulando error de red');
    remoteService.simulateNetworkErrorOnce();
    await addMood(nombre: 'QA', emocion: 'Triste', nota: 'Error de red');
  }

  Future<void> qaCreateMoodWithUnexpectedError() async {
    AppLogger.info('QA: simulando error inesperado');
    remoteService.simulateUnexpectedErrorOnce();
    await addMood(nombre: 'QA', emocion: 'Ansioso', nota: 'Error inesperado');
  }

  Future<void> qaCreateLongTextMood() async {
    AppLogger.info('QA: creando texto largo');
    await addMood(
      nombre: 'QA - Nombre extremadamente largo para probar overflow visual y diseño',
      emocion: 'Cansado',
      nota: 'Nota larga: ${'texto ' * 100}'
    );
  }

  Future<void> qaSimulateSlowOperation() async {
    AppLogger.info('QA: operación lenta');
    await Future.delayed(const Duration(seconds: 3));
    AppLogger.info('QA: operación lenta finalizada');
  }

  Future<void> qaThrowUnexpectedUiError() async {
    AppLogger.info('QA: lanzando error inesperado');
    throw StateError('QA: error inesperado simulado desde UI');
  }
}