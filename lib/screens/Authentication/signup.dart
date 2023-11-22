import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/screens/Authentication/sign_in.dart';
import 'package:myapp2/screens/models/userModel.dart' as model;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  bool passwordVisible = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String uid = "";

  void signUp() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      final user = userCredential.user;

      uid = user!.uid.toString();
      print("Success");
      //showAlertDialog(context, "Success");
    } catch (e) {
      //showAlertDialog(context, e.toString());
      print(e);
    }

    model.UserModel _user = model.UserModel(
        address: _address.text,
        telephoneNo: _telephone.text,
        userId: uid,
        name: _name.text);

    final docRef = db
        .collection("Users")
        .withConverter(
          fromFirestore: model.UserModel.fromFirestore,
          toFirestore: (model.UserModel user, options) => user.toFirestore(),
        )
        .doc(uid);

    await docRef.set(_user);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SigninPage()));
  }

  @override
  Widget build(BuildContext context) {
    bool checkedValue = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/man.png'),
              radius: 40,
            ),
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
                controller: _email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _password,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          })),
                )),
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
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SigninPage()));
                      },
                      child: const Text("Sign in"))
                ],
              ),
            ),
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
                  child: const Text("Sign Up")),
            )
          ],
        ),
      ),
    );
  }
}
