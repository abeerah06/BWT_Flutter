import 'package:cloud_firestore/cloud_firestore.dart';

import 'carpool.dart';

class Event {
  String id;
  String name;
  String description;
  DateTime dateTime;
  String address;
  List<Carpool> carpools;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
    required this.address,
    required this.carpools,
  });

  factory Event.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      address: data['address'] ?? '',
      carpools: (data['carpools'] as List<dynamic>?)
              ?.map((carpool) => Carpool.fromMap(carpool))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'address': address,
      'carpools': carpools.map((carpool) => carpool.toMap()).toList(),
    };
  }
}
