import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/Authentication/sign_in.dart';
import 'package:myapp2/screens/models/userModel.dart' as model;

import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  String? uid = "";
  String? name = "";
  String? address = "";
  String? telephone = "";

  void getData() async {
    uid = user?.uid.toString();
    final ref = db.collection("Users").doc(uid).withConverter(
          fromFirestore: model.UserModel.fromFirestore,
          toFirestore: (model.UserModel user, _) => user.toFirestore(),
        );
    final docSnap = await ref.get();
    final userPofileData = docSnap.data();
    if (userPofileData != null) {
      name = userPofileData.name;

      address = userPofileData.address;
      telephone = userPofileData.telephoneNo;
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.amberAccent),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/man.png'),
                    radius: 30,
                  ),
                  Text(
                    name!,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              address!,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(telephone!, style: const TextStyle(fontSize: 25)),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout", style: TextStyle(fontSize: 20)),
            onTap: () async {
              try {
                await auth.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SigninPage()));
              } catch (e) {
                print(e.toString());
              }
            },
          )
        ],
      ),
    );
  }
}
