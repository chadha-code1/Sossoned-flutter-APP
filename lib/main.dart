import 'package:first_app/models/NotificationPlugin.dart';
import 'package:first_app/ui/authentification/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/ui/wrapper.dart';
import 'package:first_app/ui/home/home.dart';
import 'package:first_app/ui/signup/signup.dart';
import 'package:first_app/services/auth.dart';
import 'package:first_app/models/user.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  notificationPlugin.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'login',
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
      ),
      home: wrapper(),
    );
  }
}

/*
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      value: AuthHelper().user,
      child: MaterialApp(
        home: wrapper(),
      ),
    );
  }
}*/

/*class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Home();
    }
    return Login();
  }
}
*/
