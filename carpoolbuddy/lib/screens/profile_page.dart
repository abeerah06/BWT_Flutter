import 'package:carpoolbuddy/models/user.dart';
import 'package:carpoolbuddy/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/car_details.dart';
import 'add_car_details_page.dart';
import 'edit_car_details_page.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: _authService.user, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data available.'));
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Profile Picture Section
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 50,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Profile Details Section
                  Center(
                      child:
                          _buildProfileDetail('Name', user.name, isBold: true)),
                  const SizedBox(height: 5),
                  Center(child: _buildProfileDetail('Email', user.email)),

                  const SizedBox(height: 10),

                  // Edit Profile Button
                  ElevatedButton(
                    onPressed: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                      if (result == true) {
                        
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Edit Profile'),
                  ),

                  const SizedBox(height: 20),

                  user.carDetails != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCarDetails(user.carDetails!),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditCarDetailsPage(
                                          carDetails: user.carDetails!),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Edit Car Details'),
                              ),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCarDetailsPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add Car Details'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value,
      {bool isBold = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: isBold ? 19 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildCarDetails(CarDetails carDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Car Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              color: Colors.grey[300],
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    _buildProfileDetail('Car Owner', carDetails.carOwner),
                    _buildProfileDetail('Car Model', carDetails.model),
                    _buildProfileDetail('Car Number', carDetails.carNumber),
                    _buildProfileDetail(
                        'Driver CNIC No.', carDetails.idCardNumber),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
