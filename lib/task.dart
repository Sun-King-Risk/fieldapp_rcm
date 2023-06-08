

import 'dart:convert';

import 'package:fieldapp_rcm/new_design.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:fieldapp_rcm/task_table.dart';
import 'package:http/http.dart' as http;
import 'pending_task.dart';
import 'team_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TaskData {
  Future<int> countTask(String taskTitle) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task_title'] == taskTitle)
          .toList();
      return filteredTasks.length;

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<int> countByStatus(String taskTitle, String status) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task_title'] == taskTitle).where((task) => task['task_status'] == status)
          .toList();

      // Process jsonData to count tasks with the given status
      return filteredTasks.length; // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }
}

class Task extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 40),
              child: TabBar(tabs: [

                Tab(text: "My Task",),
                Tab(text: "Team Task"),
                Tab(text: "Pending/Request"),
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
                              minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                            ),
                            onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskRadio(),
                                    ));
                            },
                            child: Text("Add New Task")),
                        Card(
                          shadowColor: Colors.amber,
                          color: Colors.black,
                          child: ListTile(
                            title: Center(child: Text("Overrall Task Complete Rate 34%", style: TextStyle(fontSize: 15,color: Colors.yellow))),
                            dense: true,
                          ),
                        ),

                        TaskList(
                          task_title: 'Collection Drive',


                        ),
                        TaskList(
                          task_title: 'Process Management',
                         


                        ),
                        TaskList(
                          task_title: 'Pilot Management',
                         


                        ),
                        TaskList(
                          task_title: 'Portfolio Quality',
                          


                        ),
                        TaskList(
                          task_title: 'Customer Management',
                         


                        ),
                      ],
                    ),

                  ),
                  Container(
                    child: TeamTask(),
                  ),
                  Container(

                    child:PendingTask(),
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
  const TaskList({Key? key,
    required this.task_title,

  })
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
    }else{
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
              builder: (context) => MyTaskView(endPoint: 'tasks',title: widget.task_title,),
            ));
      },

      child:Container(
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
                FutureBuilder<int>(
                  future: taskData.countTask(widget.task_title),
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
                FutureBuilder<int>(
                  future: taskData.countByStatus(widget.task_title, 'Completed'),
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
                FutureBuilder<int>(
                  future: taskData.countByStatus(widget.task_title, 'Pending'),
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



