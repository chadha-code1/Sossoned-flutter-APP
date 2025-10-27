import 'package:ant_icons/ant_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
//import 'package:first_app/ui/reclamation/add_reclamation.dart';
//import 'package:first_app/components/reclamationCard.dart';
import 'package:first_app/ui/reclamation/editReclamation.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/components/loading.dart';
import 'package:first_app/components/constant.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/ui/reclamation/reclamationDetails.dart';
import 'package:flutter/material.dart';

//import 'package:provider/provider.dart';

class recCard extends StatefulWidget {
  final Reclamations rec;
  final UserData user;

  recCard({this.rec, this.user});

  @override
  _recCardState createState() => _recCardState();
}

UserData useru;

class _recCardState extends State<recCard> {
  // get utilisateur pour son nom useru
  // widget.user==user in the parameters for the listcard from it's home
  getUser() async {
    final u = await FirestoreServices().getUser(widget.rec.uid);
    if (u != null) {
      setState(() {
        useru = u;
      });
    } else {
      print('user null');
    }
  }

  void initState() {
    //  implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return useru == null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          RecDetail(v: widget.rec, user: widget.user)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      widget.rec.images != null
                          ? Container(
                              height: height / 4.2,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: widget.rec.images == null ||
                                              widget.rec.images.isEmpty == true
                                          ? AssetImage('assets/sonede.png')
                                          : CachedNetworkImageProvider(
                                              widget.rec.images.first,
                                            ))))
                          : Container(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 8, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.rec.type,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              height: 1)),
                                      Text(useru.nomP),
                                      if ((widget.user.role == "assistant" ||
                                              widget.user.role == "admin") &&
                                          widget.rec.cinTech != null)
                                        Row(children: <Widget>[
                                          Icon(Icons.check),
                                          Text("Afféctée à un technicien")
                                        ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                /* if (widget.user.role == "user")
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      mydialog(context,
                                          title: "Suppression",
                                          content: "Voulez-vous supprimer " +
                                              widget.rec.type, ok: () async {
                                        Navigator.of(context).pop();
                                        // loading(context);
                                        bool delete = await FirestoreServices()
                                            .deleteRec(widget.rec.id);
                                        if (delete != null) {
                                          print('deleted');
                                        }
                                      });
                                    },
                                  ),*/
                                if (widget.rec.etat == '3:Traitée')
                                  IconButton(
                                    icon: Icon(Icons.check_rounded,
                                        color: Colors.blue.shade900),
                                    onPressed: () {
                                      /* Navigator.of(context).push(MaterialPageRoute(
                                        builder: (ctx) => Editrec(rec: rec)));*/
                                    },
                                  )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
