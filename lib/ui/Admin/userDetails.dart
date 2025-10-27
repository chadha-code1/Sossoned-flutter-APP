//import 'package:first_app/model/vehicule.dart';
//import 'package:first_app/utils/vehiculeCard.dart';
import 'package:first_app/components/reclamationCard.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetail extends StatelessWidget {
  final UserData user;
  UserDetail({this.user});
  @override
  Widget build(BuildContext context) {
    final List<Reclamations> recs = Provider.of<List<Reclamations>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text("Informations de l'utilisateur"),
      ),
      body: recs == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: recs.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.blue.shade900,
                          backgroundImage: user.image != null
                              ? NetworkImage(user.image)
                              : null,
                          child: user.image != null
                              ? Container()
                              : Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      Text(
                        " ${user.nomP}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text("Email: ${user.email}",
                          style: Theme.of(context).textTheme.bodyText1),
                      Text(
                        "Num Tel: ${user.numTel}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "Cin: ${user.cin}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text("Role: ${user.role}",
                          style: Theme.of(context).textTheme.bodyText1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 20, left: 10),
                        child: Text("reclamations: ${recs.length}",
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ],
                  );
                } else {
                  final rec = recs[i - 1];
                  return i == recs.length
                      ? Container(
                          child: recCard(rec: rec, user: user),
                          margin: EdgeInsets.only(bottom: 80),
                        )
                      : recCard(rec: rec, user: user);
                }
              }),
    );
  }
}
/*class UserDetails extends StatefulWidget {
  final UserData v;
  UserDetails({this.v});
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Color color = Colors.blue;
  /*UserData user;

  getUser() async {
    final u = await FirestoreServices().getUser(widget.v.uid);
    if (u != null) {
      setState(() {
        user = u;
      });
    } else {
      print('user null');
    }
  }

  @override
  void initState() {
    //  implement initState
    super.initState();

    getUser();
  }*/

  @override
  Widget build(BuildContext context) {
    final UserData user = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(widget.v.cin.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Sliders(imgs: widget.v.images),
          SizedBox(
            height: 10,
          ),
          item(widget.v.email, Icons.text_fields),
          item(widget.v.cin.toString(), Icons.timelapse),
          item(widget.v.numTel.toString(), Icons.timelapse),
          item(widget.v.gouv, Icons.timelapse),
          item(widget.v.role, Icons.timelapse),

          Divider(
            color: Colors.black,
          ),
          Text("User"),
          Divider(
            color: Colors.black,
          ),
          if (user != null)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                backgroundImage:
                    user.image != null ? NetworkImage(user.image) : null,
                child: user.image != null
                    ? Container()
                    : Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                radius: 30,
              ),
              subtitle: Text(user.email),
              title: Text(user.gouv),
            ),
          SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }

  ListTile item(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        //  style: style.copyWith(fontSize: 20),
      ),
    );
  }
}*/
