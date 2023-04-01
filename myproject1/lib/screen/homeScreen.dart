// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myproject1/chat/screenchat.dart';
import 'package:myproject1/method.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? mapUser;
  bool isLoading = false;
  final TextEditingController _email = TextEditingController();

  String chatRoomID(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onsearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where('email', isEqualTo: _email.text)
        .get()
        .then((value) {
      setState(() {
        mapUser = value.docs[0].data();
        isLoading = false;
      });
      // print(mapUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final name = user?.displayName;
    final size = MediaQuery.of(context).size;
    print(name);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () => logout(context),
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.12,
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                ElevatedButton(
                  onPressed: onsearch,
                  child: Text("Search"),
                ),
                mapUser != null
                    ? ListTile(
                        onTap: () {
                          print(_auth.currentUser!.displayName!);
                          String roomId = chatRoomID(name!, mapUser!['name']);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => chatScreen(
                                chatRoomId: roomId,
                                userMap: mapUser!,
                              ),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.account_circle_rounded,
                          color: Colors.black,
                        ),
                        title: Text(
                          mapUser!['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(mapUser!['email'],
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        trailing: Icon(
                          Icons.message_rounded,
                          color: Colors.black,
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
