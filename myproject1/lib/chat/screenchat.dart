import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatelessWidget {
  final Map<String, dynamic>? userMap;
  final String? chatRoomId;
  final TextEditingController _message = TextEditingController();

  chatScreen({this.userMap, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    void onSendMessage() async {
      if (_message.text.isNotEmpty) {
        Map<String, dynamic>? messages = {
          "sendby": _auth.currentUser?.displayName,
          "message": _message.text,
          "time": FieldValue.serverTimestamp()
        };
        _message.clear();
        await _firestore
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .add(messages);
      } else {
        print("Enter some text to");
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userMap?['name']),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: size.height / 1.25,
            width: size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      });
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      )),
      bottomNavigationBar: Container(
        height: size.height / 12,
        width: size.width,
        alignment: Alignment.center,
        child: Container(
          height: size.height / 12,
          width: size.width / 1.1,
          child: Row(
            children: [
              Container(
                height: size.height / 17,
                width: size.width / 1.3,
                alignment: Alignment.center,
                child: TextField(
                  controller: _message,
                  decoration: InputDecoration(
                    hintText: "Send a message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: onSendMessage, icon: Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.blue),
        child: Text(
          map['message'],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
