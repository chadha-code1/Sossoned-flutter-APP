import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
//import 'package:first_app/ui/Admin/editUsers.dart';
import 'package:first_app/ui/Admin/userDetails.dart';
import 'package:first_app/ui/reclamation/add_reclamation.dart';
import 'package:first_app/components/reclamationCard.dart';
import 'package:first_app/ui/reclamation/editReclamation.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/components/loading.dart';
import 'package:first_app/components/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/ui/reclamation/reclamationDetails.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  final UserData u;

  UserCard({this.u});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color themeColor = Colors.lightBlue;

    // final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => UserDetail(user: u)));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Container(
                height: height / 4.2,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  /* image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(rec.images.first))),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.white,
                    child: IconButton(
                      icon: favIcon,
                      onPressed: () async {
                        if (car.favories.contains(user.uid))
                          car.favories.remove(user.uid);
                        else
                          car.favories.add(user.uid);
                        await DBServices().updatevehicule(car);
                      },
                    ),*/
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1)),
                              Text(u.cin.toString()),
                            ],
                          ),
                        ),
                        //dislike row
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            mydialog(context,
                                title: "Suppression",
                                content: "Voulez-vous supprimer " + u.email,
                                ok: () async {
                              Navigator.of(context).pop();
                              loading(context);
                              bool delete =
                                  await FirestoreServices().deleteUser(u.uid);
                              if (delete != null) {
                                Navigator.of(context).pop();
                              }
                            });
                          },
                        ),
                        /*   IconButton(
                          icon: Icon(Icons.edit, color: themeColor),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => EditUser(user: u)));
                          },
                        )*/
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
