import 'package:ant_icons/ant_icons.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ajoutDossier.dart';

class DossierPage extends StatefulWidget {
  UserData user;
  DossierPage({this.user});
  @override
  _DossierPageState createState() => _DossierPageState();
}

class _DossierPageState extends State<DossierPage> {
  @override
  Widget build(BuildContext context) {
    final dossiers = Provider.of<List<Dossier>>(context);
    String key = '';

    return Scaffold(
      //backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text(
          'Mes dossiers',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: dossiers.length == 0
          ? Center(
              child: Text("Aucun dossier"),
            )
          : Container(
              width: 900,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, bottom: 30.0),
                    child: TextField(
                      // controller: _searchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Rechercher dossier'),
                      onChanged: (value) {
                        // Update the key when the value changes.
                        setState(() => key = value);
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FittedBox(
                      child: DataTable(
                        columns: [
                          //  DataColumn(label: Text('Cin')),
                          DataColumn(label: Text('Numéro du Dossier')),
                          DataColumn(label: Text('Date d\'ajout')),

                          DataColumn(label: Text('État')),
                        ],
                        rows: List<DataRow>.generate(
                            dossiers == null ? 0 : dossiers.length,
                            (index) => DataRow(
                                  cells: [
                                    /* DataCell(
                                        Text(dossiers[index].cin.toString()) != null
                                            ? dossiers[index].cin as String
                                            : 'no'),*/
                                    DataCell(Text(dossiers[index]
                                                .idDossier
                                                .toString() !=
                                            null
                                        ? dossiers[index].idDossier.toString()
                                        : 'aucun id de dossier')),
                                    DataCell(Text(
                                        dossiers[index].dateDoss != null
                                            ? dossiers[index].dateDoss
                                            : '')),
                                    DataCell(Text(dossiers[index].etat != null
                                        ? dossiers[index].etat
                                        : '1ère phase')),
                                  ],
                                  /*onSelectChanged: (newValue) {
                              print('row 2 pressed');
                            },*/
                                )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        child: Icon(AntIcons.folder_add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AjoutDossier(user: widget.user)));
        },
      ),
    );
  }
}
