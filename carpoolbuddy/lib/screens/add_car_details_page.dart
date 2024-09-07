import 'package:flutter/material.dart';
import '../models/car_details.dart';
import '../services/auth_service.dart';
class AddCarDetailsPage extends StatefulWidget {
  const AddCarDetailsPage({super.key});

  @override
  _AddCarDetailsPageState createState() => _AddCarDetailsPageState();
}

class _AddCarDetailsPageState extends State<AddCarDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _carOwnerController = TextEditingController();
  final _modelController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _idCardNumberController = TextEditingController();

  void _saveCarDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      CarDetails carDetails = CarDetails(
        carOwner: _carOwnerController.text,
        model: _modelController.text,
        carNumber: _carNumberController.text,
        idCardNumber: _idCardNumberController.text,
      );

      await AuthService().updateCarDetails(carDetails);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Car Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _carOwnerController,
                decoration: const InputDecoration(labelText: 'Car Owner'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter car owner' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Car Model'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter car model' : null,
              ),
              TextFormField(
                controller: _carNumberController,
                decoration: const InputDecoration(labelText: 'Car Number'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter car number' : null,
              ),
              TextFormField(
                controller: _idCardNumberController,
                decoration: const InputDecoration(labelText: 'Driver CNIC No.'),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter Driver CNIC No.'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCarDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
