import 'dart:core';
import 'package:fieldapp_rcm/area/pending_calls.dart';
import 'package:fieldapp_rcm/services/calls_detail.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/user_detail.dart';
import 'complete_calls.dart';

class AreaDashboard extends StatefulWidget {
  const AreaDashboard({Key? key}) : super(key: key);
  @override
  AreaDashboardState createState() => AreaDashboardState();
}

class AreaDashboardState extends State<AreaDashboard> {
  bool isDescending = false;






  bool newuser = true;
  void userArea(){
    UserDetail().getUserArea().then((value){
      setState(() {
        newuser = false;
      });
    });
  }
  dataAll() async {
    final usersRef = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot<Map<String, dynamic>> snapshot = await usersRef.get();
    print(snapshot.docs.length);
    return snapshot;
  }
  initState() {
    userArea();
    dataAll();
    print(newuser);
    super.initState();
  }
  Widget build(BuildContext context) {

    return newuser?Container(

      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hi! Welcome"),
          Text("You are new user please contact the admin")
        ],
      )
      ,
    ):DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          KpiTittle(
            kpicolor: AppColor.mycolor,
            label: 'Calls Summary',
            txtcolor: Colors.black87,
          ),
          Row(
            children: [
              RowData(
                value: 0,
                label: 'Call Attempt',
                future: USerCallDetail().CountComplete('Call'),
              ),
              RowData(
                value: 0,
                label: 'Call Made',
                future: USerCallDetail().CountCallMade('Call'),
              ),
              RowData(
                label: 'Calls Pending',
                value: 0,
                future: USerCallDetail().CountPendingCall('Call'),
              ),


            ],
          ),
          Row(
            children: [
              RowData(
                value: 0,
                label: 'Complete Rate',
                future: USerCallDetail().CompleteCallRate('Call'),
              ),
              RowData(
                value: 32,
                label: 'Success Calls',
                future: USerCallDetail().CountSucceful('Call'),
              ),
              RowData(
                value: 35,
                label: 'Total Collected',
                future: USerCallDetail().Amount('Call'),
              ),
            ],
          ),
          KpiTittle(
            kpicolor: AppColor.mycolor,
            label: 'Visit Summary',
            txtcolor: Colors.black87,
          ),
          Row(
            children: [
              RowData(
                value: 20,
                label: 'Visit Attempt',
                future: USerCallDetail().CountComplete('Visit'),
              ),
              RowData(
                value: 20,
                label: 'Visit Made',
                future: USerCallDetail().CountVisitMade('Visit'),
              ),
              RowData(
                value: 40,
                label: 'Visit Pending',
                future: USerCallDetail().CountPendingVisit('Visit'),
              ),
            ],
          ),
          Row(
            children: [

              RowData(
                value: 35,
                label: 'Complete Rate',
                future: USerCallDetail().CompleteVistRate('Visit'),
              ),

              RowData(
                value: 20,
                label: 'Success Visit',
                future: USerCallDetail().CountSucceful('Visit'),
              ),
              RowData(
                value: 35,
                label: 'Total Collected',
                future: USerCallDetail().Amount('Visit'),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class KpiTittle extends StatelessWidget {
  final Color kpicolor;
  final String label;
  final Color txtcolor;
  const KpiTittle(
      {Key? key,
        required this.kpicolor,
        required this.txtcolor,
        required this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.amber,
      color: kpicolor,
      child: ListTile(
        title: Center(
            child:
            Text(label, style: TextStyle(fontSize: 20, color: txtcolor))),
        dense: true,
      ),
    );
  }
}

class RowData extends StatelessWidget {
  final int value;
  final String label;
  final future;

  const RowData({Key? key, required this.value, required this.label,required this.future})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<dynamic>(
          future:future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                onTap: () {},
                child: Card(
                  elevation: 3,
                  child: Container(
                    height: 50,
                    width: 100,
                    child: Column(
                      children: [
                        Text(snapshot.data.toString(),
                            style: TextStyle(
                              fontSize: 25,
                            )),
                        Text(label, style: TextStyle(fontSize: 13))
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return InkWell(
                onTap: () {},
                child: Card(
                  elevation: 3,
                  child: Container(
                    height: 40,
                    width: 60,
                    child: Column(
                      children: [
                        Text('0',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        Text(label, style: TextStyle(fontSize: 9))
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Column(children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('run...'),
              ]);
            }
          }),
    );
  }
}
