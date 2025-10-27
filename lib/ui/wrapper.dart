import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:first_app/ui/home/home.dart';
import 'package:first_app/ui/authentification/login.dart';
import 'package:first_app/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class wrapper extends StatefulWidget {
  @override
  _wrapperState createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  AuthHelper auth = AuthHelper();
  User user;
  final CollectionReference userCol =
      FirebaseFirestore.instance.collection('Utilisateurs');

  Future<void> getUser() async {
    User userResult = await auth.user;

    setState(() {
      user = userResult;
    });
  }

  UserData userm;

  /*Future<void> getUserm() async {
    final u = await FirestoreServices().getUser(user.uid);
    if (userm != null) {
      if (this.mounted) {
        setState(() {
          userm = u;
        });
      } else {
        print('user null');
        //
      }
    }
  }

  void initState() {
    //  implement initState
    super.initState();

    getUserm();
  }*/

  Widget build(BuildContext context) {
    getUser();
    // getUserm();

    return user == null
        ? Login()
        : StreamProvider<UserData>.value(
            value: FirestoreServices()?.getCurrentUser,
            initialData: null,
            child: HomeScreen(),
          );
  }

/*  checkRole() {
    //getUserm();
    //final userm = Provider.of<UserData>(context);
    //UserData.currentUser = userm;
    /* final QuerySnapshot result = FirebaseFirestore.instance
        .collection('Utilisateurs')
        .where('role', isEqualTo: 'admin')
        .get() as QuerySnapshot;

    final List<DocumentSnapshot> documents = result.docs;*/
    if (userm != null) {
      if (userm.role == "admin") {
        //exists
        return AdminHome();
      } else {
        //not exists
        return HomeScreen();
      }
      // }
      // ;
    }
  }*/

/*checkRole() {
  var b = FirebaseFirestore.instance
      .collection("Utilisateurs")
      .where("role", isEqualTo: "admin");

  //UserData userm;
  // userm.uid = auth.getCurrentUID().toString();
  if (b == true) {
    return AdminHome();
  } else {
    return HomeScreen();
  }
}*/
/*checkRole() {
  //final userm = Provider.of<UserData>(context);
  //UserData.currentUser = userm;
  final result = FirebaseFirestore.instance
      .collection('Utilisateurs')
      .where('role', isEqualTo: 'admin')
      .get(); // as QuerySnapshot;

  // final List<DocumentSnapshot> documents = result.docs;

  if (result == true) {
    //exists
    return AdminHome();
  } else {
    //not exists
    return HomeScreen();
  }
}*/
}
