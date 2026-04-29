import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_model.dart';
import 'app_logger.dart';

enum QaRemoteFailure { none, permissionDenied, network, unexpected }

class MoodRemoteService {
  final CollectionReference<Map<String, dynamic>> _moodsRef =
      FirebaseFirestore.instance.collection('moods');

  QaRemoteFailure _nextFailure = QaRemoteFailure.none;

  void simulatePermissionDeniedOnce() {
    _nextFailure = QaRemoteFailure.permissionDenied;
  }

  void simulateNetworkErrorOnce() {
    _nextFailure = QaRemoteFailure.network;
  }

  void simulateUnexpectedErrorOnce() {
    _nextFailure = QaRemoteFailure.unexpected;
  }

  void _throwFailureIfNeeded() {
    final failure = _nextFailure;
    _nextFailure = QaRemoteFailure.none;
    switch (failure) {
      case QaRemoteFailure.permissionDenied:
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Missing or insufficient permissions.',
        );
      case QaRemoteFailure.network:
        throw const SocketException('Simulación QA: sin conexión a internet.');
      case QaRemoteFailure.unexpected:
        throw StateError('Simulación QA: error inesperado en el servicio remoto.');
      case QaRemoteFailure.none:
        break;
    }
  }

  Future<void> upsertMood(MoodModel mood) async {
    if (mood.id == null) {
      AppLogger.warning('No se puede sincronizar un estado de ánimo sin id local');
      return;
    }
    AppLogger.debug('Guardando estado de ánimo en Firebase: ${mood.id}');
    _throwFailureIfNeeded();
    try {
      await _moodsRef.doc(mood.id.toString()).set(mood.toFirestore());
      AppLogger.info('Estado de ánimo guardado en Firebase: ${mood.id}');
    } catch (e, st) {
      AppLogger.error('Error al guardar estado de ánimo remoto', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<MoodModel>> fetchMoods() async {
    AppLogger.debug('Consultando estados de ánimo desde Firebase');
    _throwFailureIfNeeded();
    try {
      final snapshot = await _moodsRef.get();
      AppLogger.info('Documentos obtenidos de Firebase: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        return MoodModel.fromFirestore(doc.data(), id: int.parse(doc.id));
      }).toList();
    } catch (e, st) {
      AppLogger.error('Error al obtener estados de ánimo remotos', error: e, stackTrace: st);
      rethrow;
    }
  }
}