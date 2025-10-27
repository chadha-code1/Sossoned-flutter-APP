import 'package:first_app/components/constant.dart';
import 'package:first_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/ui/authentification/login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class AddUser extends StatefulWidget {
  // static const routeName = '/signups';

  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String email, role;
  String gouv;
  int numTel;
  String password;
  int groupe;
  String nomp;

  String cin;
  final AuthHelper _auth = AuthHelper();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailctr = TextEditingController();
  final TextEditingController pwctr = TextEditingController();
  final TextEditingController numctr = TextEditingController();
  final TextEditingController gouvctr = TextEditingController();
  String error = '';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Utilisateur '),
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
                          RadioListTile(
                            title: Text(
                              'Technicien',
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.w700
                              ),
                            ),
                            activeColor: Color(0xff2196F3),
                            value: 1,
                            groupValue: groupe,
                            onChanged: (T) {
                              role = 'technicien';
                              setState(() {
                                groupe = 1;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              'Assistant',
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.w700
                              ),
                            ),
                            activeColor: Color(0xff2196F3),
                            value: 2,
                            groupValue: groupe,
                            onChanged: (T) {
                              role = 'assistant';
                              setState(() {
                                groupe = 2;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              'Admin',
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.w700
                              ),
                            ),
                            activeColor: Color(0xff2196F3),
                            value: 3,
                            groupValue: groupe,
                            onChanged: (T) {
                              role = 'admin';
                              setState(() {
                                groupe = 3;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'CIN'),
                            keyboardType: TextInputType.number,
                            validator: (val) => val.isEmpty ||
                                    val.length < 8 ||
                                    val.contains('@') ||
                                    val.contains('.')
                                ? 'Enter Numéro de  CIN'
                                : null,
                            onChanged: (val) {
                              setState(() => cin = val.trim());
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Nom prénom'),
                            keyboardType: TextInputType.name,
                            validator: (val) => val.isEmpty ||
                                    val.contains('@') ||
                                    val.contains('.')
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
                            validator: (val) => val.isEmpty ||
                                    !val.contains('@') ||
                                    !val.contains('.')
                                ? ' Email invalide'
                                : null,
                            onChanged: (val) {
                              setState(() => email = val.trim());
                            },
                          ),
                          //password
                          TextFormField(
                            controller: pwctr,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'le Mot de passe doit être plus de 6 chiffres '
                                : null,
                            onChanged: (val) {
                              setState(() => password = val.trim());
                            },
                          ),
                          //confirm password
                          /* TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Verify Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value != password) {
                                return 'invalid password';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),*/
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Num'),
                            keyboardType: TextInputType.number,
                            validator: (val) => val.isEmpty ||
                                    val.length < 8 ||
                                    val.contains('@') ||
                                    val.contains('.')
                                ? 'Enter un numéro de telephone'
                                : null,
                            onChanged: (val) {
                              setState(() => numTel = int.parse(val.trim()));
                            },
                          ),
                          Card(
                              elevation: 2,
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
                            child: Text('Ajouter utilisateur'),
                            onPressed: () async {
                              if (_formKey.currentState.validate() &&
                                  gouv != null &&
                                  role != null) {
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
                                } else
                                  setState(() {
                                    error = 'Please supply a valid email';
                                  });
                              } else {
                                messages('veuillez remplir tous les champs');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue.shade900,
                                onPrimary: Colors.white,
                                onSurface: Colors.grey,
                                shadowColor: Colors.grey[400],
                                elevation: 5,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                )),
                          ),
                          /***********Row** */
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
                    //  Navigator.of(context).push(MaterialPageRoute(
                    //builder: (ctx),))
                  }
                },
                child: Text("Dismiss")),
          ],
        );
      },
    );
  }
}
