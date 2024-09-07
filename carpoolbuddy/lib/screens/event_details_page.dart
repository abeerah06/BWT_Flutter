import 'package:carpoolbuddy/screens/carpool_requests_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../models/carpool.dart';
import '../models/carpool_request.dart';
import '../models/event.dart';
import 'carpool_details_page.dart';
import 'chat_page.dart';
import 'messages.dart';
import 'offer_carpool_dialog.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  Future<void> _sendCarpoolRequest(Carpool carpool) async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    final existingRequestQuery = await FirebaseFirestore.instance
        .collection('carpool_requests')
        .where('requesterId', isEqualTo: currentUser.uid)
        .where('offerID', isEqualTo: carpool.offerId)
        .get();

    if (existingRequestQuery.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You have already sent a request for this carpool.')),
      );
      return;
    }
    final requestId =
        FirebaseFirestore.instance.collection('carpool_requests').doc().id;

    final request = CarpoolRequest(
      requestId: requestId,
      requesterId: currentUser.uid,
      timestamp: Timestamp.now(),
      status: 'pending',
      offerId: carpool.offerId,
    );

    try {
      await FirebaseFirestore.instance
          .collection('carpool_requests')
          .doc(requestId)
          .set({
        'requesterId': request.requesterId,
        'requestId': request.requestId,
        'offerID': request.offerId,
        'timestamp': request.timestamp,
        'status': request.status,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent successfully.')),
      );
      return;
    } catch (e) {
      // Handle the error, for example, by logging it
      print('Error sending carpool request: $e');
    }
  }

  Future<Event> _fetchEventDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();
      return Event.fromDocument(doc);
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }

  Future<void> _deleteEvent(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .delete();
      Navigator.of(context).pop(); // Navigate back after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );
    } catch (e) {
      print("Error deleting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting event')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = auth.FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Event'),
                    content: const Text(
                        'Are you sure you want to delete this event?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                _deleteEvent(context);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Event>(
        future: _fetchEventDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching event details'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            final hasCarpoolOffers = event.carpools.isNotEmpty;

            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15.0),
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        event.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[600]),
                          const SizedBox(width: 8.0),
                          Text(
                            event.dateTime.toLocal().toString().split(' ')[0],
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.grey[600]),
                          const SizedBox(width: 10.0),
                          Text(
                            event.dateTime.toLocal().toString().split(' ')[1],
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey[600]),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              event.address,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Carpool Offers',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      if (!hasCarpoolOffers) ...[
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => OfferCarpoolDialog(
                                  eventId: widget.eventId,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                            child: const Text('Offer Carpool'),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: ListView.builder(
                            itemCount: event.carpools.length,
                            itemBuilder: (context, index) {
                              final carpool = event.carpools[index];
                              final isCurrentUserOffer =
                                  carpool.id == currentUser!.uid;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarpoolDetailsPage(
                                        carpool: carpool,
                                        eventId: widget.eventId,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.black,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          carpool.carDetails.model,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Driver: ${carpool.driver}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Status: ${carpool.status}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            if (!isCurrentUserOffer) ...[
                                              ElevatedButton(
                                                onPressed: () async {
                                                  print(
                                                      'Request button pressed');
                                                  await _sendCarpoolRequest(
                                                      carpool);
                                                  print(
                                                      'Request function executed');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.black,
                                                ),
                                                child: const Text('Request'),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                        receiverName: carpool
                                                            .carOwnerName,
                                                        receiverID: carpool
                                                            .id, // carpool offerer ID
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                ),
                                                child: const Text('Message'),
                                              ),
                                            ] else ...[
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CarpoolOfferRequestsPage(
                                                        eventId: widget.eventId,
                                                        carpoolId:
                                                            carpool.offerId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                ),
                                                child:
                                                    const Text('View Requests'),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Messages(),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                ),
                                                child:
                                                    const Text('View Messages'),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
