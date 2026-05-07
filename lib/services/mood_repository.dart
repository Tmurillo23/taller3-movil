import '../data/app_database.dart';
import '../models/mood_model.dart';
import 'mood_remote_service.dart';

//Constructor 
class MoodRepository {
  final AppDatabase localDb;//Para hablar con la BD local (SQLite)
  final MoodRemoteService remoteService;//Para hablar con la BD remota (Firebase)

  MoodRepository({required this.localDb, required this.remoteService});

  //Para preguntar por la lista actualizada de todos los moods a la BD local.
  Stream<List<MoodModel>> watchMoods() {
    return localDb.watchMoods();
  }

  //Se ejecuta al iniciar la app.
  Future<void> loadInitialData() async {
    await refreshFromRemote();//Descarga novedades de Firebase → por si otro dispositivo creó moods
    await syncPendingMoods();//Envía pendientes a Firebase → por si el celular estuvo sin internet
    //El await en cada línea significa que espera a que termine la primera antes de empezar la segunda.
  }

  //Recibe los datos que el usuario escribió en el formulario.
  Future<void> addMood({
    required String nombre,
    required String emocion,
    String? nota,
  }) async {  
    //Crea el mood con pendingSync: true porque todavía no está en Firebase. 
    //DateTime.now() captura la fecha y hora exacta en que el usuario lo creó.
    final localMood = MoodModel(
      nombre: nombre,
      emocion: emocion,
      nota: nota,
      fechaCreacion: DateTime.now(),//obtine la fecha y hora actual
      pendingSync: true,//lo maca como pendiente por que todavía no se subió a Firebase
    );
    //Lo guarda en la BD local, asi si no hay interntet ya va a estar guardado.
    //La variable inserted tiene el mood con el id asignado por la BD local.
    final inserted = await localDb.insertMood(localMood);

    //Intenta subirlo a Firebase 
    try { 
      await remoteService.upsertMood(inserted);//intenta subirlo a firebase
      if (inserted.id != null) {
        await localDb.markAsSynced(inserted.id!);//Marca pendingSync: false para avisar que ya se subió a Firebase
      }
      //si no hay internet es decir esta linea falla: await remoteService.upsertMood(inserted);
    } catch (e) {//No hace nada deja todo como esta.
      // keep local copy pending
    }
  }

  //Recibe el mood a editar y la nota nueva
  Future<void> updateMoodNote({
    required MoodModel mood,
    required String? nota,
  }) async {
    //Si no tiene id no puede identificarlo, entonces no hace nada.
    if (mood.id == null) {
      return;
    }

    final updatedMood = mood.copyWith(
      nota: nota,
      pendingSync: true,
    );

  //Guarda el cambio en la BD local primero, sin importar si hay internet. Así el usuario ve el cambio inmediatamente en pantalla.
    await localDb.updateMood(updatedMood);

  //Mismo patrón que addMood — intenta sincronizar con Firebase y si falla queda pendiente.
    try {
      await remoteService.upsertMood(updatedMood);
      await localDb.markAsSynced(updatedMood.id!);
    } catch (e) {
      // leave as pending
    }
  }

  //Solo borra de la BD local. No borra de Firebase
  //si haces refreshFromRemote después de borrar, el mood volvería a aparecer porque sigue en Firebase.
  Future<void> deleteMood(int id) async {
    await localDb.deleteMood(id);
  }

  //Descarga todos los moods de Firebase y los guarda localmente. El for los procesa uno por uno:
  Future<void> refreshFromRemote() async {
    try {
      final remoteMoods = await remoteService.fetchMoods();
      for (final mood in remoteMoods) {
        await localDb.upsertFromRemote(mood);
      }
    } catch (e) {
      // ignore remote errors
    }//Si no hay internet, el catch atrapa el error y lo ignora — la app sigue funcionando con los datos locales que ya tiene.
  }

  //Imagina que estuviste sin internet y creaste 3 moods. Los 3 quedaron con pendingSync: true. Cuando vuelve el internet,
  // esta función los recorre uno por uno y los envía a Firebase.
  Future<void> syncPendingMoods() async {

  // Obtiene de la BD local solo los moods que tienen pendingSync: true
  final pending = await localDb.getPendingMoods();

  // Recorre cada mood pendiente uno por uno
  for (final mood in pending) {

    try {
      // Intenta enviarlo a Firebase
      await remoteService.upsertMood(mood);

      // Si llegó hasta aquí, Firebase lo recibió bien.
      // Verifica que tenga id antes de marcarlo
      if (mood.id != null) {

        // Cambia pendingSync a false en la BD local porque ya está guardado en Firebase
        await localDb.markAsSynced(mood.id!);
      }

    } catch (e) {
      // Si falló (sin internet u otro error),
      // no hace nada. El mood sigue con
      // pendingSync: true para el próximo intento.
      // Continúa con el siguiente mood de la lista.
    }
  }
}
}
