import 'package:ant_icons/ant_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/models/NotificationPlugin.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/auth.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/ui/Admin/ListeRecs.dart';
import 'package:first_app/ui/Admin/listeDossiers.dart';
import 'package:first_app/ui/Admin/listeUsers.dart';
import 'package:first_app/ui/Admin/recStats.dart';
import 'package:first_app/ui/Admin/statBar.dart';
import 'package:first_app/ui/dossier/ajoutDossier.dart';
import 'package:first_app/ui/reclamation/reclamationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../menu.dart';

class HomeResp extends StatefulWidget {
  UserData user;
  HomeResp({this.user});
  @override
  _HomeRespState createState() => _HomeRespState();
}

class _HomeRespState extends State<HomeResp> {
  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return widget.user.uid == null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : Scaffold(
            key: key,
            drawer: Menu(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _themeRes(size, context),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue.shade900,
              onPressed: () {},
              child: Icon(
                Icons.reduce_capacity,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
                        AuthHelper _auth = AuthHelper();
                        await mydialog(context, ok: () async {
                          await _auth.signOut();
                          //  setState(() {});
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

  Container _themeRes(var size, BuildContext context) {
    final Color color1 = Color(0xFF1976D2);
    final Color color2 = Color(0xFF0D47A1);
    //final List<DossierMod> dossiers = Provider.of<List<DossierMod>>(context);
    //UserData userm = UserData.currentUser;
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
            margin: const EdgeInsets.only(top: 60, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "SOS SONEDE Responsable ",
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
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        child: new InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    StreamProvider<List<UserData>>.value(
                                        value: FirestoreServices()
                                            .getAllUsers(user: widget.user),
                                        child: UserListPage())));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/user-groups.png',
                                height: 120,
                                alignment: Alignment.center,
                              ),
                              Text(
                                'Les Comptes',
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    StreamProvider<List<Reclamations>>.value(
                                        value: FirestoreServices()
                                            .getAllRecs(user: widget.user),
                                        child: ListeRecs(user: widget.user))));
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
                                'Les réclamations',
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    StreamProvider<List<Dossier>>.value(
                                        value: FirestoreServices()
                                            .getDoss(user: widget.user),
                                        child: Listepage(user: widget.user))));
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
                      TextButton(
                          child: Text('Consulter les statistiques'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SalesHomePage(),
                                ));
                          }),
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
