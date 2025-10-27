import 'dart:async';
//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/constant.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/models/user.dart';

class AuthHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //onAuthStatechange
  Stream<String> get onAuthStateChanged => _auth.authStateChanges().map(
        (User user) => user?.uid,
      );
  // GET UID
  Future<String> getCurrentUID() async {
    return (await _auth.currentUser).uid;
  }

  UserData _userFromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  /*Stream<UserData> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }*/

  // auth change user stream
  Future<User> get user async {
    final user = _auth.currentUser;
    return user;
    //_auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      messages('Email ou mot de passe invalide');
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  // @pragma('vm:notify-debugger-on-exception')
  Future registerWithEmailAndPassword(String email, String password, int numTel,
      String gouv, String cin, String role, String nomP) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create a new doc for user with uid
      if (user != null) {
        await FirestoreServices().updateUserData(UserData(
            email: email,
            pw: password,
            numTel: numTel,
            gouv: gouv,
            cin: cin,
            uid: result.user.uid,
            role: role,
            nomP: nomP));

        ;
      } else {
        messagesBleu('email invalide');
      }
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      return messages('Email invalide ou existe déja');
    }
  }

//******** Reset pw */
  Future<bool> resetpassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
// create user obj based on firebase user
/* UserData _userFromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserData> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/

/*class AuthHelper with ChangeNotifier {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getcurrentUser() async {
    User userCredential = _auth.currentUser;
    return userCredential;
  }

  // create user obj based on firebase user
  UserData _userFromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserData> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  //sIn email************
  static signInWithEmail({String email, String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }

//sup email***************
  static signupWithEmail({String email, String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }

// sin google**************
  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

//logout***********
  static logOut() {
    GoogleSignIn().signOut();
    return _auth.signOut();
  }
}
try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: emailctr.text,
                                                password: pwctr.text);
                                    userId = userCredential.user.uid;
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      _showErrorOrSuccesDialog(
                                          'Not Found',
                                          email +
                                              'cannot be found create new account');
                                    } else if (e.code == 'wrong-password') {
                                      _showErrorOrSuccesDialog(
                                          'Error',
                                          'the password you entered for' +
                                              email +
                                              'is incorrect');
                                    }
                                  } catch (e) {
                                    _showErrorOrSuccesDialog('Error!', e);
                                  }
                                }*/
