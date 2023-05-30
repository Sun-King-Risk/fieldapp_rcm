// main.dart
import 'dart:convert';

import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PendingTask extends StatefulWidget {
  const PendingTask({Key? key}) : super(key: key);

  @override
  PendingTaskState createState() => PendingTaskState();
}
class PendingTaskState extends State<PendingTask> {
  Future<void> sendFCMNotification(String deviceToken, String title, String body) async {
    final String serverKey = 'AAAAya62xSc:APA91bGUjqUqPuBqFbrUPgknT3BEnYmQs1b2iRuzdJcS5etSbMgDvDjQocvCmMSnlcRwdrKxHTwfsPSlU0tbtTqiH5ZIkAoiZZmkeNIRTkMCvDJRTsEd_-adCFji2utZHAPgGKhO3byd'; // Replace with your server key
    final String url = 'https://fcm.googleapis.com/fcm/send';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final Map<String, dynamic> data = {
      'notification': {
        title: 'Your request has been approved',
        body: 'You can now proceed with your task',
      },
      'priority':'high',
      'to':deviceToken
    };
    final String encodedData = json.encode(data);

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: encodedData,
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Error sending notification.');
      print('HTTP status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;




  bool isDescending = false;
_taskStatus(docid)async{
  bool _approved = false;
  showDialog(
    context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
        content: Text('Do you approve or reject this action?'),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text('Approve'),
                        onPressed: ()async{
                          Map data = {
                            'is_approved': 'Approved',
                            'task_status': 'Pending'
                          };
                          var body = json.encode(data);
                          var url = Uri.parse('https://www.sun-kingfieldapp.com/api/task/update/$docid/');
                          http.Response response = await http.put(url, body: body, headers: {
                            "Content-Type": "application/json",

                          });
                          var result_task = jsonDecode(response.body);

                          print(result_task);

                        },
                      ),
                      TextButton(
                        child: Text('Reject'),
                        onPressed: () async{
                          Map data = {
                            'is_approved': 'Rejected'
                          };
                          var body = json.encode(data);
                          var url = Uri.parse('https://www.sun-kingfieldapp.com/api/task/update/$docid/');
                          http.Response response = await http.put(url, body: body, headers: {
                            "Content-Type": "application/json",
                          });
                          var result_task = jsonDecode(response.body);

                        },
                      )
                    ],
                  )


                ]

            )
        );
      }
  );

}


  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
List? data = [];
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    fetchData();

  }

  void fetchData() async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
  }

   Future<QuerySnapshot> getFilteredData() async {
    // Get a reference to the Firestore collection
    CollectionReference collection = firestore.collection('task');
    QuerySnapshot alldata = await collection.get();

    // Perform the query and return the snapshot

    return alldata;
  }

// Use the function to retrieve filtered data

  // This function is called whenever the text field changes
  void _searchFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];


    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  void _statusFilter(String _status) {
    List<Map<String, dynamic>> results = [];
    /*switch(_status) {

      case "Complete": { results = _allUsers.where((user) =>
          user["status"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;

      case "Pending": {  results = _allUsers
          .where((user) =>
          user["status"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;

      case "Over due": {  results = _allUsers
          .where((user) =>
          user["status"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;
      case "All": {  results = _allUsers; }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () =>
                        setState(() => isDescending = !isDescending),
                    icon: Icon(
                      isDescending ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 20,
                      color: Colors.yellow,
                    ),
                    splashColor: Colors.lightGreen,
                  ),
                ),
                PopupMenuButton(
                onSelected:(reslust) =>_statusFilter(reslust),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Text("All"),
                        value: "All"
                    ),
                    PopupMenuItem(
                        child: Text("Complete"),
                        value: "Complete"
                    ),
                    PopupMenuItem(
                        child: Text("Pending"),
                        value: "Pending"
                    ),
                    PopupMenuItem(
                        child: Text("Over Due"),
                        value: "Over due"
                    ),
                  ],
                  icon: Icon(
                    Icons.filter_list_alt,color: Colors.yellow
                  ),

                ),
    Expanded(
      child: TextField(
      onChanged: (value) => _searchFilter(value),
      decoration: const InputDecoration(
      labelText: 'Search', suffixIcon: Icon(Icons.search)),
      ),
    )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
    Expanded(
      child: ListView.separated(
        itemCount: data!.length, // Replace with your actual item count
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey,
            height: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          var task = data![index];
          return InkWell(
              onTap: () {
                _taskStatus(task["id"]);
              },
            key: ValueKey(task),
            child: Row(
              children: [
            CircleAvatar(
            backgroundColor: Colors.blueGrey.shade800,
              radius: 35,
              child: Text(task["id"].toString()),

            ),
                SizedBox(
                  width: 5,
                ),
              Flexible(
                child: Container(
                  width: 350,
                  height: 100,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding:  EdgeInsets.fromLTRB(20.0, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text("Requester : ${task!['submited_by']}"),
                            Text("Task : ${task!['sub_task']}"),
                            Text("Area : ${task!['task_area']}"),
                          ],
                      )
                    ),
                  ),
                ),
              )
            ]
            )


          );
        },
      ),
    )
          ],
        );
  }
}
