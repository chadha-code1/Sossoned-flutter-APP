import 'dart:io';

import 'package:ant_icons/ant_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/components/loading.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_app/components/getImage.dart';

class Editrec extends StatefulWidget {
  @override
  Reclamations rec;
  Editrec({this.rec});
  _EditrecState createState() => _EditrecState();
}

class _EditrecState extends State<Editrec> {
  final key = GlobalKey<FormState>();
  String type, model, prix, descrition;
  List<dynamic> images = [];
  Reclamations rec = Reclamations();
  int groupe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modifier " + widget.rec.id),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile(
                    title: Text(
                      'Coupure d\'eau',
                      style: TextStyle(
                        color: Colors.black,
                        //fontWeight: FontWeight.w700
                      ),
                    ),
                    activeColor: Color(0xff2196F3),
                    value: 1,
                    groupValue: groupe,
                    onChanged: (T) {
                      type = 'coupure';
                      setState(() {
                        groupe = 1;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      'Fuite d\'eau',
                      style: TextStyle(
                        color: Colors.black,
                        //fontWeight: FontWeight.w700
                      ),
                    ),
                    activeColor: Color(0xff2196F3),
                    value: 2,
                    groupValue: groupe,
                    onChanged: (T) {
                      type = 'fuite';
                      setState(() {
                        groupe = 2;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      'Autre',
                      style: TextStyle(
                        color: Colors.black,
                        //fontWeight: FontWeight.w700
                      ),
                    ),
                    activeColor: Color(0xff2196F3),
                    value: 3,
                    groupValue: groupe,
                    onChanged: (T) {
                      type = 'autre';
                      setState(() {
                        groupe = 3;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: prix,
                    keyboardType: TextInputType.number,
                    validator: (e) => e.isEmpty ? "Prix ce champ" : null,
                    onChanged: (e) => prix = e,
                    decoration: InputDecoration(
                        hintText: "Date ",
                        labelText: "Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: descrition,
                    validator: (e) => e.isEmpty ? "Remplir ce champ" : null,
                    onChanged: (e) => descrition = e,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Description  ",
                        labelText: "Détails",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < images.length; i++)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.4)),
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          height: 70,
                          width: 70,
                          child: Stack(
                            children: [
                              if (images[i] is File)
                                Image.file(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              if (images[i] is String)
                                Image.network(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    AntIcons.minus_circle,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(i);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      InkWell(
                        onTap: () async {
                          final data = await showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return GetImage();
                              });
                          if (data != null)
                            setState(() {
                              images.add(data);
                            });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.blue,
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade900,
                          onPrimary: Colors.white,
                          onSurface: Colors.grey,
                          shadowColor: Colors.grey,
                          elevation: 5,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          )),
                      onPressed: () async {
                        if (key.currentState.validate() && images.length > 0) {
                          loading(context);
                          rec.type = type;
                          // rec.description = model;
                          rec.etat = prix;
                          rec.description = descrition;
                          rec.images = [];
                          rec.uid = FirebaseAuth.instance.currentUser.uid;
                          for (var i = 0; i < images.length; i++) {
                            if (images[i] is File) {
                              String urlImage = await FirestoreServices()
                                  .uploadImage(images[i], path: "cars");
                              if (urlImage != null) rec.images.add(urlImage);
                            } else {
                              rec.images.add(images[i]);
                            }
                          }
                          if (images.length == rec.images.length) {
                            bool update =
                                await FirestoreServices().updateRec(rec);
                            if (update) {
                              Navigator.of(context).pop();
                            }
                            ;
                          }
                        } else {
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
