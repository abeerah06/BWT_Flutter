import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/carpool_request.dart';

class CarpoolOfferRequestsPage extends StatelessWidget {
  final String carpoolId;

  const CarpoolOfferRequestsPage({
    super.key,
    required this.carpoolId,
    required String eventId,
  });

  Future<List<CarpoolRequest>> _fetchRequests() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('carpool_requests')
          .where('offerID', isEqualTo: carpoolId)
          .get();
      print("Fetched ${snapshot.docs.length} requests");
      return snapshot.docs
          .map((doc) => CarpoolRequest.fromDocument(doc))
          .toList();
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Error fetching carpool requests: $e');
    }
  }

  Future<void> _updateRequestStatus(
      BuildContext context, String requestId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('carpool_requests')
          .doc(requestId)
          .update({'status': status});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request $status successfully')),
      );
    } catch (e) {
      print("Error updating request status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating request status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Carpool Requests'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<CarpoolRequest>>(
        future: _fetchRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching requests: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return ListTile(
                  title: Text('Requester ID: ${request.requesterId}'),
                  subtitle: Text('Status: ${request.status}'),
                  trailing: request.status == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                _updateRequestStatus(
                                    context, request.requestId, 'accepted');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _updateRequestStatus(
                                    context, request.requestId, 'rejected');
                              },
                            ),
                          ],
                        )
                      : null,
                );
              },
            );
          } else {
            return const Center(child: Text('No requests found'));
          }
        },
      ),
    );
  }
}
