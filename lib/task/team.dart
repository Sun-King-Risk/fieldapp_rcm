import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fieldapp_rcm/task_actions.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../task.dart';


class Team extends StatefulWidget {
  final Function(List?) onSave;
  final String? subtask;
  final String? area;
  final List? data;
  Team({required this.data,required this.area,required this.subtask,required this.onSave});
  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  String? selectedSubTask;
  List<Map<String, dynamic>> agentList = [];
  initState() {
    getTaskList();
  }
  List? dataTask = [];
  Future<void> getTaskList() async {
    List<Map<String, dynamic>>  uniqueAgentList = [];
    final jsonresult = widget.data;
    final jsonData = jsonresult?.where((item) => item['Area'] == widget.area).toList();
    //List<dynamic> jsonDataList = jsonDecode(jsonData);
    if(widget.subtask == 'Assist a team member to improve the completion rate'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, String> dataagent = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        Map<String, dynamic> dataItem = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Raise a reminder to a team member'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, String> dataagent = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        Map<String, dynamic> dataItem = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Raise a warning to a team member'){
      for (var item in jsonData!) {
        String CustomerName = item['Customer Name'];
        String AngazaID = item['Angaza ID'];
        Map<String, dynamic> dataItem = {
          'display': '$CustomerName - $AngazaID',
          'value': '$CustomerName - $AngazaID',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Raise a new task to a team member'){
      for (var item in jsonData!) {
        String Suspect = item['Suspect Name'];
        String Account = item['Account Number'];

        Map<String, dynamic> dataItem = {
          'display': '$Suspect - $Account',
          'value': '$Suspect - $Account',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Inform the team member of your next visit to his area, and planning needed'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, String> dataagent = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        Map<String, dynamic> dataItem = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Other'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, dynamic> dataItem = {
          'display': '$agent',
          'value': '$agent',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }



    setState(() {
      safePrint('File_team: $uniqueAgentList');
    });

  }
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? _selectedValue;
    return Column(
        children: [
          SizedBox(height: 10,),
          AppMultselect(
            title: widget.subtask!,
            onSave: (value) {

              widget.onSave(value);
              if (value == null) return;

              widget.onSave(value);
            },
            items: dataTask,


          )
        ]
    );
  }
}
/*
class TeamActionScreen extends StatefulWidget {
  @override
  initState() {
  }

  final List? customers;
  final Function(List?) onChange;
  final String region;
  final String Area;
  final String task;
  final String subtask;

  const TeamActionScreen({
    required this.customers,
    required this.onChange,
    required this.Area,
    required this.region,
    required this.task,
    required this.subtask
  });

  @override
  _ActionScreenState createState() => _ActionScreenState();
}

class _ActionScreenState extends State<TeamActionScreen> {
  initState() {
    print(widget.customers);
    print("Aree ${widget.Area}");
    print("Sub ${widget.subtask}");
  }
  List<String> _priorities = ['High', 'Medium', 'Low'];

  Map<String, Map<String, String>> _actions = {};
  bool target = false;
  List<String> data = ["1%","2%","3%","4%","5%"];
  String? label = '';

  @override
  Widget build(BuildContext context) {
    if(widget.subtask =='Visiting unreachable welcome call clients'){
      setState(() {
        target = true;
        label ='Put an decreased target';
      });
    }
    else if(widget.subtask =='Work with the Agents with low welcome calls to improve'){
      setState(() {
        target = true;
        label ='Put an increased target';
      });
    }
    else if( widget.subtask =='Assist a team member to improve the completion rate'){
      setState(() {
        target = true;
        label ='Put an increased target';
      });
    }

    return

      Scaffold(
        appBar: AppBar(
          title: Text("Action Plan"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child:ListView.builder(
                  itemCount: widget.customers!.length,
                  itemBuilder: (context, index) {
                    String customer = widget.customers![index];
                    if (!_actions.containsKey(customer)) {
                      _actions[customer] = {'action': '', 'priority': _priorities[0]};
                    }
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer: $customer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter action plan',
                                labelText: 'Action Plan',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _actions[customer]!['action'] = value;
                                });
                              },
                              maxLines: 3,
                            ),
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: 'Enter Target',
                                labelText: 'Target',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _actions[customer]!['target'] = value!;
                                });
                              },
                            ),

                            SizedBox(height: 8),
                            /*AppDropDown(
                              disable: false,
                                label: label,
                                items: data,
                                hint: label,
                                onChanged: (value){
                                  setState(() {
                                    _actions[customer]!['target'] = value!;
                                  });
                                }),*/
                            Text('Priority'),
                            DropdownButtonFormField<String>(
                              value: _actions[customer]!['priority'],
                              items: _priorities.map((priority) {
                                return DropdownMenuItem<String>(
                                  value: priority,
                                  child: Text(priority),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _actions[customer]!['priority'] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewScreen(
                              region: widget.region,
                              area: widget.Area,
                              task: widget.task,
                              subTask: widget.subtask,
                              customers:widget.customers,
                              actions: _actions!,)));
                    print(_actions);
                  },
                  child: Text("Next"))
            ],
          ),
        ),
      );
  }
}

