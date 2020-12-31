import 'dart:convert';

import 'package:flash_chat/Services/Networking.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "RegistrationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email = "", password = "";
  NetworkHelper networkHelper;
  SharedPreferences _prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    networkHelper = NetworkHelper();
    getSharedPrefernece();
  }

  void getSharedPrefernece() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    KTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                decoration: KButtonDecoration,
                child: FlatButton(
                    child: Text("Register"),
                    onPressed: () async {
                      if (isUserValid()) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          http.Response response = await networkHelper
                              .registerUser(email: email, password: password);
                          if (response.statusCode == 200) {
                            var responseEmail =
                                jsonDecode(response.body)["email"];
                            var responseToken =
                                response.headers["x-auth-token"];

                            _prefs.setString("token", responseToken.toString());
                            _prefs.setString("email", responseEmail);
                            Navigator.popAndPushNamed(context, ChatScreen.id);
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isUserValid() {
    return (email.length > 1 && password.length > 5);
  }
}
