import 'package:ant_icons/ant_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/components/recDescription.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/services/firestore.dart';
//import 'package:first_app/utils/constant.dart';
//import 'package:first_app/utils/slider.dart';
import 'package:flutter/material.dart';
import 'package:first_app/components/slider.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecDetail extends StatefulWidget {
  final Reclamations v;
  UserData user;

  RecDetail({this.v, this.user});

  @override
  _RecDetailState createState() => _RecDetailState();
}

class _RecDetailState extends State<RecDetail> {
  Color color = Colors.blue.shade900;
  final key = GlobalKey<FormState>();
  List<String> list = [
    '1:Non Traitée',
    '2:En cours',
    '3:Traitée',
  ];
  var selectedDropDownValue = "1:Non Traitée";
  String resultat;
  String cintech;

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
    cintech = widget.v.cinTech;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: color,
          title: Text(widget.v.type ?? ''),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          widget.v.images == null || widget.v.images.isEmpty == true
              ? Container()
              : Sliders(imgs: widget.v.images),
          SizedBox(
            height: 10,
          ),

          //  item(widget.v.description, Icons.text_fields ?? ''),
          // item(widget.v.date, Icons.timelapse),
          item(widget.v.localisation ?? '', FontAwesomeIcons.mapMarkerAlt),
          item(widget.v.dateRec != null ? widget.v.dateRec : 'no date',
              Icons.access_time_rounded),

          /*   if (widget.user.role == 'user' ||
              widget.user.role == 'admin' ||
              widget.user.role == 'assistant')*/
          item(widget.v.etat ?? '1:Non Traitée', Icons.text_fields),

          TextButton(
            child: Text('Consulter détail réclamation'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => RecDesc(rec: widget.v)));
              print('Pressed');
              // _submit();
            },
            style: TextButton.styleFrom(
                primary: Colors.blue.shade900,
                onSurface: Colors.red,
                shadowColor: Colors.white,
                elevation: 3,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                )),
          ),

          Divider(
            color: Colors.black,
          ),
          Text("Utilisateur"),
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
                        FontAwesomeIcons.portrait, //***************portrait */
                        color: Colors.white,
                      ),
                radius: 30,
              ),
              subtitle: Text(user.nomP ?? ''),
              trailing: Text(user.email ?? ''),
            ),
          Divider(
            color: Colors.black,
          ),
          if (widget.user.role == "technicien")
            Card(
                elevation: 1,
                margin: EdgeInsets.only(bottom: 3),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  hint: Text(widget.v.etat ?? selectedDropDownValue),
                  items: list.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text("$c"),
                    );
                  }).toList(),
                  //  value: resultat,
                  onChanged: (val) async {
                    widget.v.etat = val;

                    bool update = await FirestoreServices().updateRec(widget.v);

                    if (update) {
                      messagesBleu("Etat réclamation modifiée");

                      Navigator.of(context).pop();
                    }

                    setState(() {
                      selectedDropDownValue = val;

                      widget.v.etat = val;
                    });
                    ;
                  },
                ))),

          if (widget.user.role == "assistant" || widget.user.role == "admin")
            Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: key,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: cintech != null
                                ? cintech
                                : "Entrer CIN Technicien",
                            keyboardType: TextInputType.number,
                            validator: (e) =>
                                e.isEmpty ? "Remplir ce champ" : null,
                            onChanged: (e) {
                              setState(() => cintech = e.trim());
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                                hintText: "Entrer CIN Technicien",
                                labelText: "Entrer CIN Technicien",
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
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  )),
                              child: Text('Confirmer'),
                              onPressed: () async {
                                if (key.currentState.validate()) {
                                  widget.v.cinTech = cintech;
                                  bool update = await FirestoreServices()
                                      .updateRec(widget.v);

                                  if (update) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                            ),
                          )
                        ])))
        ])));
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
