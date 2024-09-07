// car_details.dart
class CarDetails {
  String carOwner;
  String model;
  String carNumber;
  String idCardNumber;

  CarDetails({
    required this.carOwner,
    required this.model,
    required this.carNumber,
    required this.idCardNumber,
  });

  factory CarDetails.fromMap(Map<String, dynamic> map) {
    return CarDetails(
      carOwner: map['carOwner'],
      model: map['model'],
      carNumber: map['carNumber'],
      idCardNumber: map['idCardNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carOwner': carOwner,
      'model': model,
      'carNumber': carNumber,
      'idCardNumber': idCardNumber,
    };
  }
}
