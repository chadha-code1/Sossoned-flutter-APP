import 'package:first_app/models/NotificationPlugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController titlecontr = TextEditingController();
  final TextEditingController bodycontr = TextEditingController();

  String titre;
  String body;
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: 420,
              width: 310,
              child: Form(
                key: _formKey,
                child: Container(
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                            controller: titlecontr,
                            decoration: InputDecoration(
                                labelText: 'Titre de notification '),
                            keyboardType: TextInputType.text,
                            validator: (e) =>
                                e.isEmpty ? 'Remplir ce champ' : null,
                            onChanged: (e) {
                              setState(() => titre = e);
                            }),
                        TextFormField(
                            controller: bodycontr,
                            decoration:
                                InputDecoration(labelText: 'Description  '),
                            keyboardType: TextInputType.text,
                            validator: (val) =>
                                val.isEmpty ? 'Remplir ce champ' : null,
                            onChanged: (val) {
                              setState(() => body = val);
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                              ),
                              ElevatedButton(
                                child: Text('Annuler'),

                                onPressed: () {
                                  _formKey.currentState.reset();
                                },
                                //**********bouton */
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey.shade700,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.grey,
                                    shadowColor: Colors.grey,
                                    elevation: 5,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text('Envoyer',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),

                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await notificationPlugin.showNotification(
                                        titre, body);
                                  }
                                },
                                //**********bouton */
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue.shade900,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.grey,
                                    shadowColor: Colors.grey,
                                    elevation: 5,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
