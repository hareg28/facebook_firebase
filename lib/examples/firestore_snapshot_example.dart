// Example: How to use Firestore Service for Snapshots
//
// This file demonstrates how to use the FirestoreService to listen to real-time
// snapshots from Firestore collections and documents.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class FirestoreSnapshotExample extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  FirestoreSnapshotExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Snapshots Example')),
      body: Column(
        children: [
          // Example 1: Stream a collection snapshot
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.streamCollection('users'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? 'Unknown'),
                      subtitle: Text(data['email'] ?? 'No email'),
                    );
                  },
                );
              },
            ),
          ),
          
          // Example 2: Stream a single document snapshot
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _firestoreService.streamDocument('users', 'userId123'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Document not found'));
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Name: ${data['name'] ?? 'Unknown'}'),
                      Text('Email: ${data['email'] ?? 'No email'}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage in a Controller (with GetX):
/*
class UserController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  
  Stream<QuerySnapshot> getUsers() {
    return _firestoreService.streamCollection('users');
  }
  
  Stream<DocumentSnapshot> getUser(String userId) {
    return _firestoreService.streamDocument('users', userId);
  }
  
  Future<void> addUser(Map<String, dynamic> userData) async {
    await _firestoreService.addDocument('users', userData);
  }
  
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _firestoreService.updateDocument('users', userId, updates);
  }
}
*/

