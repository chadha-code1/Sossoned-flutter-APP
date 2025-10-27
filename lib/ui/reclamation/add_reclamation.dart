import 'package:ant_icons/ant_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/components/getImage.dart';
import 'package:first_app/components/loading.dart';
import 'package:first_app/models/stats.dart';
import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/services/firestore.dart';
//import 'package:first_app/utils/constant.dart';
//import 'package:first_app/utils/getImage.dart';
//import 'package:first_app/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class Ajouter_reclamation extends StatefulWidget {
  UserData user;
  Ajouter_reclamation({this.user});
  @override
  _Ajouter_reclamationState createState() => _Ajouter_reclamationState();
}

int v;
countDocuments({String date}) async {
  var _myDoc = await FirebaseFirestore.instance
      .collection('Reclamations')
      .where('dateStat', isEqualTo: date)
      .get();
  List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  print(_myDocCount.length);
  v = _myDocCount.length;

  // Count of Documents in Collection
  return v;
}

class _Ajouter_reclamationState extends State<Ajouter_reclamation> {
  Position _currentPosition;
  String _currentAddress;
  // DateTime daterec =
  // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime datesys = DateFormat("yyyy-MM-dd HH:mm")
      .parse(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()));
  String daterec = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

  final key = GlobalKey<FormState>();
  String type, description, cin, photo;
  String etat;
  Reclamations rec = Reclamations();
  Stats s = Stats();
  List<File> images = [];
  int groupe;
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter une reclamation"),
          // actions: [Icon(FontAwesomeIcons.carAlt)],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                          type = 'Coupure d\'eau';
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
                          type = 'Fuite d\'eau';
                          setState(() {
                            groupe = 2;
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          'Autres',
                          style: TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.w700
                          ),
                        ),
                        activeColor: Color(0xff2196F3),
                        value: 3,
                        groupValue: groupe,
                        onChanged: (T) {
                          type = 'Autres';
                          setState(() {
                            groupe = 3;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //photoooooooooooooooooooooooooooooooooooooooooooo
                      /* TextFormField(
                             keyboardType: TextInputType.number,
                             validator: (e) => e.isEmpty ? "Prix ce champ" : null,
                             onChanged: (e) => photo = e,
                             decoration: InputDecoration(
                                 hintText: "photo",
                                 labelText: "Photo",
                                 border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10))),
                           ),*/
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (e) => e.isEmpty ? "Remplir ce champ" : null,
                        onChanged: (e) => description = e,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: "Décrire votre réclamation",
                            labelText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_currentAddress != null) Text(_currentAddress),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade900,
                        ),
                        child: Text("Entrer votre localisation"),
                        onPressed: () {
                          // _getCurrentLocation();
                          _getCurrentLocation();
                        },
                      ),
                      // Text(
                      // "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
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
                                  Image.file(
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
                              if (data != null) {
                                setState(() {
                                  images.add(data);
                                });
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.blue.shade900,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                            ),
                            ElevatedButton(
                              child: Text('Annuler'),

                              onPressed: () {
                                key.currentState.reset();
                              },
                              //**********boutton */
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey.shade500,
                                onPrimary: Colors.white,
                                onSurface: Colors.grey,
                                shadowColor: Colors.grey,
                                elevation: 5,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue.shade900,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.grey,
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  )),
                              onPressed: () async {
                                if (key.currentState.validate() &&
                                    type != null) {
                                  loading(context);
                                  rec.gouv = widget.user.gouv;
                                  rec.etat = etat;
                                  rec.description = description;
                                  rec.dateStat = daterec.substring(0, 4);
                                  rec.type = type;
                                  rec.uid =
                                      FirebaseAuth.instance.currentUser.uid;

                                  rec.images = [];
                                  rec.localisation = _currentAddress;
                                  rec.dateRec = daterec;
                                  countDocuments(date: daterec.substring(0, 4));
                                  print(v);

                                  for (var i = 0; i < images.length; i++) {
                                    String urlImage = await FirestoreServices()
                                        .uploadImage(images[i],
                                            path:
                                                "recs"); //path recs*************************
                                    if (urlImage != null)
                                      rec.images.add(urlImage);
                                  }

                                  bool save =
                                      await FirestoreServices().saveRec(rec);
                                  if (save) {
                                    //*****countRecs */
                                    messagesBleu("Réclamation ajoutée");
                                    Navigator.of(context).pop();
                                    print('success');
                                  }
                                } else {
                                  print("veuillez remplir tous les champs");
                                  messages('veuillez remplir tous les champs');
                                }

                                //************************added stats************* */
                                s.nbr = v;
                                s.year = rec.dateRec.substring(0, 4);
                                bool sv =
                                    await FirestoreServices().updateStat(s);
                                if (sv) {
                                  print('stat added');
                                } else {
                                  print('stat not added');
                                }
                              },
                              child: Text("Enregistrer",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return _getCurrentLocation();
    //await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = " ${place.country},${place.street}";
      });
    } catch (e) {
      print(e);
    }
  }
}
