import 'package:cloud_firestore/cloud_firestore.dart';

class LetterModel {
  final String? senderuserId;
  final String? receiveraddress;
  final String? receivertelephoneNo;
  final String? receivername;
  final String? status;
  final String? trackingID;
  final String? receiverEmail;

  LetterModel(
      {this.senderuserId,
      this.receiveraddress,
      this.receivertelephoneNo,
      this.receivername,
      this.status,
      this.trackingID,
      this.receiverEmail});

  factory LetterModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LetterModel(
        status: data?['status'],
        senderuserId: data?['senderuserId'],
        receiveraddress: data?['receiveraddress'],
        receivertelephoneNo: data?['receivertelephoneNo'],
        receivername: data?['receivername'],
        trackingID: data?['trackingID'],
        receiverEmail: data?['receiverEmail']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (senderuserId != null) "senderuserId": senderuserId,
      if (status != null) "status": status,
      if (receiveraddress != null) "receiveraddress": receiveraddress,
      if (receivertelephoneNo != null)
        "receivertelephoneNo": receivertelephoneNo,
      if (receivername != null) "receivername": receivername,
      if (trackingID != null) "trackingID": trackingID,
      if (receiverEmail != null) "receiverEmail": receiverEmail,
    };
  }
}
