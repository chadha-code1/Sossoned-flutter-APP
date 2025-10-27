import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text('Submit'),
        onPressed: () {
          print('Pressed');
          // _submit();
        },
        style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSurface: Colors.grey,
            shadowColor: Colors.red,
            elevation: 5,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            )),
      ),
    );
  }
}
