import 'package:carpoolbuddy/services/auth_service.dart';
import 'package:carpoolbuddy/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverID;

  const ChatPage({super.key, required this.receiverName, required this.receiverID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _chatService.sendMessage(
            widget.receiverID, _messageController.text);
        _messageController.clear();
      } catch (e) {
        // Display error message or handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    String senderID =
        _authService.getcurrentUser()?.uid ?? ''; // Ensure current user exists
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageListItem(snapshot.data!.docs[index], senderID);
          },
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageListItem(DocumentSnapshot doc, String senderID) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSentByCurrentUser = data['senderID'] == senderID;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSentByCurrentUser ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            data['message'] ?? '', // Handle null safety
            style: TextStyle(
              color: isSentByCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // User input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: sendMessage,
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
