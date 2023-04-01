import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject1/screen/homeScreen.dart';
import 'package:myproject1/screen/loginScreen.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      return HomeScreen();
    } else {
      return loginScreen();
    }
  }
}
