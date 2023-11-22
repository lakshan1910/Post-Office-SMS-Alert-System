import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/screens/models/userModel.dart' as userModel;
import 'package:myapp2/screens/models/letterModel.dart' as letterModel;

class LetterDetails extends StatefulWidget {
  final String trackingID;
  const LetterDetails({super.key, required this.trackingID});

  @override
  State<LetterDetails> createState() => _LetterDetailsState();
}

class _LetterDetailsState extends State<LetterDetails> {
  final db = FirebaseFirestore.instance;
  String? senderName = "";
  String? senderAddress = "";
  String? senderTelephone = "";
  String? receiverName = "";
  String? receiverAddress = "";
  String? receiverTelephone = "";
  String? status = "";
  String? senderID = "";
  String selectedValue = "Pending";

  Future<void> updateStatus() {
    return db
        .collection('Letters')
        .doc(widget.trackingID)
        .update({'status': selectedValue})
        .then((value) => print("Status Updated"))
        .catchError((error) => print("Failed to update status: $error"));
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Status Update"),
      content: Text(
        "Status Update Success",
        textAlign: TextAlign.center,
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

  void getData() async {
    final ref = db.collection("Letters").doc(widget.trackingID).withConverter(
          fromFirestore: letterModel.LetterModel.fromFirestore,
          toFirestore: (letterModel.LetterModel letter, _) =>
              letter.toFirestore(),
        );
    final docSnap = await ref.get();
    final letterDetailsData = docSnap.data();
    if (letterDetailsData != null) {
      receiverName = letterDetailsData.receivername;
      receiverAddress = letterDetailsData.receiveraddress;
      receiverTelephone = letterDetailsData.receivertelephoneNo;
      senderID = letterDetailsData.senderuserId;
      status = letterDetailsData.status;
      selectedValue = status!;
    } else {
      print("No such document.");
    }

    final ref2 = db.collection("Users").doc(senderID).withConverter(
          fromFirestore: userModel.UserModel.fromFirestore,
          toFirestore: (userModel.UserModel user, _) => user.toFirestore(),
        );
    final docSnap2 = await ref2.get();
    final userDetailsData = docSnap2.data();
    if (userDetailsData != null) {
      senderName = userDetailsData.name;
      senderAddress = userDetailsData.address;
      senderTelephone = userDetailsData.telephoneNo;
    } else {
      print("No such document.");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  var statuses = ["Pending", "Processed", "Delivered"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Letter Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Tracking ID:\n ${widget.trackingID}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sender Name: $senderName",
                style: const TextStyle(fontSize: 18),
              ),
              Text("Sender Address: $senderAddress",
                  style: const TextStyle(fontSize: 18)),
              Text("Sender Telephone: $senderTelephone",
                  style: const TextStyle(fontSize: 18)),
              Text("Receiver Name: $receiverName",
                  style: const TextStyle(fontSize: 18)),
              Text("Receiver Address: $receiverAddress",
                  style: const TextStyle(fontSize: 18)),
              Text("Receiver Telephone: $receiverTelephone",
                  style: const TextStyle(fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Status: ", style: TextStyle(fontSize: 18)),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                    value: selectedValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: statuses.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      try {
                        updateStatus();
                        showAlertDialog(context);
                      } catch (e) {
                        print("Failed");
                      }
                    },
                    icon: const Icon(Icons.update),
                    label: const Text(
                      "Update record Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
