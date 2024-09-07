import 'package:carpoolbuddy/models/car_details.dart';
import 'package:carpoolbuddy/services/auth_service.dart';
import 'package:flutter/material.dart';

class EditCarDetailsPage extends StatefulWidget {
  final CarDetails carDetails;

  const EditCarDetailsPage({super.key, required this.carDetails});

  @override
  _EditCarDetailsPageState createState() => _EditCarDetailsPageState();
}

class _EditCarDetailsPageState extends State<EditCarDetailsPage> {
  final _carOwnerController = TextEditingController();
  final _modelController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _idCardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carOwnerController.text = widget.carDetails.carOwner;
    _modelController.text = widget.carDetails.model;
    _carNumberController.text = widget.carDetails.carNumber;
    _idCardNumberController.text = widget.carDetails.idCardNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Edit Car Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Car Owner', _carOwnerController),
              _buildTextField('Car Model', _modelController),
              _buildTextField('Car Number', _carNumberController),
              _buildTextField('Driver CNIC No.', _idCardNumberController),

              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveCarDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Details'),
                ),
              ),

              const SizedBox(height: 10),

              // Delete Button
              Center(
                child: ElevatedButton(
                  onPressed: _deleteCarDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  void _saveCarDetails() async {
    final updatedCarDetails = CarDetails(
      carOwner: _carOwnerController.text,
      model: _modelController.text,
      carNumber: _carNumberController.text,
      idCardNumber: _idCardNumberController.text,
    );

    final user = await AuthService().getCurrentUser();
    if (user != null) {
      await AuthService().updateCarDetails(updatedCarDetails);
      Navigator.pop(context);
    }
  }

  void _deleteCarDetails() async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      await AuthService().deleteCarDetails();
      Navigator.pop(context);
    }
  }
}
