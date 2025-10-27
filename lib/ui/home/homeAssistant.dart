import 'package:ant_icons/ant_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/auth.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/ui/Admin/ListeRecs.dart';
import 'package:first_app/ui/Admin/listeDossiers.dart';
import 'package:first_app/ui/message/message.dart';
import 'package:first_app/ui/reclamation/reclamationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../menu.dart';
import 'homeRes.dart';

class HomeAssistant extends StatefulWidget {
  UserData user;
  HomeAssistant({this.user});
  @override
  _HomeAssistantState createState() => _HomeAssistantState();
}

class _HomeAssistantState extends State<HomeAssistant> {
  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: key,
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _themeAss(size, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Messages()),
        ),
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue.shade900,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () {
                  key.currentState.openDrawer();
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.user.image != null
                      ? NetworkImage(widget.user.image)
                      : null,
                  child: widget.user.image != null
                      ? Container()
                      : IconButton(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            key.currentState.openDrawer();
                          }),
                )),
            SizedBox(
              width: 40,
            ),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Paramètres"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Se déconecter"),
                ),
              ],
              initialValue: 2,
              onCanceled: () {
                print("You have canceled the menu.");
              },
              onSelected: (value) async {
                AuthHelper _auth = AuthHelper();
                if (value == 2) {
                  await mydialog(context, ok: () async {
                    await _auth.signOut();
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                      title: "Deconnexion",
                      content: "Voulez-vous se déconnecter?");
                  //Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )
            /*IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {},
            ),*/
          ],
        ),
      ),
    );
  }

  Container _themeAss(var size, BuildContext context) {
    final Color color1 = Color(0xFF1976D2);
    final Color color2 = Color(0xFF0D47A1);
    //final userm = Provider.of<UserData>(context);
    //final List<DossierMod> dossiers = Provider.of<List<DossierMod>>(context);

    String userid = FirebaseAuth.instance.currentUser.uid;

    final userm = Provider.of<UserData>(context);
    userm?.uid = userid;

    UserData.currentUser = userm;
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 350,
            //bottom: 300,
            left: 250,
            //right: 100,
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color1, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color1,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 10.0),
                  ]),
            ),
          ),
          Positioned(
            top: 410,
            //bottom: 300,
            left: 80,
            //right: 100,
            child: Container(
              width: 200,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/sonede.png',
                    height: 120,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(200),
                ),
                gradient: LinearGradient(colors: [color1, color2]),
                boxShadow: [
                  BoxShadow(
                      color: color2,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 10.0),
                ]),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60, left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 35.0),
                Text(
                  "SOS SONEDE \n Assistant ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 45.0),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    //mainAxisSpacing: 10,
                    //crossAxisSpacing: 10,
                    primary: false,
                    //crossAxisCount: 2,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        child: new InkWell(
                          onTap: () {
                            if (userm.autorise) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) =>
                                      StreamProvider<List<Dossier>>.value(
                                        value: FirestoreServices()
                                            .getDoss(user: widget.user),
                                        // initialData: [],
                                        child: Listepage(user: widget.user),
                                      )));
                            } else {
                              messages("Votre compte a été bloqué");
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/group-folder.png',
                                height: 120,
                                alignment: Alignment.center,
                              ),
                              Text(
                                'Les dossiers',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 5,
                        child: new InkWell(
                          onTap: () {
                            if (userm.autorise) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) =>
                                      StreamProvider<List<Reclamations>>.value(
                                          value: FirestoreServices()
                                              .getAllRecs(user: widget.user),
                                          initialData: [],
                                          child:
                                              ListeRecs(user: widget.user))));
                            } else {
                              messages("Votre compte a été bloqué");
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/files.png',
                                height: 120,
                                alignment: Alignment.center,
                              ),
                              Text(
                                'Les Réclamations',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
