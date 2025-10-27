import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/ui/home/homeAssistant.dart';
import 'package:first_app/ui/home/homeTech.dart';
import 'package:first_app/ui/menu.dart';
import 'package:first_app/ui/reclamation/add_reclamation.dart';
import 'package:first_app/ui/reclamation/reclamationPage.dart';
import 'package:first_app/ui/dossier/dossierPage.dart';
import 'package:first_app/ui/message/message.dart';
import 'package:first_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:provider/provider.dart';

import 'homeRes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AuthHelper auth = AuthHelper();
  static const Color darkBlue = Color(0xff0d47a1);
  /* UserData userm;

  Future<void> getUser() async {
    //final UserData user = Provider.of(context);
    User user = await auth.user;
    if (user != null) {
      final userresult = await FirestoreServices().getUser(user.uid);
      if (mounted) {
        setState(() {
          userm = userresult;
          //UserData.currentUser = userresult;
        });
      }
    } else {
      print('user null');
    }
  }

  void initState() {
    getUser();
    super.initState();
  }

  void dispose() {
    super.dispose();
    print('dispose');
  }*/

  final key = GlobalKey<ScaffoldState>();
  build(BuildContext context) {
    // getUser();

    //AuthHelper auth = AuthHelper();

    String userid = FirebaseAuth.instance.currentUser.uid;

    final userm = Provider.of<UserData>(context);

    UserData.currentUser = userm;
    //userm.uid = userid;

    var size = MediaQuery.of(context).size;
    if (userm == null) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }
    if (userm.role == "user") {
      //case 'user':
      // {
      return userm.role == null
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : Scaffold(
              key: key,
              drawer: Menu(),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _theme(size, context),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue.shade900,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Messages()),
                ),
                child: const Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
              ),
              //******************************bottomBar*********************************************** */
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
                          backgroundImage: userm.image != null
                              ? NetworkImage(userm.image)
                              : null,
                          child: userm.image != null
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
                      width: 1,
                    ),
                    //Icon(Icons.person, color: Colors.black),

                    /* IconButton(
                      icon: Icon(Icons.account_box),
                      color: Colors.white,
                      onPressed: () {
                        key.currentState.openDrawer();
                      }),
                  SizedBox(
                    width: 40,
                  ),*/
                    PopupMenuButton<int>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Paramètres"),
                        ),
                        PopupMenuItem(
                          value: 2,
                          //sign outttttttttt
                          child: Text("Se déconecter"),
                        ),
                      ],
                      initialValue: 2,
                      onCanceled: () {
                        print("You have canceled the menu.");
                      },
                      onSelected: (value) async {
                        if (value == 2) {
                          AuthHelper _auth = AuthHelper();
                          await mydialog(context, ok: () async {
                            await _auth.signOut();
                            ;
                            Navigator.of(context).pop();
                          },
                              title: "Deconnexion",
                              content: "Voulez-vous se déconnecter?");

                          // Navigator.pop(context);
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

    // break;
    //  case 'admin':

    if (userm.role == "admin") {
      return HomeResp(user: userm);
    }

    // break;
    //case 'assistant':

    if (userm.role == "assistant") {
      return HomeAssistant(user: userm);
    }
    // break;
    //   case 'technicien':

    if (userm.role == "technicien") {
      return HomeTech(user: userm);
    }
    // default:
    else {
      return Scaffold(
        body: Center(
          child: Container(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Visibility(
                  child: const LinearProgressIndicator(
                    backgroundColor: darkBlue,
                  ),
                )),
          ),
        ),
      );
    }
    //break;
  }
}
//}

//********************************************************* themeUser******************************** */
Container _theme(var size, BuildContext context) {
  final Color color1 = Color(0xFF1976D2);
  final Color color2 = Color(0xFF0D47A1);
  final userm = Provider.of<UserData>(context);
  UserData.currentUser = userm;
  final userid = FirebaseAuth.instance.currentUser.uid;
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
                    color: color2, offset: Offset(1.0, 1.0), blurRadius: 10.0),
              ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 60, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "SOS SONEDE",
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
                          // if (userm != null) {
                          if (userm.autorise) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    StreamProvider<List<Reclamations>>.value(
                                      // initialData: [],
                                      value: FirestoreServices().getRec(userid),
                                      child:
                                          Reclamation(user: userm), //add userm
                                    )));
                          } else {
                            messages("Votre compte a été bloqué");
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'file.png',
                              height: 120,
                              alignment: Alignment.center,
                            ),
                            Text(
                              'Mes réclamations',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    Ajouter_reclamation(user: userm),
                              ),
                            );
                          } else {
                            messages("Votre compte a été bloqué");
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/add-file.png',
                              height: 120,
                              alignment: Alignment.center,
                            ),
                            Text(
                              'Ajouter une réclamation',
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
                      elevation: 4,
                      child: new InkWell(
                        onTap: () {
                          if (userm.autorise) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    StreamProvider<List<Dossier>>.value(
                                      initialData: [],
                                      value: FirestoreServices().getdossier,
                                      child: DossierPage(user: userm),
                                    )));
                          } else {
                            messages("Votre compte a été bloqué");
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/folder.png',
                              height: 120,
                              alignment: Alignment.center,
                            ),
                            Text(
                              'Mes dossiers',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                            ),
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
