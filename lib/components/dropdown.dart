import 'package:first_app/models/user.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  String gouv;
  DropDown({this.gouv});
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List<String> city = [
    'Ariana',
    'Béja',
    'Ben Arous',
    'Bizert',
    'Gabès',
    'Gafsa',
    'Kairouan',
    'Kasserine',
    'Kébili',
    'Kef',
    'Mahdia',
    'Manouba',
    'Médenine',
    'Mounastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan'
  ];
  String v = 'Choisir Gouvernorat';
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      items: city.map((c) {
        return DropdownMenuItem(
          value: c,
          child: Text("$c"),
        );
      }).toList(),
      value: widget.gouv,
      onChanged: (val) async {
        widget.gouv = val;
        setState(() {
          v = val;

          widget.gouv = val;
        });
        ;
      },
    ));
  }
}
