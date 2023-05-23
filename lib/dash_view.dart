import 'dart:convert';

import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashView extends StatefulWidget {
  @override
  final title;
  final value;
  DashView(this.title, this.value);
  DashViewState createState() => DashViewState();
}

class DashViewState extends State<DashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
            stream: RegionData().getDataArea(widget.title).asStream(),
            builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 30.0,
                      animation: true,
                      center: new Text(
                        widget.value,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      footer: new Text(
                        widget.title,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: AppColor.mycolor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Container(
                            height: 100,
                            width: 150,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data!.docs.last[widget.title]
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.green),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data!.docs.last['Area']),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("best performance")
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            height: 100,
                            width: 150,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data!.docs.first[widget.title]
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.red),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data!.docs.first['Area']),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Poor performance")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.size,
                          itemBuilder: (BuildContext context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            return ListTile(
                                leading: const Icon(Icons.list),
                                trailing: Text(
                                  data[widget.title].toString(),
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                                title: Text(data['Area']));
                          }),
                    )
                  ],
                );
              }
              else if (snapshot.hasError) {
                return Text('Error Loding data');
              } else {
                return Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Loading...'),
                  ],
                );
              }
            }));
  }
}
