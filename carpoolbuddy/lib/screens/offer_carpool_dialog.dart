import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/car_details.dart';
import '../models/carpool.dart';

class OfferCarpoolDialog extends StatefulWidget {
  final String eventId;

  const OfferCarpoolDialog({super.key, required this.eventId});

  @override
  _OfferCarpoolDialogState createState() => _OfferCarpoolDialogState();
}

class _OfferCarpoolDialogState extends State<OfferCarpoolDialog> {
  final _driverController = TextEditingController();
  final _carOwnerNameController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carSeatsController = TextEditingController();
  final _statusController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _idCardNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Offer Carpool'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Driver', _driverController,
                  'Please enter the driver\'s name'),
              _buildTextField('Car Owner Name', _carOwnerNameController,
                  'Please enter the car owner\'s name'),
              _buildTextField('Car Model', _carModelController,
                  'Please enter the car model'),
              _buildTextField('Car Seats', _carSeatsController,
                  'Please enter the number of car seats',
                  isNumber: true),
              _buildTextField(
                  'Status', _statusController, 'Please enter the status'),
              _buildTextField('Car Number', _carNumberController,
                  'Please enter the car number'),
              _buildTextField('Driver CNIC No.', _idCardNumberController,
                  'Please enter the driver\'s CNIC'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _offerCarpool,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          child: const Text('Offer'),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String validationMessage,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          if (isNumber && int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _offerCarpool() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final currentUserId = user.uid;

      final offerId =
          FirebaseFirestore.instance.collection('carpools').doc().id;

      final carpool = Carpool(
        id: currentUserId,
        driver: _driverController.text,
        carOwnerName: _carOwnerNameController.text,
        carSeats: int.parse(_carSeatsController.text),
        status: _statusController.text,
        carDetails: CarDetails(
          carOwner: _carOwnerNameController.text,
          model: _carModelController.text,
          carNumber: _carNumberController.text,
          idCardNumber: _idCardNumberController.text,
        ),
        idCardNumber: _idCardNumberController.text,
        offerId: offerId,
      );

      final eventDoc =
          FirebaseFirestore.instance.collection('events').doc(widget.eventId);
      await eventDoc.update({
        'carpools': FieldValue.arrayUnion([carpool.toMap()]),
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error offering carpool: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to offer carpool. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
