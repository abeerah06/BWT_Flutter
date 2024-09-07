import 'car_details.dart'; // Ensure this is the correct path

class User {
  final String id;
  final String name;
  final String email;
  late final String profileImageUrl;
  final String? phoneNumber;
  final CarDetails? carDetails; // Correct class name

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    this.phoneNumber,
    this.carDetails, // Include carDetails in the constructor
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      phoneNumber: map['phoneNumber'] as String?,
      carDetails: map['carDetails'] != null
          ? CarDetails.fromMap(map['carDetails'] as Map<String, dynamic>)
          : null, // Parse carDetails
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'carDetails': carDetails?.toMap(), // Add carDetails to the map
    };
  }
}
