import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

extension ToastManger on String {
  void toToast() {
    Fluttertoast.showToast(
      msg: this,
      fontSize: 16,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
