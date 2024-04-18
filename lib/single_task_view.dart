
import 'package:fieldapp_rcm/update/pilot_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/db.dart';

class SingleTask extends StatefulWidget {
  const SingleTask({Key? key,required this.subtask, required this.task, required this.id, required this.title})
      : super(key: key);
  final title;
  final id;
  final task;
  final subtask;


  @override
  SingleTaskState createState() => SingleTaskState();


}

class SingleTaskState extends State<SingleTask> {
  String? selectedTask;
  String? actionTask;
  final List<String> Yes = [
    "Yes",
    "No"
  ];
  final List<String> No = [
    "Yes_no",
    "No_no"
  ];
  late Map<String, List<String>> dataset = {
    'No': No,
    'Yes': Yes,


  };
  onTaskChanged(String? value) {

    if (value != selectedTask) actionTask = null;
    setState(() {
      selectedTask = value;
    });
  }
  final _key = GlobalKey();
  List data = [];
  Future<http.Response> fetchData() async {
    const apiUrl = '${AppUrl.baseUrl}/task/12/';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _data = [];
  Future<void> _getDocuments() async {
    QuerySnapshot querySnapshot =
    await firestore.collection("task").doc(widget.task).collection('action').get();
    setState(() {
      _data = querySnapshot.docs;
      var denn = _data.toList();
      print(denn);
    });
  }


  @override
  void initState() {
    fetchData();
    _getDocuments();
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),),
            body: SingleChildScrollView(
              child: Form(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      if(widget.title == "Portfolio Quality")
                        const PilotUpdate(subtask: null,taskGoalId: null,  id: null, title: null,),
                      if(widget.title== "Pilot Management")
                        const PilotUpdate(subtask: null, taskGoalId: null, id: null, title: null,),
                      if(widget.title == "Collection Drive")
                        const PilotUpdate(subtask: null,taskGoalId: null,  id: null, title: null,),
                      const SizedBox(height: 10,),

                    ],
                  ),
                ),
              ),
            ),
          );




  }
}

class PendingRequest extends StatelessWidget {
  Color status;
  String TittleName;
  final id;
  PendingRequest({
    Key? key,
    required this.status,
    required this.TittleName,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dennis $id"),
      ),
      body: Container(
        height: 305,
        padding: const EdgeInsets.only(left: 5, right: 10, bottom: 0, top: 5),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: status, //shadow for button
                  blurRadius: 5) //blur radius of shadow
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              TittleName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Main Task:",
                    style: TextStyle(fontSize: 13.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Sub Task:",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Area:",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Priority:",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Users:",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Task approved on 23/10 By Manager name:",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
                height: 20,
                child: ListTile(
                  title: Text(
                    "Task Description:",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                )),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Start Date: 24/10"),
                Text("End Date:31/10"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


