import 'package:first_app/components/constant.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/auth.dart';
import 'package:first_app/services/firestore.dart';
import 'package:first_app/ui/BackGround/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:first_app/ui/signup/signup.dart';
import 'package:first_app/ui/authentification/resetpw.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:first_app/ui/home/home.dart';
//import 'package:flutter/src/material/icons.dart';
//import 'package:flutter_icons/flutter_icons.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:first_app/ui/wrapper.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController emailctr = TextEditingController();
  final TextEditingController pwctr = TextEditingController();
  final AuthHelper _auth = AuthHelper();
  final GlobalKey<FormState> _formKey = GlobalKey();

  AnimationController _controller;

  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);
  UserData userm;

  Future<void> getUserm(String id) async {
    final u = await FirestoreServices().getUser(id);
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

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  String error = '';
  bool loading = false;
  String email;
  String password;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller.view,
              ),
            ),
          ),

          //Center(
          // Child:

          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    //width: double.infinity,
                    //height: 420,
                    width: 300,
                    //padding: EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 60, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "SOS SONEDE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 210.0,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image.asset(
                                    'sonede.png',
                                    height: 120,
                                    alignment: Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: Form(
                              key: _formKey,
                              child: ListView(
                                children: <Widget>[
                                  //mail
                                  TextFormField(
                                      controller: emailctr,
                                      decoration:
                                          InputDecoration(labelText: 'Email'),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter un email' : null,
                                      onChanged: (val) {
                                        setState(() => email = val.trim());
                                      }),

                                  TextFormField(
                                      controller: pwctr,
                                      decoration: InputDecoration(
                                          labelText: 'Mot de passe'),
                                      obscureText: true,
                                      validator: (val) => val.isEmpty
                                          ? 'Entrer mot de passe'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    child: Text("Mot de passe oublié",
                                        style:
                                            TextStyle(color: Colors.lightBlue)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ResetPassword()));
                                    },
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        height: 40,
                                        width: 300,
                                        child: ElevatedButton(
                                          child: Text('Login'),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() => loading = true);
                                              try {
                                                final user = await _auth
                                                    .signInWithEmailAndPassword(
                                                        email, password);

                                                if (user != null) {
                                                  // getUserm(user.uid);
                                                  print("login successful");
                                                } else
                                                  setState(() {
                                                    // messagesBleu(
                                                    //   'Email ou mot de passe invalide ');

                                                    error =
                                                        'entrer un email valide';
                                                  });
                                              } catch (e) {
                                                print(e);
                                              }
                                            }
                                          },

                                          // context.read<AuthentificationService>().SignIn(
                                          //   emailctr.text.trim(), pwctr.text.trim());

                                          //shape: RoundedRectangleBorder(
                                          // borderRadius: BorderRadius.circular(30),
                                          // ),
                                          //**********bouton */
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              onPrimary: Colors.white,
                                              onSurface: Colors.grey,
                                              shadowColor: Colors.grey,
                                              elevation: 5,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: new Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 15.0),
                                          child: Divider(
                                            color: Colors.black,
                                            height: 40,
                                          )),
                                    ),
                                    Text("OU"),
                                    Expanded(
                                      child: new Container(
                                          margin: const EdgeInsets.only(
                                              left: 15.0, right: 10.0),
                                          child: Divider(
                                            color: Colors.black,
                                            height: 40,
                                          )),
                                    ),
                                  ]),

                                  GoogleSignInButton(
                                    onPressed: () async {
                                      final dynamic user =
                                          await _auth.signInWithGoogle();
                                      if (user == null) {
                                        setState(() {
                                          error =
                                              'Could not sign in with those credentials';
                                        });
                                      }
                                    },
                                    darkMode: false, // default: false
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  TextButton(
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Signup(),
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 1),
                                          Expanded(
                                            child: Text(
                                              "vous n'avez pas un compte? s'inscrire",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),

                                  //new Image.asset('assets/son.png'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*void _showErrorOrSuccesDialog(String messageTitle, String messageText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(messageTitle),
          content: Text(messageText),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if (messageTitle == "Success!") {
                    Navigator.pushNamed(context, HomeScreen.routeName);
                    //nav.of(ctx).pop();
                  }
                },
                child: Text("Dismiss")),
          ],
        );
      },
    );
  }*/

  void dispose() {
    emailctr.dispose();
    pwctr.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(
        "assets/son.png",
        height: 100,
        width: 100,
      ),
    );
  }
}
