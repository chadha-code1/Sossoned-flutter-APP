import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextStyle style = TextStyle(color: Colors.black, fontSize: 25);

mydialog(BuildContext context,
    {String title, String content, VoidCallback ok}) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: ok,
              child: Text("Oui"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("Non"),
            ),
          ],
        );
      });
}

messages(String msg) {
  return Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

messagesBleu(String msg) {
  return Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.white,
      textColor: Colors.blue,
      fontSize: 16.0);
}

messagesWhite(String msg) {
  return Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue.shade900,
      textColor: Colors.white,
      fontSize: 16.0);
}
