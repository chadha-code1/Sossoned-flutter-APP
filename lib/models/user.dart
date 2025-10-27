class UserData {
  String email;
  String image;
  String uid;
  String pw;
  int numTel;
  String gouv;
  String cin;
  String role;
  String nomP;
  bool autorise;
  static UserData currentUser;

  UserData(
      {this.email,
      this.role = 'user',
      this.pw,
      this.numTel,
      this.gouv,
      this.cin,
      this.uid,
      this.image,
      this.nomP,
      this.autorise = true});

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "pw": pw,
      "numTel": numTel,
      "gouv": gouv,
      "cin": cin,
      "image": image,
      "role": role,
      "uid": uid,
      "nomP": nomP,
      "autorise": autorise,
    };
  }

  factory UserData.fromFirestore(Map<String, dynamic> firestore) => UserData(
        email: firestore["email"],
        pw: firestore["pw"],
        numTel: firestore["numTel"],
        gouv: firestore["gouv"],
        cin: firestore["cin"],
        role: firestore["role"],
        image: firestore["image"] == null ? "" : firestore["image"],
        nomP: firestore["nomP"],
        uid: firestore["uid"],
        autorise: firestore["autorise"],
      );
}
// images: firestore["photo"].map<String>((i) => i as String).toList(),
