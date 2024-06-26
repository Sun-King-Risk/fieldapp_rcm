import 'dart:convert';
import 'package:fieldapp_rcm/report.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/task_table.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'location.dart';
import 'models/db.dart';
import 'pending_task.dart';
import 'team_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskData {
  Future<int> countTask(String taskTitle, String name) async {
    final url = Uri.parse('${AppUrl.baseUrl}/tasks');
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
    final url = Uri.parse('${AppUrl.baseUrl}/tasks');
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
  const Task({super.key});

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
  String email ="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAttributes();
  }

  void getUserAttributes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {

        singleRegion = prefs.getString("region")!;
        country = prefs.getString("country")!;
        role = prefs.getString("role")!;
        name = prefs.getString("name")!;
        email = prefs.getString("email")!;
      });

      CompleteRate(name);
      if (kDebugMode) {
        print(attributeList.toList());
        print(name);
      }

  }

  void CompleteRate(String name) async {
    final url = Uri.parse('${AppUrl.baseUrl}/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> Tasks =
          jsonData.where((task) => task['submited_by'] == name).toList();
      final List<dynamic> completeTasks = jsonData
          .where((task) =>
              task['task_status'] == 'Completed' && task['submited_by'] == name)
          .toList();
      int totalTask = Tasks.length ;
      int completeTask = completeTasks.length ;
      var TaskcompleteRate = (completeTask / totalTask) * 100;
      print("_completeTask $completeTask");
      print("_totalTask $totalTask");
      print("TaskcompleteRate $TaskcompleteRate");
      setState(() {
        totaltask = totalTask;
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
              constraints: const BoxConstraints.expand(height: 40),
              child: const TabBar(tabs: [
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
                margin: const EdgeInsets.all(15),
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(
                                  40), // fromHeight use double.infinity as width and 40 is the height
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LocationMap(),
                                  ));
                            },
                            child: const Text("Map")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(
                                  40), // fromHeight use double.infinity as width and 40 is the height
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TaskAddDrop(),
                                  ));
                            },
                            child: const Text("Add New Task")),
                        Card(
                          shadowColor: Colors.amber,
                          color: Colors.black,
                          child: ListTile(
                            title: Center(
                                child: Text(
                                    "Overrall Task Complete Rate $completeRate%",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.yellow))),
                            dense: true,
                          ),
                        ),
                        TaskList(
                          task_title: 'Portfolio Quality',
                          name: name,
                        ),
                        /*TaskList(
                          task_title: 'Pilot/Process Management',
                          name: name,
                        ),*/
                        TaskList(
                          task_title: 'Collection Drive',
                          name: name,
                        ),
                        /*TaskList(
                          task_title: 'Customer Management',
                          name: name,
                        ),*/
                        TaskList(
                          task_title: 'Team Management',
                          name: name,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: const TeamTask(),
                  ),
                  Container(
                    child: const PendingTask(),
                  ),
                  Container(
                    child: const Report(),
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
    var url = Uri.parse('${AppUrl.baseUrl}/tasks');
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
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 5),
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.task_title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<int>(
                  stream: taskData
                      .countTask(widget.task_title, widget.name)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text(
                        "${snapshot.data} Total",
                        style: const TextStyle(color: Colors.green),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('No data available');
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text(
                        "${snapshot.data} Completed",
                        style: const TextStyle(color: Colors.yellow),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
                StreamBuilder<int>(
                  stream: taskData
                      .countByStatus(widget.task_title, 'Pending', widget.name)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text(
                        "${snapshot.data} Pending",
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('No data available');
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
