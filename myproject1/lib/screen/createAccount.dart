import 'package:flutter/material.dart';
import 'package:myproject1/method.dart';
import 'package:myproject1/screen/loginScreen.dart';

import 'homeScreen.dart';

class createAccount extends StatefulWidget {
  @override
  State<createAccount> createState() => _createAccountState();
}

class _createAccountState extends State<createAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width / 1.1,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 1.2,
                  ),
                  Container(
                    width: size.width / 1.3,
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.3,
                    child: const Text(
                      "Sign Up to continue!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "Name", Icons.tag_faces, _name),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(
                          size, "Email", Icons.account_box_rounded, _email),
                    ),
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: Container(
                      height: size.height / 15,
                      width: size.width / 1.1,
                      child: TextField(
                        obscureText: _isObscure,
                        controller: _password,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => loginScreen(),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          Signup(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              print(user.displayName);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => loginScreen()));
              print("Account Created");
            } else {
              print("Creation failed");
            }
          });
        } else {
          print("Please enter field");
        }
      },
      child: Container(
        height: size.height / 15,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: const Text(
          "Sign up",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
