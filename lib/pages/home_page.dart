import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterencryption/components/drawer.dart';
import 'package:flutterencryption/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

//APPBAR
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: _buildUserList(),
    );
  }
  //APPBAR

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return builderUserListItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget builderUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
        leading: const CircleAvatar(
          backgroundImage:
              AssetImage('assets/avatar.png'), // Replace with image asset
          radius: 24,
          backgroundColor: Color(0xFFE2EBF0),
        ),
        title: Text(
          data['email'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'Last message...', // Replace with the actual last message
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '12:34 PM', // Replace with actual time
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 6,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(); // Hide the current user's entry
    }
  }
  //overall userlist
}
