import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/screens/models/userModel.dart' as userModel;
import 'package:myapp2/screens/models/letterModel.dart' as letterModel;
import 'package:http/http.dart' as http;

class LetterDetails extends StatefulWidget {
  final String trackingID;
  const LetterDetails({super.key, required this.trackingID});

  @override
  State<LetterDetails> createState() => _LetterDetailsState();
}

class _LetterDetailsState extends State<LetterDetails> {
  final db = FirebaseFirestore.instance;
  String senderName = "";
  String? senderAddress = "";
  String? senderTelephone = "";
  String receiverName = "";
  String? receiverAddress = "";
  String? receiverTelephone = "";
  String? status = "";
  String? senderID = "";
  String selectedValue = "Pending";
  String? receiverEmail = '';
  String? senderEmail = "";
  //String status_post = 'Pending';

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

  String myString = '';
  void getData() async {
    myString = FirebaseAuth.instance.currentUser!.email!;

    final ref = db.collection("Letters").doc(widget.trackingID).withConverter(
          fromFirestore: letterModel.LetterModel.fromFirestore,
          toFirestore: (letterModel.LetterModel letter, _) =>
              letter.toFirestore(),
        );
    final docSnap = await ref.get();
    final letterDetailsData = docSnap.data();
    if (letterDetailsData != null) {
      receiverName = letterDetailsData.receivername!;
      receiverAddress = letterDetailsData.receiveraddress;
      receiverTelephone = letterDetailsData.receivertelephoneNo;
      senderID = letterDetailsData.senderuserId;
      status = letterDetailsData.status;
      selectedValue = status!;
      receiverEmail = letterDetailsData.receiverEmail;
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
      senderName = userDetailsData.name!;
      senderAddress = userDetailsData.address;
      senderTelephone = userDetailsData.telephoneNo;
      senderEmail = userDetailsData.email;
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
    Future sendEmail({
      required String name,
      required String email,
      required String subject,
      required String message,
    }) async {
      const serviceId = 'service_7uicxgb';
      const templateId = 'template_0izzoxq';
      const userId = 'dzlSXk5kQqYW_OC3Q';
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      // Create a map to represent the template parameters
      Map<String, String> templateParams = {
        'to_name': name,
        'user_email': email,
        'subject': subject,
        'message': message,
      };

      // Convert the map to a JSON string
      String jsonBody = jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': templateParams,
      });
      print(status);
      // Use the http.post method with proper headers and JSON body
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: jsonBody,
      );

      // Print the response body for debugging purposes
      print(response.body);
    }

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
                    onPressed: () async {
                      try {
                        updateStatus();
                        showAlertDialog(context);
                        print(senderEmail);
                        print(receiverEmail);
                        //sender email
                        await sendEmail(
                          email: senderEmail!,
                          message:
                              "Your outgoing letter status is $selectedValue",
                          name: senderName,
                          subject: "POST OFFICE",
                        );

                        //reciver email
                        await sendEmail(
                          email: receiverEmail!,
                          message:
                              "Your incoming letter status is $selectedValue",
                          name: receiverName,
                          subject: "POST OFFICE",
                        );
                      } catch (e) {
                        print(e.toString());
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
