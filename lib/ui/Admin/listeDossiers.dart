import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Listepage extends StatefulWidget {
  UserData user;
  Listepage({this.user});
  @override
  _ListepageState createState() => _ListepageState();
}

class _ListepageState extends State<Listepage> {
  TextEditingController _searchController = TextEditingController();

  final CollectionReference demCol =
      FirebaseFirestore.instance.collection("Dossiers");
  List<String> v = [
    '1:1ère phase',
    '2:Etude de Projet',
    '3:Budget',
    '4:Attente paiement'
  ];
  var selectedDropDownValue = "1ère phase";
  String key = '';

  @override
  Widget build(BuildContext context) {
    final dossiers = Provider.of<List<Dossier>>(context);
    var filtered = dossiers;
    if (key != '')
      filtered = filtered.where((u) {
        return u.idDossier.toString().contains(key.toLowerCase());
      }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les dossiers',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: dossiers == 0
          ? Center(
              child: Text("Aucun dossier"),
            )
          : Container(
              width: 900,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, bottom: 30.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Rechercher dossier'),
                    onChanged: (value) {
                      // Update the key when the value changes.
                      setState(() => key = value);
                    },
                  ),
                ),
                key == null
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        //  child: FittedBox(
                        child: DataTable(
                          columns: [
                            //  DataColumn(label: Text('Cin')),
                            DataColumn(label: Text('Identifiant du Dossier')),
                            DataColumn(label: Text('Date d\'ajout')),
                            DataColumn(label: Text('Etat ')),
                          ],
                          rows: List<DataRow>.generate(
                              dossiers == null ? 0 : dossiers.length,
                              (index) => DataRow(
                                    //selected: true,
                                    cells: [
                                      //   DataCell(Text(dossiers[index].cin.toString())),
                                      DataCell(Text(dossiers[index]
                                          .idDossier
                                          .toString())),
                                      DataCell(Text(dossiers[index].dateDoss)),
                                      DataCell(
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            //   decoration: textInputDecoration,
                                            // value: v[1],
                                            hint: Text(dossiers[index].etat),
                                            items: v.map((ve) {
                                              return DropdownMenuItem(
                                                value: ve,
                                                child: Text("$ve"),
                                              );
                                            }).toList(),

                                            /* DropdownMenuItem(
                                          child: Text("1ère phase"),
                                          value: '1ère Phase',
                                        ),
                                        DropdownMenuItem(
                                          child: Text("2:Etude de Projet"),
                                          value: '2:Etude de Projet',
                                        ),
                                        DropdownMenuItem(
                                            child: Text("3:Budget"),
                                            value: '3:Budget'),
                                        DropdownMenuItem(
                                            child: Text("4:Attente paiement"),
                                            value: '4:Attente paiement'),*/
                                            // value: dossiers[index].etat,
                                            onChanged: (valu) async {
                                              dossiers[index].etat = valu;
                                              // v = value;
                                              bool update =
                                                  await FirestoreServices()
                                                      .updateDoss(
                                                          dossiers[index]);

                                              if (update) {
                                                // Navigator.of(context).pop();
                                                messagesWhite("Etat modifiée");
                                              }
                                              ;

                                              setState(() {
                                                selectedDropDownValue = valu;

                                                dossiers[index].etat = valu;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: true,
                                        /* showEditIcon: true, onTap: () async {
                                  //dossiers[index].etat = v;
                                  bool update = await FirestoreServices()
                                      .updateDoss(dossiers[index]);

                                  if (update) {
                                    Navigator.of(context).pop();
                                  }
                                  ;
                                }*/
                                      ),

                                      /*    DataCell(
                                TextField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                    setState(() => v = text);
                                  },
                                ),
                               */
                                    ],
                                    /*onSelectChanged: (newValue) {
                            print('row 2 pressed');
                          },*/
                                  )),
                        ),
                        //),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        //  child: FittedBox(
                        child: DataTable(
                          columns: [
                            //  DataColumn(label: Text('Cin')),
                            DataColumn(label: Text('Identifiant du Dossier')),
                            DataColumn(label: Text('Date d\'ajout')),
                            DataColumn(label: Text('Etat ')),
                          ],
                          rows: List<DataRow>.generate(
                              filtered == null ? 0 : filtered.length,
                              (index) => DataRow(
                                    //selected: true,
                                    cells: [
                                      //   DataCell(Text(dossiers[index].cin.toString())),
                                      DataCell(Text(filtered[index]
                                          .idDossier
                                          .toString())),
                                      DataCell(Text(filtered[index].dateDoss)),
                                      DataCell(
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            //   decoration: textInputDecoration,
                                            // value: v[1],
                                            hint: Text(filtered[index].etat),
                                            items: v.map((ve) {
                                              return DropdownMenuItem(
                                                value: ve,
                                                child: Text("$ve"),
                                              );
                                            }).toList(),

                                            /* DropdownMenuItem(
                                          child: Text("1ère phase"),
                                          value: '1ère Phase',
                                        ),
                                        DropdownMenuItem(
                                          child: Text("2:Etude de Projet"),
                                          value: '2:Etude de Projet',
                                        ),
                                        DropdownMenuItem(
                                            child: Text("3:Budget"),
                                            value: '3:Budget'),
                                        DropdownMenuItem(
                                            child: Text("4:Attente paiement"),
                                            value: '4:Attente paiement'),*/
                                            // value: dossiers[index].etat,
                                            onChanged: (valu) async {
                                              filtered[index].etat = valu;
                                              // v = value;
                                              bool update =
                                                  await FirestoreServices()
                                                      .updateDoss(
                                                          dossiers[index]);

                                              if (update) {
                                                // Navigator.of(context).pop();
                                                messagesWhite("Etat modifiée");
                                              }
                                              ;

                                              setState(() {
                                                selectedDropDownValue = valu;

                                                dossiers[index].etat = valu;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: true,
                                        /* showEditIcon: true, onTap: () async {
                                  //dossiers[index].etat = v;
                                  bool update = await FirestoreServices()
                                      .updateDoss(dossiers[index]);

                                  if (update) {
                                    Navigator.of(context).pop();
                                  }
                                  ;
                                }*/
                                      ),

                                      /*    DataCell(
                                TextField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                    setState(() => v = text);
                                  },
                                ),
                               */
                                    ],
                                    /*onSelectChanged: (newValue) {
                            print('row 2 pressed');
                          },*/
                                  )),
                        ),
                        //),
                      )
              ]),
            ),
      /*  floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(AntIcons.folder_add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AjoutDossier(user: widget.user)));
        },
      ),*/
    );
  }
}
