import 'package:cloud_firestore/cloud_firestore.dart';

class Dossier {
  int idDossier;
  String uid;
  String cin;
  String gouv;
  String dateDoss;
  DateTime datesys;
  String etat, val;

  String id;
  Dossier(
      {this.cin,
      this.gouv,
      this.idDossier,
      this.uid,
      this.etat = '1:1ère Phase',
      this.val = '-- Dt',
      this.id,
      this.dateDoss,
      this.datesys});

  Map<String, dynamic> toMap() {
    return {
      "idDossier": idDossier,
      "gouv": gouv,
      "cin": cin,
      "uid": uid,
      "val": val,
      "dateDoss": dateDoss,
      "etat": etat,
      'datesys': datesys
    };
  }

  factory Dossier.fromFirestore(Map<String, dynamic> firestore, {String id}) =>
      Dossier(
          id: id,
          idDossier: firestore["idDossier"],
          gouv: firestore["gouv"],
          cin: firestore["cin"],
          etat: firestore["etat"],
          val: firestore["val"],
          dateDoss: firestore["dateDoss"],
          datesys: _convertStamp(firestore["datesys"]),
          uid: firestore["uid"]);
}

DateTime _convertStamp(Timestamp _stamp) {
  if (_stamp != null) {
    return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();

    /*
    if (Platform.isIOS) {
      return _stamp.toDate();
    } else {
      return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();
    }
    */

  } else {
    return null;
  }
}
