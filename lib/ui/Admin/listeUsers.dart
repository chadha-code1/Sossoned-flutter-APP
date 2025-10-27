import 'package:ant_icons/ant_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/userCard.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/auth.dart';
import 'package:first_app/ui/Admin/adduser.dart';
import 'package:first_app/ui/Admin/userDetails.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  TextEditingController _searchController = TextEditingController();

  UserData userk;
  AuthHelper auth = AuthHelper();
  Future<void> getUser() async {
    //final UserData user = Provider.of(context);
    User user = await auth.user;
    if (user != null) {
      final userresult = await FirestoreServices().getUser(user.uid);
      if (mounted) {
        setState(() {
          userk = userresult;
          //UserData.currentUser = userresult;
        });
      }
    } else {
      print('user null');
    }
  }

  void initState() {
    getUser();
    super.initState();
  }

  void dispose() {
    super.dispose();
    print('dispose');
  }

  var isSelected = false;
  var mycolor = Colors.white;
  String key = '';
  @override
  Widget build(BuildContext context) {
    getUser();
    var allUsers = Provider.of<List<UserData>>(context);
    var filteredu = allUsers;
    if (key != '')
      filteredu = filteredu.where((u) {
        return u.nomP.toLowerCase().contains(key.toLowerCase());
      }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Liste des utilisateurs'),
          // backgroundColor: Colors.blue,
        ),
        body: allUsers == null
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
            : allUsers.length == 0
                ? Center(child: Text("Aucun utilisateur"))
                : Container(
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, bottom: 30.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Rechercher utilisateur'),
                          onChanged: (value) {
                            // Update the key when the value changes.
                            setState(() => key = value);
                          },
                        ),
                      ),
                      key == null
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: allUsers.length,
                                itemBuilder: (_, i) {
                                  final userm = allUsers[i];
                                  return Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            selected: isSelected,
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        StreamProvider<
                                                            List<
                                                                Reclamations>>.value(
                                                          value:
                                                              FirestoreServices()
                                                                  .getRec(userm
                                                                      .uid),
                                                          child: UserDetail(
                                                              user: userm),
                                                        ))),
                                            leading: CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  Colors.blue.shade900,
                                              backgroundImage: userm.image !=
                                                      null
                                                  ? NetworkImage(userm.image)
                                                  : null,
                                              child: userm.image != null
                                                  ? Container()
                                                  : Icon(AntIcons.user,
                                                      color: Colors.white),
                                            ),
                                            title: Text("${userm.nomP}"),
                                            subtitle: Text("${userm.email}"),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (userm.role != 'admin')
                                                  IconButton(
                                                    icon: Icon(
                                                        userm.autorise
                                                            ? Icons.lock_open
                                                            : Icons.lock,
                                                        color: userm.autorise
                                                            ? Colors
                                                                .blue.shade900
                                                            : Colors.red),
                                                    onPressed: () async {
                                                      await FirestoreServices()
                                                          .updateUser(userm
                                                            ..autorise = !userm
                                                                .autorise);
                                                    },
                                                  ),
                                                if (userm.role == 'admin')
                                                  Icon(
                                                    Icons.star,
                                                    color:
                                                        Colors.yellow.shade900,
                                                  )
                                              ],
                                            ),
                                            onLongPress: toggleSelection),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 30, right: 5),
                                          height: 1,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredu.length,
                                itemBuilder: (_, i) {
                                  final userm = filteredu[i];
                                  return Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            selected: isSelected,
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        StreamProvider<
                                                            List<
                                                                Reclamations>>.value(
                                                          value:
                                                              FirestoreServices()
                                                                  .getRec(userm
                                                                      .uid),
                                                          child: UserDetail(
                                                              user: userm),
                                                        ))),
                                            leading: CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  Colors.blue.shade900,
                                              backgroundImage: userm.image !=
                                                      null
                                                  ? NetworkImage(userm.image)
                                                  : null,
                                              child: userm.image != null
                                                  ? Container()
                                                  : Icon(AntIcons.user,
                                                      color: Colors.white),
                                            ),
                                            title: Text("${userm.nomP}"),
                                            subtitle: Text("${userm.email}"),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (userm.role != 'admin')
                                                  IconButton(
                                                    icon: Icon(
                                                        userm.autorise
                                                            ? Icons.lock_open
                                                            : Icons.lock,
                                                        color: userm.autorise
                                                            ? Colors
                                                                .blue.shade900
                                                            : Colors.red),
                                                    onPressed: () async {
                                                      await FirestoreServices()
                                                          .updateUser(userm
                                                            ..autorise = !userm
                                                                .autorise);
                                                    },
                                                  ),
                                                if (userm.role == 'admin')
                                                  Icon(
                                                    Icons.star,
                                                    color:
                                                        Colors.yellow.shade900,
                                                  )
                                              ],
                                            ),
                                            onLongPress: toggleSelection),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 30, right: 5),
                                          height: 1,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                    ]),
                  ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade900,
          child: Icon(AntIcons.user_add_outline),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => AddUser()));
          },
        ));
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.grey[300];
        isSelected = true;
      }
    });
  }
}
/*class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    final allUsers = Provider.of<List<UserData>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des utilisateurs'),
        backgroundColor: Colors.blue,
      ),
      body: allUsers == null
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ))
          : allUsers.length == 0
              ? Center(child: Text("Aucun utilisateur"))
              : ListView.builder(
                  itemCount: allUsers == null ? 0 : allUsers.length,
                  itemBuilder: (_, i) {
                    final userm = allUsers[i];

                    return i == allUsers.length - 1
                        ? Container(
                            child: UserCard(u: userm),
                            margin: EdgeInsets.only(bottom: 80),
                          )
                        : UserCard(u: userm);
                  }),
    );
  }
}*/
