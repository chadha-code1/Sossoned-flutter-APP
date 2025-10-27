import 'package:ant_icons/ant_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/loading.dart';
import 'package:first_app/services/auth.dart';
import 'package:first_app/services/firestore.dart';
import "package:flutter/material.dart";
import 'package:first_app/models/user.dart';
import 'dart:io';
import 'package:first_app/components/constant.dart';
import 'package:first_app/components/getImage.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateUser extends StatefulWidget {
  UserData v;
  UpdateUser({this.v});
  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final key = GlobalKey<FormState>();
  int numTel;
  String gouv, cin, nomp;

  List<dynamic> images = [];
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

  UserData user = UserData();
  void initState() {
    super.initState();

    numTel = widget.v.numTel;
    cin = widget.v.cin;
    gouv = widget.v.gouv;
    user = widget.v;
    nomp = widget.v.nomP;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Modifier " + widget.v.nomP),
          backgroundColor: Colors.blue.shade900,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: nomp,
                    decoration: InputDecoration(labelText: 'Nom Prénom'),
                    keyboardType: TextInputType.name,
                    validator: (val) =>
                        val.isEmpty || val.contains('@') || val.contains('.')
                            ? 'Enter votre nom et prénom'
                            : null,
                    onChanged: (val) {
                      setState(() => nomp = val);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: numTel.toString(),
                    decoration: InputDecoration(labelText: 'Num'),
                    keyboardType: TextInputType.number,
                    validator: (val) => val.isEmpty ||
                            val.length < 8 ||
                            val.contains('@') ||
                            val.contains('.')
                        ? 'Numéro de télèphone invalide'
                        : null,
                    onChanged: (val) {
                      setState(() => numTel = int.parse(val.trim()));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: cin,
                    decoration: InputDecoration(labelText: 'CIN'),
                    keyboardType: TextInputType.number,
                    validator: (val) => val.isEmpty ||
                            val.contains('@') ||
                            val.contains('.') ||
                            val.length < 8
                        ? ' numéro de cin invalide'
                        : null,
                    onChanged: (val) {
                      setState(() => cin = val.trim());
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: height / 11,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      /* only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),*/
                    ),
                    child: Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 3),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                          hint: Text('Choisir Gouvernorat'),
                          items: city.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text("$c"),
                            );
                          }).toList(),
                          value: gouv,
                          onChanged: (val) async {
                            gouv = val;
                            setState(() {
                              v = val;

                              gouv = val;
                            });
                            ;
                          },
                        ))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue.shade900,
                      onPressed: () async {
                        if (key.currentState.validate()) {
                          user.numTel = numTel;
                          user.cin = cin;
                          user.gouv = gouv;
                          user.nomP = nomp;

                          user.uid = FirebaseAuth.instance.currentUser.uid;
                          /* for (var i = 0; i < images.length; i++) {
                            if (images[i] is File) {
                              String urlImage = await DBServices()
                                  .uploadImage(images[i], path: "cars");
                              if (urlImage != null) car.images.add(urlImage);
                            } else {
                              car.images.add(images[i]);
                            }
                          }*/
                          // if (images.length == car.images.length) {
                          bool update =
                              await FirestoreServices().updateUser(user);
                          if (update) {
                            messagesWhite('Compte mis à jours');
                            Navigator.of(context).pop();
                          }
                          ;
                          // }
                        } else {
                          messages('veuillez remplir tous les champs');
                          print("veillez remplir tous les champs");
                        }
                      },
                      child: Text("Modifier",
                          style: style.copyWith(
                              color: Colors.white, fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
