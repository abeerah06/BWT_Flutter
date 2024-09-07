import 'package:cloud_firestore/cloud_firestore.dart';

class CarpoolRequest {
  final String requestId;
  final String requesterId;
  final String offerId; // Reference to the carpool offer
  final String status; // e.g., 'pending', 'accepted', 'rejected'
  final Timestamp timestamp; // To track when the request was made

  CarpoolRequest({
    required this.requestId,
    required this.requesterId,
    required this.offerId,
    required this.status,
    required this.timestamp,
  });

  factory CarpoolRequest.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarpoolRequest(
      requestId: doc.id,
      requesterId: data['requesterId'],
      offerId: data['offerID'],
      status: data['status'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requesterId': requesterId,
      'offerID': offerId,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
