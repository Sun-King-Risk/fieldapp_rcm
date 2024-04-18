
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fieldapp_rcm/update/collection_update.dart';
import 'package:fieldapp_rcm/update/customer_update.dart';
import 'package:fieldapp_rcm/update/pilot_update.dart';
import 'package:fieldapp_rcm/update/portfolio_update.dart';
import 'package:fieldapp_rcm/update/team_update.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'models/db.dart';
import 'models/task_detail.dart';

class MyTaskView extends StatefulWidget {
  const MyTaskView({Key? key, required this.endPoint,required this.title,required this.name}) : super(key: key);
  final title;
  final endPoint;
  final name;
  @override
  MyTaskViewState createState() => MyTaskViewState();
}
class MyTaskViewState extends State<MyTaskView> {
  List<DocumentSnapshot> _data = [];
  final List<DocumentSnapshot> _action = [];
  bool decoration = false;
  var complete = 0;
  var total = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List? data = [];
  void fetchData() async {
    var url = Uri.parse('${AppUrl.baseUrl}/tasks');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body);
        data = jsonData.where((task)=>
        task['is_approved'] == 'Pending' && task['submited_by'] == widget.name).toList();
      });
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
  }
  Future<int> TaskCount(id) async{
    QuerySnapshot querySnapshot =
    await firestore.collection("task").doc(id).collection('action').get();
    setState(() {
      _data = querySnapshot.docs;

    });
    return querySnapshot.docs.length;
  }
  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('${AppUrl.baseUrl}/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        taskgoal = filteredTasks;
        print(taskgoal);
      });

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }


    _TaskList(id, subtask);
  }
  void _TaskList(id,subtask){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Task Details'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) => _searchFilter(value),
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: taskgoal!.length,
                    itemBuilder: (context, index) {
                      var taskdetail = taskgoal![index];
                      /*double? percentvalue = double.parse(_dataaction["Current"].substring(0, _dataaction["Current"].length - 1));
                      double perc = percentvalue/_dataaction["Goal"];*/
                      return  GestureDetector(
                        onTap: () {
                          if(widget.title == "Portfolio Quality") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PortfolioUpdate(
                                    taskGoalId: taskdetail["id"],
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          }
                          if(widget.title == "Collection Drive") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CollectionUpdate(
                                    taskGoalId: taskdetail["id"],
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          }
                          if(widget.title == "Pilot/Process Management") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PilotUpdate(
                                    taskGoalId: taskdetail["id"],
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          }
                          if(widget.title == "Customer Management") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerUpdate(
                                    taskGoalId: taskdetail["id"],
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          }
                          if(widget.title == "Team Management") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamUpdate(
                                    taskGoalId: taskdetail["id"],
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          }
                        },
                        child: Row(
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
                                      decoration?
                                      Text(
                                        "Dennis: ${taskdetail["account_number"]} ${taskdetail["id"]}  $id",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.lineThrough,
                                        ),

                                      ):Text(
                                        "Name: ${taskdetail["account_number"]} ${taskdetail["id"]}  $id",
                                        style: const TextStyle(
                                            fontSize: 18),

                                      ),
                                      Text(
                                        "Current: ${taskdetail["previous_goal"]}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Goal: ${taskdetail["goals"]}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 5),

                                      LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        lineHeight: 15.0,
                                        percent:double.parse(taskdetail["previous_goal"] ?? "0")/
                                            double.parse(taskdetail["goals"] ?? "0"),
                                        progressColor: Colors.green,
                                        center: Text('${((double.parse(taskdetail["previous_goal"] ?? "0")/
                                            double.parse(taskdetail["goals"] ?? "0"))*100).toStringAsFixed(0)}%'),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }



  List<Map<String, dynamic>> _foundUsers = [];
  void _searchFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];


    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  void _statusFilter(String status) {
    List<Map<String, dynamic>> results = [];


    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  List data2 =[];
  final _key=GlobalKey();

  Future<String> getData(title) async {
    const apiUrl = '${AppUrl.baseUrl}/tasks';
    final response = await http.get(Uri.parse(apiUrl,),headers:{
      "Content-Type": "application/json",});
    final List<dynamic> jsonData = json.decode(response.body);
    final List<dynamic> filteredTasks = jsonData.where((task)=>
    task['is_approved'] == 'Approved' &&
        task['submited_by'] == widget.name &&
        task['task_title'] == title && task['task_status'] == 'Pending').toList();

    setState(() {
      data = filteredTasks;
    });


    return "Success!";
  }
  @override
  void initState(){
    //complete = TaskData().countByStatus(widget.title, "Complete", widget.name) as int;
    //total = TaskData().countTask(widget.title, widget.name) as int;
    getData(widget.title);
    _statusFilter("All");
    _searchFilter(widget.title);
  }


  final TaskData taskData = TaskData();
  @override
  Widget build(BuildContext context) {
    var key=GlobalKey();
    Color taskcolor;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Column(
        children: [
          Container(
            height: 200,

            padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
            margin: const EdgeInsets.only(left: 10,right: 10,bottom: 0,top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Task Summary",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 15.0,
                  percent:2/2,
                  progressColor: Colors.green,
                  center: const Text("${(2/2)*100}% completed"),
                ),

                const SizedBox(height: 10,),
                const SizedBox(
                  height: 5,
                ),
                const Text("Task Status",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder(
                      stream: taskData.countByStatus(widget.title,'Complete',widget.name).asStream(),
                      builder: (context, snapshot){
                        return  Text("${snapshot.data} Complete",style: const TextStyle(color: Colors.orange));
                      },
                    ),
                    StreamBuilder(
                      stream: taskData.countByStatus(widget.title,'Pending',widget.name).asStream(),
                      builder: (context, snapshot){
                        return  Text("${snapshot.data} Pending",style: const TextStyle(color: Colors.red));
                      },
                    ),
                    StreamBuilder(
                      stream: taskData.countTask(widget.title,widget.name).asStream(),
                      builder: (context, snapshot){
                        return  Text("${snapshot.data} Total",style: const TextStyle(color: Colors.green));
                      },
                    ),



                  ],
                ),
                const SizedBox(height: 10,),
                const Text("Priority",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                const SizedBox(height:10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder(
                      future: taskData.countByPriority(widget.title,'high',widget.name),
                      builder: (context, snapshot){
                        return  Text("${snapshot.data} High",style: const TextStyle(color: Colors.green));
                      },
                    ),
                    FutureBuilder(
                      future: taskData.countByPriority(widget.title,'normal',widget.name),
                      builder: (context, snapshot){
                        return  Text("${snapshot.data} Normal",style: const TextStyle(color: Colors.orange));
                      },
                    ),
                    FutureBuilder(
                      future: taskData.countByPriority(widget.title,'low',widget.name),
                      builder: (context, snapshot){
                        return  Text("${snapshot.data} Low",style: const TextStyle(color: Colors.orange));
                      },
                    ),


                  ],
                ),

              ],
            ),
          ),
          const SizedBox(height: 20,),
          Container(
              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton(
                    onSelected:(reslust) =>_statusFilter(reslust),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "All",
                          child: Text("All")
                      ),
                      const PopupMenuItem(
                          value: "high",
                          child: Text("High")
                      ),
                      const PopupMenuItem(
                          value: "normal",
                          child: Text("normal")
                      ),
                      const PopupMenuItem(
                          value: "low",
                          child: Text("Low")
                      ),
                    ],
                    icon: const Icon(
                        Icons.filter_list_alt,color: Colors.yellow
                    ),

                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => _searchFilter(value),
                      decoration: const InputDecoration(
                          labelText: 'Search', suffixIcon: Icon(Icons.search)),
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.separated(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var task = data![index];
                    return
                      GestureDetector(
                        onTap: () {
                          _getAction(task["id"],task['sub_task']);
                          //_TaskList(task['id'],task['sub_task']);

                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding:const EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Task: ${task['sub_task']}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on),
                                              Text(
                                                "${task['task_area']}",
                                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const Row(
                                            children: [
                                              Icon(Icons.task_outlined),
                                              Text(
                                                "2",
                                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time),
                                              Text(
                                                "${task['task_end_date']}",
                                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          )
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                  },
                  separatorBuilder: (BuildContext context, int index) { return  const Divider();}))
        ],
      ),
    );
  }


}