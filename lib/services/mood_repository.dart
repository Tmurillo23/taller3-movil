import '../data/app_database.dart';
import '../models/mood_model.dart';
import 'mood_remote_service.dart';

class MoodRepository {
  final AppDatabase localDb;
  final MoodRemoteService remoteService;

  MoodRepository({required this.localDb, required this.remoteService});

  Stream<List<MoodModel>> watchMoods() {
    return localDb.watchMoods();
  }

  Future<void> loadInitialData() async {
    await refreshFromRemote();
    await syncPendingMoods();
  }

  Future<void> addMood({
    required String nombre,
    required String emocion,
    String? nota,
  }) async {
    final localMood = MoodModel(
      nombre: nombre,
      emocion: emocion,
      nota: nota,
      fechaCreacion: DateTime.now(),
      pendingSync: true,
    );
    final inserted = await localDb.insertMood(localMood);

    try {
      await remoteService.upsertMood(inserted);
      if (inserted.id != null) {
        await localDb.markAsSynced(inserted.id!);
      }
    } catch (e) {
      // keep local copy pending
    }
  }

  Future<void> updateMoodNote({
    required MoodModel mood,
    required String? nota,
  }) async {
    if (mood.id == null) {
      return;
    }

    final updatedMood = mood.copyWith(
      nota: nota,
      pendingSync: true,
    );

    await localDb.updateMood(updatedMood);

    try {
      await remoteService.upsertMood(updatedMood);
      await localDb.markAsSynced(updatedMood.id!);
    } catch (e) {
      // leave as pending
    }
  }

  Future<void> deleteMood(int id) async {
    await localDb.deleteMood(id);
  }

  Future<void> refreshFromRemote() async {
    try {
      final remoteMoods = await remoteService.fetchMoods();
      for (final mood in remoteMoods) {
        await localDb.upsertFromRemote(mood);
      }
    } catch (e) {
      // ignore remote errors
    }
  }

  Future<void> syncPendingMoods() async {
    final pending = await localDb.getPendingMoods();
    for (final mood in pending) {
      try {
        await remoteService.upsertMood(mood);
        if (mood.id != null) {
          await localDb.markAsSynced(mood.id!);
        }
      } catch (e) {
        // ignore
      }
    }
  }
}
