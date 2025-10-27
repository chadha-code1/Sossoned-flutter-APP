import 'package:first_app/models/reclamation.dart';
import 'package:flutter/material.dart';

class RecDesc extends StatelessWidget {
  Reclamations rec;
  RecDesc({this.rec});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamation Detail'),
      ),
      body: Stack(children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
              Colors.blue[50],
              Colors.blue,
              Colors.blue[900],
            ]))),
        Center(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                    height: 540,
                    width: 300,
                    padding: EdgeInsets.all(16),
                    child: ListTile(
                      title: Text(rec.description),
                    )))),
      ]),
    );
  }
}
