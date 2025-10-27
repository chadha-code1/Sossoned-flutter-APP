import 'package:cloud_firestore/cloud_firestore.dart';

class Stats {
  String year;
  int nbr;
  String id;
  Stats({this.id, this.nbr, this.year});
  factory Stats.fromFirestore(Map<String, dynamic> firestore, {String id}) =>
      Stats(
        id: id,
        year: firestore["year"],
        nbr: firestore["nbr"],
      );

  Map<String, dynamic> toMap() {
    return {
      //'id': id,

      'year': year,
      'nbr': nbr,
    };
  }

  Stats.fromMap(Map<String, dynamic> map())
      : assert(map()['year'] != null),
        year = map()['year'],
        nbr = map()['nbr'];

  Stats.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);

  @override
  String toString() => "Record<$year>";
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
