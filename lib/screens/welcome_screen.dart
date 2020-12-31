import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcomeScreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Lottie.asset(
                'Anim/animation.json',
              ),
            ),
//            Row(
//              children: <Widget>[
//                Hero(
//                  tag: "logo",
//                  child: Container(
//                    child: Image.asset('images/logo.png'),
//                    height: 60,
//                  ),
//                ),
//                Text(
//                  'Quick Chat',
//                  style: TextStyle(
//                    fontSize: 45.0,
//                    fontWeight: FontWeight.w900,
//                  ),
//                ),
//              ],
//            ),
            SizedBox(
              height: 48.0,
            ),
            Container(
              decoration: KButtonDecoration,
              child: FlatButton(
                  child: Text("Log In"),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: KButtonDecoration,
              child: FlatButton(
                child: Text("Register"),
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
