import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_model.dart';
import 'app_logger.dart';

class MoodRemoteService {
  final CollectionReference<Map<String, dynamic>> _moodsRef =
      FirebaseFirestore.instance.collection('moods');

  Future<void> upsertMood(MoodModel mood) async {
    if (mood.id == null) {
      AppLogger.warning('No se puede sincronizar un estado de ánimo sin id local');
      return;
    }
    AppLogger.debug('Guardando estado de ánimo en Firebase: ${mood.id}');
    try {
      await _moodsRef.doc(mood.id.toString()).set(mood.toFirestore());
      AppLogger.info('Estado de ánimo guardado en Firebase: ${mood.id}');
    } on FirebaseException catch (e, st) {
      AppLogger.error(
        'FirebaseException al guardar estado de ánimo remoto',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } on SocketException catch (e, st) {
      AppLogger.error(
        'Error de red al guardar estado de ánimo remoto',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'Error inesperado al guardar estado de ánimo remoto',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<List<MoodModel>> fetchMoods() async {
    AppLogger.debug('Consultando estados de ánimo desde Firebase');
    try {
      final snapshot = await _moodsRef.get();
      AppLogger.info('Documentos obtenidos de Firebase: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        return MoodModel.fromFirestore(doc.data(), id: int.parse(doc.id));
      }).toList();
    } on FirebaseException catch (e, st) {
      AppLogger.error(
        'FirebaseException al obtener estados de ánimo remotos',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } on SocketException catch (e, st) {
      AppLogger.error(
        'Error de red al obtener estados de ánimo remotos',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'Error inesperado al obtener estados de ánimo remotos',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}