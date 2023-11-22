import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/screens/models/letterModel.dart' as model;

class TrackLetter extends StatefulWidget {
  const TrackLetter({super.key});

  @override
  State<TrackLetter> createState() => _TrackLetterState();
}

class _TrackLetterState extends State<TrackLetter> {
  final TextEditingController _trackingID = TextEditingController();
  final db = FirebaseFirestore.instance;

  String? receiverName = "";
  String? receiverAddress = "";
  String? receiverTelephone = "";
  String? status = "";
  String trackingID = "";

  void getData() async {
    trackingID = _trackingID.text;
    final ref = db.collection("Letters").doc(trackingID).withConverter(
          fromFirestore: model.LetterModel.fromFirestore,
          toFirestore: (model.LetterModel letter, _) => letter.toFirestore(),
        );
    final docSnap = await ref.get();
    final letterData = docSnap.data();
    if (letterData != null) {
      receiverName = letterData.receivername;
      status = letterData.status;
      receiverAddress = letterData.receiveraddress;
      receiverTelephone = letterData.receivertelephoneNo;
    } else {
      print("No such document.");
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Letter Details"),
      content: Container(
        alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Receiver Name: $receiverName",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              "Receiver Address: $receiverAddress",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              "Receiver Telephone No: $receiverTelephone",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              "Status: $status",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Track Letter"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _trackingID,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Tracking ID',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    getData();
                    showAlertDialog(context);
                  },
                  child: const Text("Track Letter")),
            )
          ],
        ),
      ),
    );
  }
}
