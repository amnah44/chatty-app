import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

extension ToastManger on String {
  void toToast() {
    Fluttertoast.showToast(
      msg: this,
      fontSize: 16,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
