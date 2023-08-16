// main.dart
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

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
                  Column(
                    children: [
                      Text(docid.toString()),

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
                    ],
                  ),



                ]

            )
        );
      }
  );

}


  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
List? data = [];
  List? singledata = [];
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    fetchData();

  }

  void singleTask(){
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');

  }

  void fetchData() async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body).where((approval){
          return approval['is_approved'] == 'Pending';
        }).toList();
      });
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SinglePending(id:task["id"]),
                    ));

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

class SinglePending extends StatefulWidget{

  final id;
  @override
  const SinglePending({Key? key,required this.id}) : super(key: key);

  @override
  SinglePendingState createState() => SinglePendingState();
  
}
class SinglePendingState extends State<SinglePending> {
  Map<String, dynamic>  data = {};
  String code = '';
  Future fetchData() async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks/${widget.id}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        data = jsonDecode(response.body);
        code = url.toString();
      });
      fetchGoal(widget.id);
      safePrint(data);
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
  }
  List? taskgoal = [];
  var priority;
  var goal;
  var description;
  List<String> _priorities = ['High', 'Medium', 'Low'];
  Future fetchGoal(id) async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        print(response.body);
        taskgoal = filteredTasks;
      });
      safePrint(data);
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    safePrint(widget.id);
  }
  _goalUpdate(id,current) async{
    showDialog(context: context,
        builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          content: Text('Task Update $id'),
          actions: <Widget>[

            Form(
              child: Column(
                children: [
                  TextField(
                      decoration: InputDecoration(
                        hintText: 'Description',
                        labelText: 'Description',
                      ),
                      onChanged: (value) {
                        setState(() {
                          description =  value;
                        });
                      }
                  ),
                  Text("Current: $current"),
                  TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Enter Target',
                      labelText: 'New Target',
                    ),
                    onChanged: (value) {
                      setState(() {
                        goal =  value;
                      });
                    },
                  ),
                  SizedBox(height: 8,),
                  AppDropDown(
                      disable: true,
                      label: "Priority",
                      items: _priorities,
                      hint: "Priority",
                      onChanged: (value){
                        setState(() {
                          priority = value;
                        });

                        print(value);
                      }),
                  Center(child: ElevatedButton(onPressed: () async {
          Map data = {
            "goals": goal,
            "task_description": description,
            "priority": priority,
          };
          var body = json.encode(data);
          var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals/$id/update/');
          http.Response response = await http.post(url, body: body, headers: {
            "Content-Type": "application/json",
          });
          var result_task = jsonDecode(response.body);


                  }, child: Text('Update')))
                ],
              ),
            )
          ],
        ),
      );
        });
  }
  _taskStatus(docid)async{
    bool _approved = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: AlertDialog(
                  content: Text('Do you approve or reject this task?'),
                  actions: <Widget>[
                    Column(
                      children: [
                        Text(docid.toString()),

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
                                Navigator.pop(context);
                                Navigator.of(context).pop();

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
                                Navigator.pop(context);
                                Navigator.of(context).pop();

                              },
                            )
                          ],
                        )
                      ],
                    ),



                  ]

              )
          );
        }
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(8),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title: ${data['task_title']}",
                            style: TextStyle(
                              fontSize: 15,
                            ),

                          ),
                          Text(
                            "Task: ${data['sub_task']}",
                            style: TextStyle(
                              fontSize: 15,
                            ),

                          ),
                          Text(
                            "Region:${data['task_region']} Area: ${data['task_area']}",
                            style: TextStyle(
                              fontSize: 15,
                            ),

                          ),
                          Text(
                            "Start:${data['task_start_date']}  End:${data['task_end_date']} ",
                            style: TextStyle(
                              fontSize: 15,
                            ),

                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: taskgoal!.length,
              itemBuilder: (context, index) {
                var task = taskgoal![index];
                return GestureDetector(
                    onTap: () {
                      _goalUpdate(task['id'],task['previous_goal']);
                      // Handle tap gesture
                    },
                    child:Row(
                      children: [
                        // Icon(Icons.,color: AppColor.mycolor,),
                        // SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            color: Colors.yellow.shade50,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name: ${task['account_number']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "Description: ${task['task_description']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "Priority: ${task['priority']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "current: ${task['previous_goal']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "Goal: ${task['goals']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),

                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                );
              },
            ),
            ElevatedButton(
                onPressed: (){
                  _taskStatus(widget.id);
                }, child: Text("Approve"))

          ],
        ),
      ),),
    );
  }
  
}
