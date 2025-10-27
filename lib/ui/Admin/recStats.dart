import 'dart:math' as math;
//Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/reclamation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

countDocuments() async {
  QuerySnapshot _myDoc =
      await FirebaseFirestore.instance.collection('Reclamations').get();
  List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  print(_myDocCount.length);
  // Count of Documents in Collection
  return _myDocCount.length;
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<charts.Series<Reclamations, String>> _seriesPieData;
  var c = countDocuments();
  List<Reclamations> mydata;
  _generateData(mydata) {
    _seriesPieData = List<charts.Series<Reclamations, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Reclamations rec, _) => rec.gouv,
        measureFn: (Reclamations rec, _) => c,
        colorFn: (Reclamations rec, _) => charts.ColorUtil.fromDartColor(
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0)),
        id: 'recs',
        data: mydata,
        labelAccessorFn: (Reclamations row, _) => "${row.gouv}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    countDocuments();

    return Scaffold(
      appBar: AppBar(title: Text('Réclamations')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reclamations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Reclamations> recs = snapshot.data.docs
              .map((documentSnapshot) =>
                  Reclamations.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, recs);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Reclamations> taskdata) {
    mydata = taskdata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Statistique réclamation',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: Expanded(
                  child: charts.PieChart(_seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.endDrawArea,
                          horizontalFirst: false,
                          desiredMaxRows: 2,
                          cellPadding: new EdgeInsets.only(
                              right: 4.0, bottom: 4.0, top: 4.0),
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.purple.shadeDefault,
                              fontFamily: 'Georgia',
                              fontSize: 18),
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
