import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp2/screens/letterDetails.dart';

class LetterCard extends StatefulWidget {
  final snap;
  const LetterCard({super.key, required this.snap});

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard> {
  String? trackingId;
  String? senderName;
  String? senderAddress;
  String? senderTelephone;
  String? receiverName;
  String? receiverAddress;
  String? receiverTelephone;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => LetterDetails(
                              trackingID: widget.snap['trackingID'],
                            ))));
              },
              child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      "Tracking ID: " + widget.snap['trackingID'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Status: " + widget.snap['status'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    trailing: Text(
                      widget.snap['receiveraddress'],
                      style: const TextStyle(
                          fontSize: 13, color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                  )),
            ),
            const Divider(
              color: Color.fromARGB(255, 176, 175, 170),
            )
          ],
        ));
  }
}
