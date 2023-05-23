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
              title: Text('Customer Feedback'),
        content: Text('Do you approve or reject this action?'),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text('Approve'),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('task').doc(docid).update({
                            'is_approved':'approved'
                          });
                          sendFCMNotification('','Task Approved','You can now proceed with your task as it approved');
                          print(docid);
                          Navigator.of(context).pop(true); // Return true to caller
                        },
                      ),
                      TextButton(
                        child: Text('Reject'),
                        onPressed: () async {
                          sendFCMNotification('fGK0oUkSRH6yBay7UKDA31:APA91bE_ohSsbtZ_sxs4hMDUt1rx4TzD8WYSr7_f_1IngMOCSUVJUgAF-HhuXEhGB-T9HSJbMUMKakN75G8o6oQkAlMWsZB6G3e6eurEBLK4sYkJX-MGIK3Uq0sgtNcLIctSeuaVC5Tj','Task Rejected','Your task has been rejected by your manager');
                          await FirebaseFirestore.instance.collection('task').doc(docid).update({
                            'task_status':'reject'
                          });

                          print(docid);
                          Navigator.of(context).pop(true); // Return true to caller
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
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();

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
            StreamBuilder(
              stream: TaskData().PendingTaskRequest('Pending').asStream(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }return Expanded(
                  child: snapshot.hasData
                      ? ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder:  (BuildContext context, int index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      /*final sortedItems = _foundUsers
                        ..sort((item1, item2) => isDescending
                            ? item2['name'].compareTo(item1['name'])
                            : item1['name'].compareTo(item2['name']));
                      final name = sortedItems[index]['name'];*/
                      return InkWell(
                        onTap: () {
                          _taskStatus(data.id);
                        },
                        key: ValueKey(snapshot.data!.docs[index]),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey.shade800,
                              radius: 35,
                              child: Text("1"),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Container(
                                width: 350,
                                height: 90,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(20.0, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text("Requester : ${data['submited_by']}"),
                                        Text("Task : ${data['sub_task']}"),
                                        Text("Area : ${data['task_area']}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) => Divider(),)
                      : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              },
            ),
          ],
        );
  }
}
