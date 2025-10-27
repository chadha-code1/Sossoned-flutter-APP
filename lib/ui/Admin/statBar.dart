import 'package:ant_icons/ant_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:first_app/models/stats.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;

class SalesHomePage extends StatefulWidget {
  @override
  _SalesHomePageState createState() {
    return _SalesHomePageState();
  }
}

int v;
countDocuments(String date) async {
  int i;
  i = 0;

  QuerySnapshot _myDoc = await FirebaseFirestore.instance
      .collection('Reclamations')
      .where('recDate', isEqualTo: date)
      .get();
  List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  print(_myDocCount.length);
  v = _myDocCount.length;

  // Count of Documents in Collection
  return v;
}

/*void initState() {
  //countDocuments("");
}*/

class _SalesHomePageState extends State<SalesHomePage> {
  Stats s;

  List<charts.Series<Stats, String>> _seriesBarData;
  List<Stats> mydata;
  var c;
  _generateData(mydata) {
    // ignore: deprecated_member_use
    _seriesBarData = List<charts.Series<Stats, String>>();
    //for (int i = 0; i < mydata.length; i++)
    _seriesBarData.add(
      charts.Series(
        domainFn: (Stats sales, _) {
          // countDocuments(sales.year);
          return sales.year;
        },
        measureFn: (Stats sales, _) => sales.nbr,
        id: 'Statistique',
        data: mydata,
        labelAccessorFn: (Stats row, _) => "${row.year}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reclamations')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Statistiques').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Stats> sales = snapshot.data.docs
              .map((documentSnapshot) => Stats.fromMap(documentSnapshot.data))
              .toList();

          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Stats> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Nombre de reclamations par année',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 3),
                  behaviors: [
                    new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
