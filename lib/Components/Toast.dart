import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(dynamic text) {
  Fluttertoast.showToast(
      msg: text.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0);
}
