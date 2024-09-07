import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../models/carpool.dart';
import '../models/carpool_request.dart';
import 'update_carpool_page.dart';

class CarpoolDetailsPage extends StatelessWidget {
  final Carpool carpool;
  final String eventId;

  const CarpoolDetailsPage({
    super.key,
    required this.carpool,
    required this.eventId,
  });

  Future<void> _deleteCarpool(BuildContext context) async {
    try {
      final eventDoc =
          FirebaseFirestore.instance.collection('events').doc(eventId);
      await eventDoc.update({
        'carpools': FieldValue.arrayRemove([carpool.toMap()]),
      });
      Navigator.pop(context);
    } catch (e) {
      print("Error deleting carpool: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting carpool')),
      );
    }
  }

  Future<String?> _getCurrentUserName() async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      return userDoc.data()?['name'] as String?;
    }
    return null;
  }

  Future<List<CarpoolRequest>> _fetchCarpoolRequests() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('carpool_requests')
        .where('offerID', isEqualTo: carpool.offerId)
        .get();

    return snapshot.docs
        .map((doc) => CarpoolRequest.fromDocument(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getCurrentUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching user details'));
        } else if (snapshot.hasData) {
          final currentUserName = snapshot.data;
          final isCurrentUser = carpool.carOwnerName == currentUserName;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Carpool Details'),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carpool.carDetails.model,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Driver: ${carpool.driver}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Car Owner: ${carpool.carOwnerName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Car Number: ${carpool.carDetails.carNumber}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Car Seats: ${carpool.carSeats}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Driver's CNIC No. : ${carpool.idCardNumber}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  if (!isCurrentUser) ...[
                    Text(
                      'Status: ${carpool.status}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 16.0),
                  if (!isCurrentUser) ...[
                    Text(
                      'Request Status',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    FutureBuilder<List<CarpoolRequest>>(
                      future: _fetchCarpoolRequests(),
                      builder: (context, requestSnapshot) {
                        if (requestSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (requestSnapshot.hasError) {
                          return const Text('Error fetching requests');
                        } else if (requestSnapshot.hasData) {
                          final requests = requestSnapshot.data!;
                          if (requests.isEmpty) {
                            return const Text('No requests found');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: requests.length,
                            itemBuilder: (context, index) {
                              final request = requests[index];
                              return ListTile(
                                title: Text(
                                    'Requester ID: ${request.requesterId}'),
                                subtitle: Text('Status: ${request.status}'),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                  const SizedBox(height: 16.0),
                  if (isCurrentUser) ...[
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateCarpoolPage(
                                  carpool: carpool,
                                  eventId: eventId,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                          child: const Text('Update'),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () => _deleteCarpool(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
