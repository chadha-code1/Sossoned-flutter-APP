import 'package:first_app/components/constant.dart';
import 'package:first_app/components/dropdown.dart';
import 'package:first_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/ui/authentification/login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Signup extends StatefulWidget {
  static const routeName = '/signups';

  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email;
  String gouv;
  int numTel;
  String password;
  String nomp;

  String cin;
  List<String> city = [
    'Ariana',
    'Béja',
    'Ben Arous',
    'Bizert',
    'Gabès',
    'Gafsa',
    'Kairouan',
    'Kasserine',
    'Kébili',
    'Kef',
    'Mahdia',
    'Manouba',
    'Médenine',
    'Mounastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan'
  ];
  String v = 'Choisir Gouvernorat';
  final AuthHelper _auth = AuthHelper();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailctr = TextEditingController();
  final TextEditingController pwctr = TextEditingController();
  final TextEditingController numctr = TextEditingController();
  final TextEditingController gouvctr = TextEditingController();
  String error = '';

  String role = 'user';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('S \'inscrire '),
        // actions: <Widget>[],
      ),
      body: Stack(children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
              Colors.blue[50],
              Colors.blue,
              Colors.blue[900],
            ]))),
        Center(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                  height: 540,
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Nom Prénom'),
                            keyboardType: TextInputType.name,
                            validator: (val) => val.isEmpty
                                ? 'Enter votre nom et prénom'
                                : null,
                            onChanged: (val) {
                              setState(() => nomp = val);
                            },
                          ),

                          //mail
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                                val.isEmpty || !val.contains('@')
                                    ? ' Email invalide'
                                    : null,
                            onChanged: (val) {
                              setState(() => email = val.trim());
                            },
                          ),
                          //password
                          TextFormField(
                            controller: pwctr,
                            decoration:
                                InputDecoration(labelText: 'Mot de Passe'),
                            obscureText: true,
                            validator: (val) => val.isEmpty
                                ? 'Mot de passe invalide'
                                : val.length < 6
                                    ? "le Mot de passe doit être plus de 6 chiffres"
                                    : null,
                            onChanged: (val) {
                              setState(() => password = val.trim());
                            },
                          ),
                          // confirm password
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Verifier Mot de Passe'),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value != pwctr.text) {
                                return ' Mot de Passe invalide ';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Num'),
                            keyboardType: TextInputType.number,
                            validator: (val) => val.isEmpty ||
                                    val.length < 8 ||
                                    val.contains('@') ||
                                    val.contains('.')
                                ? 'Enter un numéro de téléphone'
                                : null,
                            onChanged: (val) {
                              setState(() => numTel = int.parse(val.trim()));
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Cin'),
                            keyboardType: TextInputType.number,
                            validator: (val) => val.isEmpty ||
                                    val.contains('@') ||
                                    val.contains('.')
                                ? 'Enter a cin'
                                : null,
                            onChanged: (val) {
                              setState(() => cin = val.trim());
                            },
                          ),
                          /* TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Gouvernaurat'),
                            keyboardType: TextInputType.streetAddress,
                            validator: (val) =>
                                val.isEmpty ? 'Enter gouv' : null,
                            onChanged: (val) {
                              setState(() => gouv = val);
                            },
                          ),*/
                          Card(
                              elevation: 1,
                              margin: EdgeInsets.only(bottom: 3),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                hint: Text('Choisir Gouvernorat'),
                                items: city.map((c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Text("$c"),
                                  );
                                }).toList(),
                                value: gouv,
                                onChanged: (val) async {
                                  gouv = val;
                                  setState(() {
                                    v = val;

                                    gouv = val;
                                  });
                                  ;
                                },
                              ))),
                          SizedBox(
                            height: 30,
                          ),
                          //submit button****************
                          ElevatedButton(
                            child: Text('S\'inscrire'),
                            onPressed: () async {
                              if (_formKey.currentState.validate() &&
                                  gouv != null) {
                                dynamic user =
                                    await _auth.registerWithEmailAndPassword(
                                        email,
                                        password,
                                        numTel,
                                        gouv,
                                        cin,
                                        role,
                                        nomp);

                                if (user != null) {
                                  print("user signed up successfully");
                                  setState(() {}); //message et pop
                                  //  Navigator.of(context).pop();
                                } else
                                  //
                                  error = 'Please supply a valid email';

                                // messagesBleu("'Please supply a valid email'");
                              } else {
                                messages('veuillez remplir tous les champs');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                onSurface: Colors.grey,
                                shadowColor: Colors.grey[400],
                                elevation: 5,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                )),
                          ),
                          /***********Row** */
                          Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 50,
                                  )),
                            ),
                            Text("OU"),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 10.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 50,
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
                        ],
                      )))),
        ),
      ]),
    );
  } //handwritten

  void _showErrorOrSuccesDialog(String messageTitle, String messageText) {
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
                    Navigator.pushNamed(context, Login.routeName);
                  }
                },
                child: Text("Dismiss")),
          ],
        );
      },
    );
  }
}
