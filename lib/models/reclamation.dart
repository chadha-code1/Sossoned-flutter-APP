import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/ui/reclamation/reclamationPage.dart';

class Reclamations {
  String uid;
  List<String> images;
  String type;
  String id;
  String description;
  String localisation;
  String gouv;
  String etat;
  String dateRec;
  String dateStat;
  String cinTech;
  int nbr;
  Reclamations(
      {this.uid,
      this.dateStat,
      this.id,
      this.nbr,
      this.description,
      this.gouv,
      this.etat = '1:Non traitée',
      this.type,
      this.images,
      this.cinTech,
      this.localisation,
      this.dateRec});
  factory Reclamations.fromFirestore(Map<String, dynamic> firestore,
          {String id}) =>
      Reclamations(
          id: id,
          uid: firestore["uid"],
          description: firestore["description"],
          images: firestore["photos"].map<String>((i) => i as String).toList(),
          type: firestore["type"],
          localisation: firestore["localisation"],
          etat: firestore["etat"],
          dateRec: firestore["recDate"],
          dateStat: firestore["dateStat"],
          cinTech: firestore["cinTech"],
          gouv: firestore["gouv"]);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      "photos": images,

      //'id': id,
      'description': description,
      'etat': etat,
      'localisation': localisation,
      'type': type,
      'recDate': dateRec,
      'dateStat': dateStat,

      "cinTech": cinTech,

      'gouv': gouv
    };
  }

  Reclamations.fromMap(Map<String, dynamic> map())
      : assert(map()['recDate'] != null),
        dateRec = map()['recDate'];

  Reclamations.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() => "Record<$gouv>";
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
