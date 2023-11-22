import 'package:flutter/material.dart';
//import 'package:myapp2/screens/Authentication/authentication.dart';
import 'package:provider/provider.dart';

import 'alldetails.dart';
import 'models/userModel.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //the user data that the provider proides this can be a user data or can be null.
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return AllDetails();
    } else {
      return AllDetails();
    }
  }
}
