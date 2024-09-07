import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    await _db.collection('events').add(eventData);
  }

  Stream<List<Map<String, dynamic>>> getEvents() {
    return _db.collection('events').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data())
        .toList());
  }

  Future<void> updateEvent(
      String eventId, Map<String, dynamic> eventData) async {
    await _db.collection('events').doc(eventId).update(eventData);
  }

  Future<void> deleteEvent(String eventId) async {
    await _db.collection('events').doc(eventId).delete();
  }
}
