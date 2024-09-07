import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/car_details.dart'; 
import '../models/carpool.dart';

class UpdateCarpoolPage extends StatefulWidget {
  final Carpool carpool;
  final String eventId;

  const UpdateCarpoolPage({
    super.key,
    required this.carpool,
    required this.eventId,
  });

  @override
  _UpdateCarpoolPageState createState() => _UpdateCarpoolPageState();
}

class _UpdateCarpoolPageState extends State<UpdateCarpoolPage> {
  final _driverController = TextEditingController();
  final _carOwnerNameController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carSeatsController = TextEditingController();
  final _statusController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _idCardNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _driverController.text = widget.carpool.driver;
    _carOwnerNameController.text = widget.carpool.carOwnerName;
    _carModelController.text = widget.carpool.carDetails.model;
    _carSeatsController.text = widget.carpool.carSeats.toString();
    _statusController.text = widget.carpool.status;
    _carNumberController.text = widget.carpool.carDetails.carNumber;
    _idCardNumberController.text = widget.carpool.carDetails.idCardNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Carpool'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _updateCarpool,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Future<void> _updateCarpool() async {
    if (!_formKey.currentState!.validate()) {
      return; // Show validation errors
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final currentUserId = user.uid; // Fetch the current user's UID

      final updatedCarpool = Carpool(
        id: currentUserId, // Use the current user's UID
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
        offerId: widget.carpool.offerId, // Keep the existing offerId
      );

      final eventDoc =
          FirebaseFirestore.instance.collection('events').doc(widget.eventId);
      await eventDoc.update({
        'carpools': FieldValue.arrayRemove([widget.carpool.toMap()]),
      });
      await eventDoc.update({
        'carpools': FieldValue.arrayUnion([updatedCarpool.toMap()]),
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error updating carpool: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update carpool. Please try again.'),
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
