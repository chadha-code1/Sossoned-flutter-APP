import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AjoutDossier extends StatefulWidget {
  UserData user;
  AjoutDossier({this.user});
  @override
  AjoutDossierState createState() => AjoutDossierState();
}

class AjoutDossierState extends State<AjoutDossier> {
  final key = GlobalKey<FormState>();
  // DateTime datedoss =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//final now = new DateTime.now();
  //DateTime datedoss = DateFormat('yMd').format(new DateTime.now());
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String datedoss = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

  //String string = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
  DateTime datesys = DateFormat("yyyy-MM-dd HH:mm")
      .parse(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()));

  String cin;
  int idDossier;
  String gouv, uid;
  Dossier dem = Dossier();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ajouter un dossier"),
          // actions: [Icon(FontAwesomeIcons.carAlt)],
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
                        validator: (e) => e.isEmpty ? "Remplir ce champ" : null,
                        keyboardType: TextInputType.number,
                        onChanged: (e) => cin = e.trim(),
                        decoration: InputDecoration(
                            hintText: "CIN",
                            labelText: "CIN",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (e) => e.isEmpty ? "Remplir ce champ" : null,
                        keyboardType: TextInputType.number,
                        onChanged: (e) => idDossier = int.parse(e.trim()),
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: "Numéro Dossier",
                            labelText: "Numéro Dossier",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 10,
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
                                if (key.currentState.validate()) {
                                  // loading(context);
                                  dem.cin = cin;
                                  dem.dateDoss = datedoss;
                                  dem.datesys = datesys;

                                  dem.idDossier = idDossier;
                                  dem.gouv = widget.user.gouv;
                                  dem.uid = widget.user.uid;

                                  //  dem.etat = '1ère phase';

                                  bool save = await FirestoreServices()
                                      .saveDemDoss(dem);
                                  if (save) {
                                    messagesWhite("Dossier ajouté");

                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  print("veuillez remplir tous les champs");
                                  messages('veuillez remplir tous les champs');
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
}
