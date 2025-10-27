import 'package:first_app/models/user.dart';
import 'package:first_app/ui/Admin/recArchive.dart';
import 'package:first_app/ui/reclamation/add_reclamation.dart';
import 'package:first_app/ui/reclamation/editReclamation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:first_app/components/reclamationCard.dart';

class ListeRecs extends StatefulWidget {
  UserData user;
  ListeRecs({this.user});
  @override
  _ListeRecsState createState() => _ListeRecsState();
}

UserData useru;

class _ListeRecsState extends State<ListeRecs> {
  @override
  Widget build(BuildContext context) {
    final List<Reclamations> recs = Provider.of<List<Reclamations>>(context);
    var recA;
    //recA = recs;
    String key = '';
    String t = "3:Traitée";
    // UserData useru;
    /* if (recs != null)
      recA = recs.where((u) {
        return (u.etat,isEqualTo(t));
      }).toList();*/
    // TextEditingController _searchController = TextEditingController();

    /*var e = recs.iterator.current.etat;
    if (e != null)
      recA = recs.where((u) {
        return (u.etat.compareTo("3:Traitée") == 0);
      }).toList();*/
    print(recs);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Les réclamations'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.archive_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          StreamProvider<List<Reclamations>>.value(
                              value: FirestoreServices()
                                  .getAllRecsArch(user: widget.user),
                              child: RecArchive(
                                user: widget.user,
                              ))));
                },
              )
            ],
            /*  bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.folder)),
              Tab(icon: Icon(Icons.archive_sharp)),
            ],
          ),*/
            backgroundColor: Colors.blue.shade900,
          ),
          body: /*TabBarView(
          children: [*/
              recs == null
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ))
                  : recs.length == 0
                      ? Center(
                          child: Text("Aucune reclamation"),
                        )
                      : Container(
                          child: Column(children: <Widget>[
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
                          ]),
                        ),
          //2eme tab*****************************************************
        ));
  }
}
