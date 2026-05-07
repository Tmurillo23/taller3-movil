//Defines la estructura de la base de datos y las operaciones disponibles.

import 'package:drift/drift.dart';//Libreria utilizada para utilizar SQLite en Flutter, permite definir tablas 
// y realizar consultas de manera sencilla.
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';//sirve para encontrar la carpeta del dispositivo donde guardar la BD.
import '../models/mood_model.dart';

//Le dices a Dart: "este archivo y el .g.dart son una sola unidad". Es lo que permite que el código generado funcione 
//junto con el tuyo.
part 'app_database.g.dart';

class Moods extends Table {//Se crea una tabla llamada "Moods" de SQLite con las siguientes columnas:
  IntColumn get id => integer().autoIncrement()();//Columna "id" de tipo entero que se autoincrementa.
  TextColumn get nombre => text()();//Columna "nombre" de tipo texto.
  TextColumn get emocion => text()();//Columna "emocion" de tipo texto.
  TextColumn get nota => text().nullable()();//Columna de texto opcional (puede estar vacía/nula). El .nullable() lo indica.
  DateTimeColumn get fechaCreacion => dateTime()();//Columna de fecha y hora.
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
  //Columna booleana (verdadero/falso). Por defecto es true, lo que significa que todo mood nuevo está pendiente 
  //de sincronizar con un servidor remoto.
}

//El @DriftDatabase le dice a Drift: "esta es mi base de datos y usa la tabla Moods
@DriftDatabase(tables: [Moods])
//La clase hereda de _$AppDatabase, que es la clase base que Drift generó en el .g.dart.
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());
  //El constructor. Si no le pasas nada, abre la conexión por defecto con _openConnection(). Esto permite también pasar una base de datos falsa en pruebas.
  @override
  //Definir el numero de tablas que tiene la BD (1 en este caso) 
  int get schemaVersion => 1;

//Funcion estatica que retorna un QueryExecutor, que es lo que Drift usa para ejecutar consultas en la base de datos.
//es decir el conector entre la app y la base de datos.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mood_app_db',//Crea o abre una base de datos llamada "mood_app_db".
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,//Esto le dice a flutter que guarde la base de datos en la 
        //carpeta de soporte de la aplicación, que es un lugar seguro y privado para almacenar datos.
      ),
      //Configuracion de la base de datos para cuando corre en la web, ya que la web no tiene la base de datos instalado. 
      web: DriftWebOptions(
        //SQLite compilado a WebAssembly(formato que los navegadores si pueden ejecutar) para correr en navegadores.
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        //Trabajador en segundo plano para ejecutar las consultas de la base de datos sin bloquear la interfaz de usuario.
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

//Esta funcion recibe un row(fila), es decir un registro de la tabla Moods(la BD que se creo automaticamente).
  MoodModel _mapMoodToModel(Mood row) {
    return MoodModel(//Convierte ese registro a uno tipo MoodModel(la BD que yo cree por dentro de la app carpeta models).
      id: row.id,
      nombre: row.nombre,
      emocion: row.emocion,
      nota: row.nota,
      fechaCreacion: row.fechaCreacion,
      pendingSync: row.pendingSync,
    );
    //Esto es necesario por que la app solo entinde lo que viene en formato MoodModel, y no lo que viene en 
    //formato Mood, que es el formato de la base de datos.Entomces cada vez que el usuario haga una consulta a la BD esta 
    //funcion se encargara de convertir lo que venga de la BD a un formato que la app entienda.
  }

//Retorna un Stream, que es como una "transmisión en vivo". Cada vez que cambia algo en la tabla, la UI se actualiza 
//automáticamente. Los resultados vienen ordenados del más reciente al más antiguo.
  Stream<List<MoodModel>> watchMoods() {
    final query = select(moods)
      ..orderBy([
        (m) => OrderingTerm.desc(m.fechaCreacion),
      ]);

    return query.watch().map(
      (rows) => rows.map(_mapMoodToModel).toList(),
    );
  }

//Obtiene todos los moods una sola vez (no es en vivo como el Stream).
  Future<List<MoodModel>> getAllMoods() async {
    final rows = await select(moods).get();
    return rows.map(_mapMoodToModel).toList();
  }

//Esta funcion recibe un objeto tipo MoodModel, lo inserta en la base de datos y retorna el mismo objeto pero con el id 
//asignado por la base de datos para asi poderlo mostrar en la UI y que el usuario pueda borrarlo y actualizarlo despues. 
//Esto se hace porque cuando el usuario crea el objeto tipo MoodModel este lo hace con un id nulo, y con el id nulo 
//el usuario no podria borrarlo o actualizarlo despues.
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

//Actualizar un dato ya existente en la BD. Primero verifica que tenga un id asinado, si no lo tiene no hace nada. 
//Si tiene id, entonces actualiza el registro que tenga ese id con los nuevos datos que le pasamos en el objeto MoodModel.
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

//pendingSync es el campo que utilizamos para saber si el registro ya fue guardado en la BD es decir el servidor remoto o no
//Si pendingSync es true ignifica que todavia no ha sido enviado a la BD. 

//Borrar un registro de la BD. Recibe el id del registro que se quiere borrar, y borra el registro que tenga ese id.
  Future<void> deleteMood(int id) async {
    await (delete(moods)..where((m) => m.id.equals(id))).go();
  }

//Va a buscar todos los registros que tengan pendingSync en true, es decir todos los registros que todavia no han sido 
//enviados a la BD. Solo retorna la lista de los registros pendientes de guardar en la BD.
  Future<List<MoodModel>> getPendingMoods() async {
    final rows = await (select(moods)..where((m) => m.pendingSync.equals(true))).get();
    return rows.map(_mapMoodToModel).toList();
  }

//Esta funcion es la que se encraga de cambiar a false el campo pendingSync de un registro, es decir busca en la BD los registros
//que tengan el campo pendingSync como true y los cambia a false, lo que significa que ya han sido guardados en la BD.  
  Future<void> markAsSynced(int id) async {
    await (update(moods)..where((m) => m.id.equals(id))).write(
      const MoodsCompanion(
        pendingSync: Value(false),
      ),
    );
  }

 //"Upsert" = insert + update. Si el mood ya existe en la base local (mismo id), lo actualiza. Si no existe, lo inserta. 
 //Esta funcion lo que hace es buscar los moods que no estan localmente pero si en la BD para asi mantener la BD local 
 //sincronizada con la BD remota. Esto es necesario por que si el usuario hace cambios en la BD remota desde otro dispositivo, 
 //esos cambios se reflejen en la BD local de este dispositivo.
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