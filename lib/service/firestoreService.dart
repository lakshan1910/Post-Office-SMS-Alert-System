import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Function to add data to Firestore
  void addData(TextEditingController _field1Controller,
      TextEditingController _field2Controller) async {
    try {
      await _firestore.collection('names').add({
        'name1': _field1Controller.text,
        'name2': _field2Controller.text,
        // Add more fields as needed
      });
      // print('Data added to Firestore');
    } catch (e) {
      print('Error adding data: $e');
    }
  }
}
