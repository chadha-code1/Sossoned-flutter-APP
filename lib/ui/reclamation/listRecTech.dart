import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/reclamationCard.dart';
import 'package:first_app/components/slider.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReclmationTech extends StatefulWidget {
  UserData user;
  ReclmationTech({this.user});
  @override
  _ReclmationTechState createState() => _ReclmationTechState();
}

class _ReclmationTechState extends State<ReclmationTech>
    with TickerProviderStateMixin {
  final CollectionReference recCol =
      FirebaseFirestore.instance.collection("Reclamations");
  @override
  Widget build(BuildContext context) {
    final List<Reclamations> recs = Provider.of<List<Reclamations>>(context);
    String key = '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des réclamations',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          /* recs == null
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ))
          :*/
          recs.length == 0
              ? Center(
                  child: Text("Aucune reclamations"),
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, bottom: 30.0),
                        child: TextField(
                          // controller: _searchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Rechercher réclamation'),
                          onChanged: (value) {
                            // Update the key when the value changes.
                            setState(() => key = value);
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: recs == null ? 0 : recs.length,
                            itemBuilder: (ctx, i) {
                              final rec = recs[i];
                              return Container(
                                child: recCard(rec: rec, user: widget.user),
                                margin: EdgeInsets.only(bottom: 80),
                              );

                              // Text(recs[i].description);
                            }),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class RecDetail extends StatefulWidget {
  final Reclamations v;
  RecDetail({this.v});

  @override
  _RecDetailState createState() => _RecDetailState();
}

class _RecDetailState extends State<RecDetail> {
  Color color = Colors.blue.shade900;

  UserData user;

  getUser() async {
    final u = await FirestoreServices().getUser(widget.v.uid);
    if (u != null) {
      setState(() {
        user = u;
      });
    } else {
      print('user null');
    }
  }

  void initState() {
    //  implement initState
    super.initState();

    getUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(widget.v.type),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Sliders(imgs: widget.v.images),
        SizedBox(
          height: 10,
        ),
        item(widget.v.description, Icons.text_fields ?? ''),
        item(widget.v.etat, Icons.timelapse ?? ''),
        Divider(
          color: Colors.black,
        ),
        Text("User"),
        Divider(
          color: Colors.black,
        ),
        if (user != null)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              backgroundImage:
                  user.image != null ? NetworkImage(user.image) : null,
              child: user.image != null
                  ? Container()
                  : Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
              radius: 30,
            ),
            subtitle: Text(user.email ?? ''),
            trailing: Text(user.gouv ?? ''),
          ),
        SizedBox(
          height: 10,
        ),
      ])),
    );
  }

  ListTile item(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title ?? '',
        //  style: style.copyWith(fontSize: 20),
      ),
    );
  }
}

/*class Editrec extends StatefulWidget {
  @override
  Reclamations rec;
  Editrec({this.rec});
  _EditrecState createState() => _EditrecState();
}

class _EditrecState extends State<Editrec> {
  final key = GlobalKey<FormState>();

  Reclamations rec = Reclamations();
  int groupe;
  String resultat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compte-rendu " + widget.rec.id ?? 'no_id'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: resultat,
                    validator: (e) => e.isEmpty ? "Remplir ce champ" : null,
                    onChanged: (e) {
                      setState(() => resultat = e);
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "compte-rendu",
                        labelText: "compte rendu de la réclamtion",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                      child: Text('Confirmer'),
                      onPressed: () async {
                        if (key.currentState.validate()) {
                          rec.date = resultat;
                          bool update =
                              await FirestoreServices().updateRec(rec);

                          if (update) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  
}*/
