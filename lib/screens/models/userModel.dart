import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String? address;
  final String? telephoneNo;
  final String? name;
  final String? email;

  UserModel(
      {this.userId, this.address, this.telephoneNo, this.name, this.email});

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
        userId: data?['userId'],
        address: data?['address'],
        telephoneNo: data?['telephoneNo'],
        name: data?['name'],
        email: data?['email']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "userId": userId,
      if (address != null) "address": address,
      if (telephoneNo != null) "telephoneNo": telephoneNo,
      if (name != null) "name": name,
      if (email != null) "email": email,
    };
  }
}
