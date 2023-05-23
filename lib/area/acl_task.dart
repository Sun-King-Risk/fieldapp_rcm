import 'dart:core';
import 'package:fieldapp_rcm/area/agent.dart';
import 'package:fieldapp_rcm/area/pending_calls.dart';
import 'package:fieldapp_rcm/services/calls_detail.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/user_detail.dart';
import 'complete_calls.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);
  @override
  CustomerState createState() => CustomerState();
}

class CustomerState extends State<Customer> {
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
    return snapshot;
  }
  initState() {
    // at the beginning, all users are shown
    userArea();
    dataAll();
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
          Container(
            child: TabBar(tabs: [
              Tab(
                text: "Pending ",
              ),
              Tab(text: "Completed"),
              //Tab(text: "Agent"),
            ]),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: TabBarView(
                children: [
                  PendingCalls(),
                  CompleteCalls(),
                  //AgentTask(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