class PreviewScreen extends StatefulWidget {
  final String area;
  final String region;
  final String task;
  final String subTask;
  final List? customers;
  final Map<String, Map<String, String>> actions;

  const PreviewScreen({
    required this.region,
    required this.area,
    required this.task,
    required this.subTask,
    required this.customers,
    required this.actions,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void _save() async{

    CollectionReference task = firestore.collection("task");
    var currentUser = FirebaseAuth.instance.currentUser;
    print(widget.actions);
    print(widget.customers);
    var result = await task.add({
      "task_title": widget.task,
      "User UID": currentUser?.uid,
      "sub_task": widget.subTask,
      "task_region": widget.region,
      "task_area": widget.area,
      "timestamp": DateTime.now(),
      "is_approved": "Pending",
      "submited_by":currentUser?.displayName ,
    });

    Map data = {
      'task_title': widget.task,
      'sub_task': widget.subTask,
      'task_region': widget.region,
      'task_area':widget.area,
      "task_start_date": "2023-05-05",
      "timestamp": 1683282979,
      "task_end_date": "2023-05-10",
      "submited_by":currentUser?.displayName,
      'is_approved': 'No'
    };
    var body = json.encode(data);
    var url = Uri.parse('https://f2e3-102-89-32-23.ngrok-free.app/api/create');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    var result_task = jsonDecode(response.body);
    subCollection(result.id,result_task["id"]);
  }
  void subCollection(id,task) async{
    CollectionReference task = firestore.collection("task");
    widget.customers!.forEach((customer) async {
      List<String> items = customer.split("-");
      String? perc = items[1].substring(0, items[1].length - 1);
      double total = double.parse(widget.actions[customer]!['target']!)+double.parse(perc!);
      task.doc(id).collection("action").add({
        "Customer":items[0],
        "Current":items[1],
        "priority":widget.actions[customer]?['priority'],
        "Action plan":widget.actions[customer]?['action'],
        "Target":widget.actions[customer]?['target'],
        "Goal":total,
      }

      );
      Map data =  {
        "task": items[0],
        "account_number":items[0],
        "goals": total,
        "task_description": widget.actions[customer]?['action'],
        "priority": widget.actions[customer]?['priority'],
        "task_status": "Pending"
      };
      var body = json.encode(data);
      var url = Uri.parse('https://f2e3-102-89-32-23.ngrok-free.app/api/taskgoals/create');
      http.Response response = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
      });
      print(response.body);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Task(),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Region: ${widget.region}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Area: ${widget.area}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Task: ${widget.task}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Sub Task: ${widget.subTask}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Task Action:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.customers!.map((customer) {
                Map<String, String>? action1 = widget.actions[customer];
                List<String> items = customer.split("-");
                //String? perc = items[1].substring(0, items[1].length - 1);
                //double total = double.parse(action1!['target']!)+double.parse(perc!);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: {items[0]}'),
                    SizedBox(height: 8),
                    Text("Priority: {action1!['priority']}"),
                    Text("Action Plan: {action1!['action']}"),
                    Text('Current: {items[1]}'),
                    Text('Target: ${action1!['target']}'),
                    Text('Goal: total'),

                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(onPressed:
                (){
              _save();
            }, child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}

*/

