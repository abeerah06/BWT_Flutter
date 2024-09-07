import 'package:carpoolbuddy/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/chat_service.dart';
import 'chat_page.dart';

class Messages extends StatelessWidget {
  Messages({super.key});
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Optional: Set background color
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading users."));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loader
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    // Ensure currentUser is not null and avoid rendering the current user
    if (currentUser != null && userData['email'] != currentUser.email) {
      return UserTile(
        text: userData['name'] ?? 'Unknown', // Handle null safety for name
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverName: userData['name'] ?? 'Unknown',
                  receiverID: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return const SizedBox
          .shrink(); // Return an empty widget for the current user
    }
  }
}
