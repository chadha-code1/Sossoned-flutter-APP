//import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:first_app/models/dossier.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/stats.dart';
import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:first_app/ui/reclamation/reclamationPage.dart';

class FirestoreServices {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  //final String uid;
  //FirestoreServices({this.uid});

  final CollectionReference userCol =
      FirebaseFirestore.instance.collection('Utilisateurs');
  final CollectionReference stats =
      FirebaseFirestore.instance.collection('Statistiques');
  final CollectionReference recCol =
      FirebaseFirestore.instance.collection("Reclamations");
  final CollectionReference demCol =
      FirebaseFirestore.instance.collection("Dossiers");

  Future updateUserData(UserData user) async {
    return await userCol.doc(user.uid).set(user.toMap()).then((value) {
      print('user updated');
      messagesBleu("Utilisateur inscrit");
    }
        //.catchError((error) => print('failed to add user: $error'));
        );
  }

  //entry journal
  Future setUser(UserData user) {
    var options = SetOptions(merge: true);

    return userCol
        .doc(user.uid)
        .set(user.toMap(), options)
        .then((value) => messagesBleu("Compte mis à jours"));
  }

  Future getUser(String id) async {
    try {
      final DocumentSnapshot data = await userCol.doc(id).get();
      final user = UserData.fromFirestore(data.data());
      return user;
    } catch (e) {
      return false;
    }
  }

  Stream<UserData> get getCurrentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user != null
        ? userCol.doc(user.uid).snapshots().map((user) {
            UserData.currentUser = UserData.fromFirestore(user.data());
            return UserData.fromFirestore(user.data());
          })
        : CircularProgressIndicator();
  }

  Stream<List<UserData>> getAllUsers({UserData user}) {
    return userCol
        .where('gouv', isEqualTo: user.gouv)
        .orderBy("nomP")
        .snapshots()
        .map((users) {
      return users.docs.map((e) => UserData.fromFirestore(e.data())).toList();
    });
  }

  Future updateUser(UserData user) async {
    try {
      await userCol.doc(user.uid).update(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteUser(String id) async {
    try {
      await userCol.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  //imaaaageeeeeeeeeeeeee
  Future<String> uploadImage(File file, {String path}) async {
    var time = DateTime.now().toString();
    var ext = Path.basename(file.path).split(".")[1].toString();
    String image = path + "_" + time + "." + ext;
    try {
      Reference ref = FirebaseStorage.instance.ref().child(path + "/" + image);
      UploadTask upload = ref.putFile(file);
      return await upload.then((res) {
        return res.ref.getDownloadURL();
      });
      // await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  //dossier*******************
  Future savestat(Stats s) async {
    try {
      await stats.doc().set(s.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future updateStat(Stats s) async {
    var m = s.year;
    try {
      await stats.doc(m).set(s.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future saveDemDoss(Dossier dem) async {
    try {
      await demCol.doc().set(dem.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future updateDoss(Dossier dem) async {
    try {
      await demCol.doc(dem.id).update(dem.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Dossier>> getDoss({UserData user}) {
    return demCol
        .where('gouv', isEqualTo: user.gouv)
        .orderBy("dateDoss", descending: true)
        .snapshots()
        .map((doss) {
      return doss.docs
          .map((e) => Dossier.fromFirestore(e.data(), id: e.id))
          .toList();
    });
  }

  Stream<List<Dossier>> get getdossier {
    final user = FirebaseAuth.instance.currentUser;

    return demCol
        .where("uid", isEqualTo: user?.uid)
        //.orderBy("uid")
        .orderBy("datesys", descending: true)
        .snapshots()
        .map((dem) {
      return dem.docs
          .map((e) => Dossier.fromFirestore(e.data(), id: e.id))
          .toList();
    });
  }

  //reclamations*****************

  Future saveRec(Reclamations rec) async {
    try {
      await recCol.doc().set(rec.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Reclamations>> getAllRecs({UserData user}) {
    // var ud = UserData.fromFirestore((item) => item.data,id:item.id)).toList();
    var s = "3:Traitée";
    return recCol
        .where('gouv', isEqualTo: user.gouv)
        .where('etat', isNotEqualTo: s)
        .orderBy("etat")
        .orderBy("recDate", descending: true)
        .snapshots()
        .map((recs) {
      return recs.docs
          .map((e) => Reclamations.fromFirestore(e.data(), id: e.id))
          .toList();
    });
  }

  Stream<List<Reclamations>> getAllRecsArch({UserData user}) {
    var s = "3:Traitée";

    return recCol
        .where('gouv', isEqualTo: user.gouv)
        .where('etat', isEqualTo: s)
        .orderBy("recDate", descending: true)
        .snapshots()
        .map((recs) {
      return recs.docs
          .map((e) => Reclamations.fromFirestore(e.data(), id: e.id))
          .toList();
    });
  }

  Stream<List<Reclamations>> getRecTech({UserData user}) {
    return recCol
        .where('cinTech', isEqualTo: user.cin)
        .orderBy("recDate", descending: true)
        .snapshots()
        .map((recs) {
      return recs.docs
          .map((e) => Reclamations.fromFirestore(e.data(), id: e.id))
          .toList();
    });
  }

  Future updateRec(Reclamations rec) async {
    try {
      await recCol.doc(rec.id).update(rec.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  //****************************Stat update************************** */

  Future deleteRec(String id) async {
    try {
      await recCol.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Reclamations>> getRec(String uid) {
    //String uid = FirebaseAuth.instance.currentUser.uid;
    return recCol
        .where("uid", isEqualTo: uid)
        .orderBy("recDate", descending: true)
        .snapshots()
        .map((reclamation) {
      return reclamation.docs
          .map((e) => Reclamations.fromFirestore(e.data(), id: e.id))
          .toList();
    });
  }
}
/* Stream<QuerySnapshot> getUsersTripsStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('userData').document(uid).collection('trips').snapshots();
  }/






 //reclamation
Future<void> saveProduct(Product product){
    return _db.collection('products').doc(product.productId).set(product.toMap());
  }

  Stream<List<Product>> getProducts(){
    return _db.collection('products').snapshots().map((snapshot) => snapshot.docs.map((document) => Product.fromFirestore(document.data())).toList());
  }

  Future<void> removeProduct(String productId){
    return _db.collection('products').doc(productId).delete();
  } 
  */
