import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';//lo que te permite hablar con la base de datos remota de Firebase.
import '../models/mood_model.dart';

//Archivo encargado de hablar directamente con Firebase, es decir la BD remota. Aquí se hacen las consultas a 
//Firebase para guardar y obtener los moods. La pantalla no habla directamente con este servicio, sino que 
//lo hace a través del repositorio, que es quien sabe cómo obtener, guardar y sincronizar los moods.

//Crea una referencia a la colección moods en Firestore. Piénsalo como un "puntero" a la carpeta donde están 
//guardados todos los moods en el servidor. A partir de aquí siempre usas _moodsRef para interactuar con esa colección.

class MoodRemoteService {
  final CollectionReference<Map<String, dynamic>> _moodsRef =
      FirebaseFirestore.instance.collection('moods');
      //FirebaseFirestore.instance → conéctate a Firebase
      //.collection('moods') → apunta a la carpeta moods
      //_moodsRef → guarda ese "puntero" en una variable

//Es como decirle a tu app: "la carpeta donde están los moods en Firebase es esta, guárdala en _moodsRef para usarla después".

//Guarda o actualiza un mood en Firebase  
  Future<void> upsertMood(MoodModel mood) async {
    //Si el mood no tiene id, no hace nada y termina. Sin id no sabría en qué documento de Firebase guardar el mood.
    if (mood.id == null) {
      return;
    }
    try {
//_moodsRef.doc(mood.id.toString()) → selecciona el documento con ese id (o lo crea si no existe). 
//El .toString() convierte el número a texto porque Firestore usa texto como nombre de documento
//mood.toFirestore() → convierte el mood al formato que Firestore entiende (map de clave-valor)
      await _moodsRef.doc(mood.id.toString()).set(mood.toFirestore());
    } on FirebaseException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (_) {
      rethrow;
    }
    //Captura tres tipos de error y los relanza con rethrow:
    //FirebaseException → algo falló en Firebase (permisos, servicio caído, etc.)
    //SocketException → no hay internet
    //catch (_) → cualquier otro error inesperado
  }

  //Descarga todos los moods de Firebase
  //Descarga todos los documentos de la carpeta moods de una sola vez. El resultado se guarda en snapshot, 
  //que contiene todos los documentos
  Future<List<MoodModel>> fetchMoods() async {
    try {
      final snapshot = await _moodsRef.get();
      return snapshot.docs.map((doc) {
        return MoodModel.fromFirestore(doc.data(), id: int.parse(doc.id));
      }).toList();
    } on FirebaseException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}

//doc.data() → obtiene los datos del documento (el Map con nombre, emocion, etc.)
//doc.id → obtiene el id del documento (que en Firestore es texto, como "3")
//int.parse(doc.id) → convierte ese texto a número ("3" → 3)
//fromFirestore(...) → construye el MoodModel con esos datos
//.toList() → convierte el resultado a una lista
