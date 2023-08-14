import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/report.dart';
import 'package:fieldapp_rcm/task_table.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'location.dart';
import 'multform.dart';
import 'pending_task.dart';
import 'team_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskData {
  Future<int> countTask(String taskTitle, String name) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) =>
              task['task_title'] == taskTitle && task['submited_by'] == name)
          .toList();
      return filteredTasks.length;

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<int> countByStatus(
      String taskTitle, String status, String name) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) =>
              task['task_title'] == taskTitle &&
              task['submited_by'] == name &&
              task['task_status'] == status)
          .toList();

      // Process jsonData to count tasks with the given status
      return filteredTasks.length; // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }
}

class Task extends StatefulWidget {
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<String> attributeList = [];
  String name = "";
  String role = '';
  String singleRegion = '';
  String country = '';
  double completeRate = 0;
  int totaltask = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAttributes();
  }

  void getUserAttributes() async {
    try {
      AuthUser currentUser = await Amplify.Auth.getCurrentUser();
      List<AuthUserAttribute> attributes =
          await Amplify.Auth.fetchUserAttributes();
      List<String> attributesList = [];
      for (AuthUserAttribute attribute in attributes) {
        print(attribute.value);

        if (attribute.userAttributeKey.key.contains("custom")) {
          var valueKey = attribute.userAttributeKey.key.split(":");
          attributesList.add('${valueKey[1]}:${attribute.value}');
          print(valueKey[1]);
        } else {
          attributesList
              .add('${attribute.userAttributeKey.key}:${attribute.value}');
        }
      }
      setState(() {
        attributeList = attributesList;
        singleRegion = attributeList[7].split(":")[1];
        country = attributeList[4].split(":")[1];
        role = attributeList[5].split(":")[1];
      });
      name = attributeList[3].split(":")[1];
      CompleteRate(name);
      if (kDebugMode) {
        print(attributeList.toList());
        print(attributeList[3].split(":")[1]);
      }
      // Process the user attributes
    } catch (e) {
      print('Error retrieving user attributes: $e');
    }
  }

  void CompleteRate(String name) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> Tasks =
          jsonData.where((task) => task['submited_by'] == name).toList();
      final List<dynamic> completeTasks = jsonData
          .where((task) =>
              task['task_status'] == 'Completed' && task['submited_by'] == name)
          .toList();
      int _totalTask = Tasks.length ;
      int _completeTask = completeTasks.length ;
      var TaskcompleteRate = (_completeTask / _totalTask) * 100;
      print("_completeTask $_completeTask");
      print("_totalTask $_totalTask");
      print("TaskcompleteRate $TaskcompleteRate");
      setState(() {
        totaltask = _totalTask;
        completeRate = TaskcompleteRate;

      });
      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 40),
              child: TabBar(tabs: [
                Tab(
                  text: "My Task",
                ),
                Tab(text: "Team Task"),
                Tab(text: "Pending/Request"),
                Tab(
                  text: "Report",
                ),
              ]),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15),
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(
                                  40), // fromHeight use double.infinity as width and 40 is the height
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationMap(),
                                  ));
                            },
                            child: Text("Map")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(
                                  40), // fromHeight use double.infinity as width and 40 is the height
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyTaskNew(),
                                  ));
                            },
                            child: Text("Add New Task")),
                        Card(
                          shadowColor: Colors.amber,
                          color: Colors.black,
                          child: ListTile(
                            title: Center(
                                child: Text(
                                    "Overrall Task Complete Rate $completeRate%",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.yellow))),
                            dense: true,
                          ),
                        ),
                        TaskList(
                          task_title: 'Portfolio Quality',
                          name: name,
                        ),
                        TaskList(
                          task_title: 'Pilot/Process Management',
                          name: name,
                        ),
                        TaskList(
                          task_title: 'Collection Drive',
                          name: name,
                        ),
                        TaskList(
                          task_title: 'Customer Management',
                          name: name,
                        ),
                        TaskList(
                          task_title: 'Team Management',
                          name: name,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: TeamTask(),
                  ),
                  Container(
                    child: PendingTask(),
                  ),
                  Container(
                    child: Report(),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final String task_title;
  final String name;
  const TaskList({Key? key, required this.task_title, required this.name})
      : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List? data = [];
  void fetchData() async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  final TaskData taskData = TaskData();
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM').format(now);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyTaskView(
                endPoint: 'tasks',
                title: widget.task_title,
                name: widget.name,
              ),
            ));
      },
      child: Container(
        height: 70,
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 5),
        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.task_title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<int>(
                  stream: taskData
                      .countTask(widget.task_title, widget.name)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString() + " Total",
                        style: TextStyle(color: Colors.green),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
                StreamBuilder<int>(
                  stream: taskData
                      .countByStatus(
                          widget.task_title, 'Completed', widget.name)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString() + " Completed",
                        style: TextStyle(color: Colors.yellow),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
                StreamBuilder<int>(
                  stream: taskData
                      .countByStatus(widget.task_title, 'Pending', widget.name)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString() + " Pending",
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
