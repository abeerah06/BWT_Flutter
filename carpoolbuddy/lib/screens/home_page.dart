import 'package:carpoolbuddy/components/drawer.dart';
import 'package:carpoolbuddy/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_pkg;

import '../models/event.dart';
import 'create_event_page.dart';
import 'event_details_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  location_pkg.LocationData? _currentLocation;
  final location_pkg.Location _location = location_pkg.Location();
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchController.addListener(_onSearchChanged);
    _fetchEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void logout() {
    final auth = AuthService();
    auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(locationData.latitude!, locationData.longitude!),
            infoWindow: const InfoWindow(title: 'You are here'),
          ),
        );
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Fetch events from Firestore
  Future<void> _fetchEvents() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('events').get();
      final events =
          snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
      setState(() {
        _allEvents = events;
        _filteredEvents = events; // Initially display all events
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  // Called whenever the text in the search bar changes
  void _onSearchChanged() {
    setState(() {
      _filteredEvents = _allEvents
          .where((event) => event.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  // Get profile pic
  Future<String> _getProfilePictureUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final profilePictureRef =
            FirebaseStorage.instance.ref('profile_pictures/${user.uid}.jpg');
        final url = await profilePictureRef.getDownloadURL();
        return url;
      } catch (e) {
        print('Error fetching profile picture: $e');
        return '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          "Events",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                FutureBuilder<String>(
                  future: _getProfilePictureUrl(),
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            snapshot.hasData && snapshot.data!.isNotEmpty
                                ? NetworkImage(snapshot.data!)
                                : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider,
                        radius: 24,
                        child:
                            snapshot.connectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator()
                                : null,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_currentLocation != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      zoom: 14,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredEvents.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.black,
                          child: ListTile(
                            title: Text(
                              event.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              event.address,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailsPage(eventId: event.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No events found matching your search'),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventPage()),
          );
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ),
    );
  }
}
