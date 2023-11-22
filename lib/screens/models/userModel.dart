import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String? address;
  final String? telephoneNo;
  final String? name;

  UserModel({this.userId, this.address, this.telephoneNo, this.name});

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
        userId: data?['userId'],
        address: data?['address'],
        telephoneNo: data?['telephoneNo'],
        name: data?['name']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "userId": userId,
      if (address != null) "address": address,
      if (telephoneNo != null) "telephoneNo": telephoneNo,
      if (name != null) "name": name,
    };
  }
}
