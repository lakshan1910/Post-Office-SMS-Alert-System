import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/screens/models/letterModel.dart' as model;

class RegisterLetter extends StatefulWidget {
  const RegisterLetter({super.key});

  @override
  State<RegisterLetter> createState() => _RegisterLetterState();
}

class _RegisterLetterState extends State<RegisterLetter> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  String? uid = "";

  showAlertDialog(BuildContext context, String content) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Registration Success"),
      content: Text(
        "Your tracking ID: $content",
        style: const TextStyle(fontSize: 20),
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

  void signUp() async {
    uid = user?.uid.toString();

    model.LetterModel _letter = model.LetterModel(
        receiveraddress: _address.text,
        receivertelephoneNo: _telephone.text,
        senderuserId: uid,
        receivername: _name.text,
        status: "Pending");

    final docRef = db
        .collection("Letters")
        .withConverter(
          fromFirestore: model.LetterModel.fromFirestore,
          toFirestore: (model.LetterModel letter, options) =>
              letter.toFirestore(),
        )
        .doc();

    await docRef.set(_letter);

    model.LetterModel _letterUpdate =
        model.LetterModel(trackingID: docRef.id.toString());

    final docRef2 = db
        .collection("Letters")
        .withConverter(
          fromFirestore: model.LetterModel.fromFirestore,
          toFirestore: (model.LetterModel letter, options) =>
              letter.toFirestore(),
        )
        .doc(docRef.id.toString());

    await docRef2.set(_letterUpdate);

    _name.clear();
    _address.clear();
    _telephone.clear();

    showAlertDialog(context, docRef.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Register Letter"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * 0.1,
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _telephone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Telephone Number',
                  ),
                )),
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
                    signUp();
                  },
                  child: Text("Add")),
            )
          ],
        ),
      ),
    );
  }
}




            // TextField(
            //   decoration: InputDecoration(
            //     labelText: "Enter Tracking number here",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // SizedBox(height: 40),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20)),
            //     primary: Colors.purple, // sets the background color
            //     minimumSize: Size(100, 50), // sets the button size
            //   ),
            //   onPressed: () {
            //     // Implement submit button functionality here
            //   },
            //   child: Text("Submit"),
            // ),