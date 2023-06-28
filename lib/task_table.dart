import 'dart:convert';
import 'package:fieldapp_rcm/update/collection_update.dart';
import 'package:fieldapp_rcm/update/customer_update.dart';
import 'package:fieldapp_rcm/update/pilot_update.dart';
import 'package:fieldapp_rcm/update/portfolio_update.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:fieldapp_rcm/update/team_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

class MyTaskView extends StatefulWidget {
  MyTaskView({Key? key, required this.endPoint,required this.title}) : super(key: key);
  final title;
  final endPoint;
  @override
  MyTaskViewState createState() => MyTaskViewState();
}
class MyTaskViewState extends State<MyTaskView> {
  List<DocumentSnapshot> _data = [];
  List<DocumentSnapshot> _action = [];
  bool decoration = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
            title: Text('Task Details $id'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) => _searchFilter(value),
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
                Container(
                  height: 400,
                  child: ListView.builder(
                    itemCount: taskgoal!.length,
                    itemBuilder: (context, index) {
                      var taskdetail = taskgoal![index];
                      /*double? percentvalue = double.parse(_dataaction["Current"].substring(0, _dataaction["Current"].length - 1));
                      double perc = percentvalue/_dataaction["Goal"];*/
                      return  GestureDetector(
                        onTap: () {
                          if(widget.title == "Portfolio Quality")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PortfolioUpdate(
                                    task: id,
                                    id: taskdetail["id"],
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          if(widget.title == "Collection Drive")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CollectionUpdate(
                                    task: id,
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          if(widget.title == "Pilot/Process Management")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PilotUpdate(
                                    task: id,
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          if(widget.title == "Customer Management")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerUpdate(
                                    task: id,
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
                          if(widget.title == "Team Management")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamUpdate(
                                    task: id,
                                    id: id,
                                    title: widget.title,
                                    subtask: subtask,

                                  ),
                                ));
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
                                        "Name: ${taskdetail["account_number"]}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.lineThrough,
                                        ),

                                      ):Text(
                                        "Name: ${taskdetail["account_number"]}",
                                        style: TextStyle(
                                            fontSize: 18),

                                      ),
                                      Text(
                                        "Current: ${taskdetail["previous_goal"]}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Goal: ${taskdetail["goals"]}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 5),

                                      LinearPercentIndicator(

                                        animation: true,
                                        animationDuration: 1000,
                                        lineHeight: 15.0,
                                        percent:0.5,
                                        progressColor: Colors.green,
                                        center: Text('${(0.5*100).toStringAsFixed(0)}%'),
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
                child: Text('Close'),
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
  void _statusFilter(String _status) {
    List<Map<String, dynamic>> results = [];


    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  List data2 =[];
  var _key=GlobalKey();

  Future<String> getData(title) async {
    const apiUrl = 'https://sun-kingfieldapp.herokuapp.com/api/tasks';
    final response = await http.get(Uri.parse(apiUrl,),headers:{
      "Content-Type": "application/json",});
    final List<dynamic> jsonData = json.decode(response.body);
    final List<dynamic> filteredTasks = jsonData
        .where((task) => task['task_title'] == title)
        .where((task) => task['is_approved'] == 'Approved')
        .where((task) => task['task_status'] == 'Pending')
        .toList();

    setState(() {
      data = filteredTasks;
    });


    return "Success!";
  }
  @override
  void initState(){
    getData(widget.title);
    _statusFilter("All");
    _searchFilter(widget.title);
  }



  @override
  Widget build(BuildContext context) {
    var _key=GlobalKey();
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

            padding:EdgeInsets.only(left: 15,right: 25,bottom: 5,top: 5),
            margin: EdgeInsets.only(left: 20,right: 25,bottom: 0,top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Task Summary",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 15.0,
                  percent:2/2,
                  progressColor: Colors.green,
                  center: Text(((2/2)*100).toString()+"% completed"),
                ),

                SizedBox(height: 10,),
                SizedBox(
                  height: 5,
                ),
                Text("Task Status",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder(
                      stream: TaskData().CountByStatus(widget.title,'Complete').asStream(),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Complete",style: TextStyle(color: Colors.orange));
                      },
                    ),
                    StreamBuilder(
                      stream: TaskData().CountByStatus(widget.title,'Pending').asStream(),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Pending",style: TextStyle(color: Colors.red));
                      },
                    ),
                    StreamBuilder(
                      stream: TaskData().CountTask(widget.title).asStream(),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Total",style: TextStyle(color: Colors.green));
                      },
                    ),



                  ],
                ),
                SizedBox(height: 10,),
                Text("Priority",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                SizedBox(height:10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder(
                      future: TaskData().CountPriority(widget.title,'high'),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" High",style: TextStyle(color: Colors.green));
                      },
                    ),
                    FutureBuilder(
                      future: TaskData().CountPriority(widget.title,'normal'),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Normal",style: TextStyle(color: Colors.orange));
                      },
                    ),
                    FutureBuilder(
                      future: TaskData().CountPriority(widget.title,'low'),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Low",style: TextStyle(color: Colors.red));
                      },
                    ),


                  ],
                ),

              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
              padding:EdgeInsets.only(left: 30, right: 30, bottom: 5, top: 5),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton(
                    onSelected:(reslust) =>_statusFilter(reslust),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Text("All"),
                          value: "All"
                      ),
                      PopupMenuItem(
                          child: Text("High"),
                          value: "high"
                      ),
                      PopupMenuItem(
                          child: Text("normal"),
                          value: "normal"
                      ),
                      PopupMenuItem(
                          child: Text("Low"),
                          value: "low"
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
                          print(task["id"]);

                        },
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Task: ${task['sub_task']} ${task["id"]}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.location_on),
                                              Text(
                                                "${task['task_area']}",
                                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Row(
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
                                              Icon(Icons.access_time),
                                              Text(
                                                "${task['task_end_date']}",
                                                style: TextStyle(fontSize: 14, color: Colors.grey),
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
                  separatorBuilder: (BuildContext context, int index) { return  Divider();}))
        ],
      ),
    );
  }


}