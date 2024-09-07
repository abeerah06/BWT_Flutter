import 'car_details.dart'; // Import the CarDetails class

class Carpool {
  String id;
  String driver;
  String carOwnerName; // Added carOwnerName
  int carSeats;
  String status;
  CarDetails carDetails; // Use CarDetails to encapsulate car details
  String idCardNumber;
  String offerId; // New field for the offer ID

  Carpool({
    required this.id,
    required this.driver,
    required this.carOwnerName, // Initialize carOwnerName
    required this.carSeats,
    required this.status,
    required this.carDetails, // Initialize CarDetails
    required this.idCardNumber,
    required this.offerId, // Initialize offerId
  });

  factory Carpool.fromMap(Map<String, dynamic> map) {
    return Carpool(
      id: map['id'],
      driver: map['driver'],
      carOwnerName: map['carOwnerName'], // Extract carOwnerName from map
      carSeats: map['carSeats'],
      status: map['status'],
      carDetails:
          CarDetails.fromMap(map['carDetails']), // Convert map to CarDetails
      idCardNumber: map['idCardNumber'],
      offerId: map['offerId'] ??
          '', // Extract offerId from map, default to empty string if not present
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driver': driver,
      'carOwnerName': carOwnerName, // Add carOwnerName to map
      'carSeats': carSeats,
      'status': status,
      'carDetails': carDetails.toMap(), // Convert CarDetails to map
      'idCardNumber': idCardNumber,
      'offerId': offerId, // Add offerId to map
    };
  }
}
