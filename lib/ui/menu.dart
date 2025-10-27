import 'package:ant_icons/ant_icons.dart';
import 'package:first_app/components/getImage.dart';
import 'package:first_app/models/NotificationPlugin.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Admin/notifPage.dart';
import 'home/edituser.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  initState() {
    super.initState();

    notificationPlugin.init();

    /*notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);*/
  }

  /*onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }*/

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return Container(
      color: Colors.white,
      width: 250,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(user.email ?? "Aucun"),
            accountName: Text(user.nomP ?? "Aucun"),
            currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage:
                    user.image != null ? NetworkImage(user.image) : null,
                child: Stack(children: [
                  if (user.image == null)
                    Center(child: Icon(Icons.person, color: Colors.white)),
                  if (loading)
                    Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )),
                  Positioned(
                    top: 40,
                    left: 32,
                    child: IconButton(
                      icon: Icon(
                        AntIcons.camera,
                        color: Colors.white30,
                      ),
                      onPressed: () async {
                        final data = await showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return GetImage();
                            });
                        if (data != null) {
                          loading = true;
                          setState(() {});
                          String urlImage = await FirestoreServices()
                              .uploadImage(data, path: "profil");
                          if (urlImage != null) {
                            final updateUser = user;

                            updateUser.image = urlImage;
                            bool isupdate =
                                await FirestoreServices().updateUser(user);
                            if (isupdate) {
                              loading = false;
                              setState(() {});
                            }
                          }
                        }
                      },
                    ),
                  )
                ])),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.phone),
            title: Text(
                'Numéro de téléphone:\n' + user.numTel.toString() ?? "Aucun"),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.addressCard),
            title: Text('CIN:\n' + user.cin.toString() ?? "Aucun"),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.home),
            title: Text('Gouvernorat :\n' + user.gouv.toString() ?? "Aucun"),
            onTap: () => {Navigator.of(context).pop()},
          ),
          Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.userEdit),
              title: Text('Modifier Profil'),
              onTap: () => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => UpdateUser(v: user)))
              },
            ),
          ),
          Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Envoyer Notifiations'),
              onTap: () => {
                //NotifPage
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => NotifPage()))
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            onTap: () => {Navigator.of(context).pop()},
          )
        ],
      ),
    );
  }
}
/*class Menu extends StatefulWidget {
  @override
  //final userInfo;
  //Menu({this.userInfo});
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    //  final user = UserData.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Compte'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        width: 250,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text(user.email ?? "Aucun"),
              accountName: Text(user.gouv ?? "Aucun"),
              /* CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage:
                    user.image != null ? NetworkImage(user.image) : null,
                child: Stack(children: [
                  if (user.image == null)
                    Center(child: Icon(Icons.person, color: Colors.black)),
                  if (loading)
                    Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )),
                  Positioned(
                    top: 38,
                    left: 13,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        final data = await showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return GetImage();
                            });
                         if (data != null) {
                            loading = true;
                            setState(() {});
                            String urlImage = await FirestoreServices()
                                .uploadImage(data, path: "profil");
                            if (urlImage != null) {
                              final updateUser = user;
                              updateUser.image = urlImage;
                              bool isupdate =
                                  await FirestoreServices().updateUser(updateUser);
                              if (isupdate) {
                                loading = false;
                                setState(() {});
                              }
                            }
                          }
                      },
                    ),
                  )
                ]
                )
                ),*/
            )
          ],
        ),
      ),
    );
  }
}*/
