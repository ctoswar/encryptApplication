import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterencryption/components/chat_bubble.dart';
import 'package:flutterencryption/components/my_text_field_chat.dart';
import 'package:flutterencryption/services/chat/chat_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String serverURL =
      'http://192.168.1.7:5000'; // Replace with your Flask server address

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Encrypt the message before sending it
      final encryptedMessage = await _encryptMessage(_messageController.text);

      await _chatService.sendMessage(widget.receiverUserID, encryptedMessage);
      _messageController.clear();
    }
  }

  Future<String> _encryptMessage(String message) async {
    final response = await http.post(
      Uri.parse('$serverURL/encrypt'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['encrypted_message'];
    } else {
      throw Exception('Failed to encrypt message');
    }
  }

  Future<String> _decryptMessage(String encryptedMessage) async {
    final response = await http.post(
      Uri.parse('$serverURL/decrypt'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'encrypted_text': encryptedMessage}),
    );

    if (response.statusCode == 200) {
      final decryptedData = jsonDecode(response.body);
      final originalText = decryptedData['original_text'];
      final paddingBytes = decryptedData['padding_bytes']; // If applicable

      // Print debug information
      print('Encrypted Message: $encryptedMessage');
      print('Original Text: $originalText');
      print('Padding Bytes: $paddingBytes');

      return originalText;
    } else {
      throw Exception('Failed to decrypt message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverUserEmail,
          style: const TextStyle(
            color: Colors.white, // Set text color to black
          ),
        ),
        backgroundColor: Colors.black, // Set app bar background color
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back button color to black
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ...

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error Server is down at the moment');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              // ignore: non_constant_identifier_names
              .map((Document) => _buildMessageItem(Document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Decrypt the message here asynchronously
    Future<String> decryptedMessageFuture = _decryptMessage(data['message']);

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder<String>(
              future: decryptedMessageFuture,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                      'Decrypting...'); // Display a loading message while decrypting.
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ChatBubble(
                      message: snapshot.data ?? 'Failed to decrypt');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MyTextField_chat(
                  controller: _messageController,
                  hint: 'Enter message',
                  obscureText: false,
                  backgroundColor: Colors.grey,
                  background: Colors.grey,
                ),
              ),
              const SizedBox(
                  width: 10), // Add spacing between MyTextField and Send button
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Send",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
