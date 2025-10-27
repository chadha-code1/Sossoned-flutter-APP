import 'package:first_app/models/user.dart';
import 'package:first_app/ui/reclamation/add_reclamation.dart';
import 'package:first_app/ui/reclamation/editReclamation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:first_app/components/reclamationCard.dart';

class Reclamation extends StatefulWidget {
  UserData user;
  Reclamation({this.user});
  @override
  _ReclamationState createState() => _ReclamationState();
}

class _ReclamationState extends State<Reclamation> {
  @override
  Widget build(BuildContext context) {
    final List<Reclamations> recs = Provider.of<List<Reclamations>>(context);
    //final UserData userl = Provider.of<UserData>(context);
    String key = '';

    print(recs);
    return Scaffold(
        appBar: AppBar(
          title: Text('Mes réclamations'),
          backgroundColor: Colors.blue.shade900,
        ),
        body: recs == null
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
            : recs.length == 0
                ? Center(
                    child: Text("Aucune reclamation"),
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
                                return i == recs.length - 1
                                    ? Container(
                                        child: recCard(
                                          rec: rec,
                                          user: widget.user,
                                        ),
                                        margin: EdgeInsets.only(bottom: 80),
                                      )
                                    : recCard(rec: rec, user: widget.user);

                                // Text(recs[i].description);
                              }),
                        ),
                      ],
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade900,
          child: Icon(Icons.note_add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => Ajouter_reclamation(user: widget.user)));
          },
        ));
  }
}
