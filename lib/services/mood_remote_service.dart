import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_model.dart';

class MoodRemoteService {
  final CollectionReference<Map<String, dynamic>> _moodsRef =
      FirebaseFirestore.instance.collection('moods');

  Future<void> upsertMood(MoodModel mood) async {
    if (mood.id == null) {
      return;
    }
    try {
      await _moodsRef.doc(mood.id.toString()).set(mood.toFirestore());
    } on FirebaseException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

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
