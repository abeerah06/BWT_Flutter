import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  TextEditingController _birthdateController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task#3',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Color.fromARGB(255, 72, 53, 120),
        foregroundColor: Color.fromARGB(255, 255, 252, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionHeading("Personal Information"),
                customCard(
                  child: customTextFormField(
                    label: "Name",
                    hintText: 'e.g. Abeerah Saleem',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['name'] = value,
                  ),
                ),
                customCard(
                  child: customTextFormField(
                    label: "Email",
                    hintText: 'e.g. abeerahsaleem@xyz.com',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['email'] = value,
                  ),
                ),
                customCard(
                  child: customTextFormField(
                    label: "Phone",
                    hintText: 'e.g. 03239876351',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      final phoneRegex = RegExp(r'^[0-9]+$');
                      if (!phoneRegex.hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['phone'] = value,
                  ),
                ),
                customCard(
                  child: customTextFormField(
                    label: "Birthdate",
                    hintText: 'YYYY-MM-DD',
                    controller: _birthdateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _birthdateController.text =
                              pickedDate.toLocal().toString().split(' ')[0];
                          _formData['birthdate'] =
                              pickedDate.toLocal().toString().split(' ')[0];
                        });
                      }
                    },
                    onSaved: (value) => _formData['birthdate'] = value,
                  ),
                ),
                customCard(
                  child: customTextFormField(
                    label: "Address",
                    hintText: 'e.g. House #57, Street #2, ABC',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['address'] = value,
                  ),
                ),
                sectionHeading("Additional Information"),
                customCard(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        hintText: 'e.g. USA', border: InputBorder.none),
                    items: ['Pakistan', 'India', 'USA', 'UK', 'Canada', 'China']
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _formData['country'] = value;
                    }),
                    onSaved: (value) => _formData['country'] = value,
                  ),
                ),
                customCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        ),
                      ),
                      RadioListTile(
                        title: const Text('Male'),
                        value: 'male',
                        groupValue: _formData['gender'],
                        onChanged: (value) => setState(() {
                          _formData['gender'] = value;
                        }),
                        activeColor: Color.fromARGB(255, 72, 53, 120),
                      ),
                      RadioListTile(
                        title: const Text('Female'),
                        value: 'female',
                        groupValue: _formData['gender'],
                        onChanged: (value) => setState(() {
                          _formData['gender'] = value;
                        }),
                        activeColor: Color.fromARGB(255, 72, 53, 120),
                      ),
                    ],
                  ),
                ),
                customCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Age",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        ),
                      ),
                      Slider(
                        label: '${_formData['age'] ?? 18}',
                        value: (_formData['age'] ?? 18).toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) => setState(() {
                          _formData['age'] = value.toInt();
                        }),
                        activeColor: Color.fromARGB(255, 72, 53, 120),
                      ),
                    ],
                  ),
                ),
                customCard(
                  child: CheckboxListTile(
                    title: const Text('Subscribe to newsletter'),
                    value: _formData['subscribe'] ?? false,
                    onChanged: (value) => setState(() {
                      _formData['subscribe'] = value;
                    }),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Color.fromARGB(255, 72, 53, 120),
                  ),
                ),
                customCard(
                  child: SwitchListTile(
                    title: const Text('Receive Notifications'),
                    value: _formData['notifications'] ?? false,
                    onChanged: (value) => setState(() {
                      _formData['notifications'] = value;
                    }),
                    activeColor: Color.fromARGB(255, 72, 53, 120),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          _formKey.currentState!.save();
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayDataPage(_formData),
                              ),
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 72, 53, 120),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 254, 254, 254),
                            )
                          : const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 72, 53, 120),
        ),
      ),
    );
  }

  Widget customCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget customTextFormField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
    TextEditingController? controller,
    bool readOnly = false,
    GestureTapCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}

class DisplayDataPage extends StatelessWidget {
  final Map<String, dynamic> formData;

  DisplayDataPage(this.formData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Display Data',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Color.fromARGB(255, 72, 53, 120),
        foregroundColor: Color.fromARGB(255, 253, 252, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: formData.keys.map((key) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: ListTile(
                title: Text(
                  '$key:',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: key == 'birthdate'
                    ? Text(
                        '${formData[key]}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        '${formData[key]}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        ),
                      ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
