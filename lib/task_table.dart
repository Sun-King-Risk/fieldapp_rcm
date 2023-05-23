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
  Future<int> TaskCount(id) async{
    QuerySnapshot querySnapshot =
        await firestore.collection("task").doc(id).collection('action').get();
    setState(() {
      _data = querySnapshot.docs;

    });
    return querySnapshot.docs.length;
  }
  Future<void> _getAction(id,subtask) async {
    QuerySnapshot querySnapshot =
    await firestore.collection("task").doc(id).collection('action').get();
    setState(() {
      _action = querySnapshot.docs;

    });
    _TaskList(id, subtask);
  }
  void _TaskList(id,subtask){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Task Details'),
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
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      DocumentSnapshot _dataaction = _action[index];
                      double? percentvalue = double.parse(_dataaction["Current"].substring(0, _dataaction["Current"].length - 1));
                      double perc = percentvalue/_dataaction["Goal"];
                      return  GestureDetector(
                        onTap: () {
                          if(widget.title == "Portfolio Quality")
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PortfolioUpdate(
                                  task: id,
                                  id: _dataaction.id,
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
                                    id: _dataaction.id,
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
                                    id: _dataaction.id,
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
                                    id: _dataaction.id,
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
                                    id: _dataaction.id,
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
                                        "Name: ${_dataaction["Customer"]}",
                                        style: TextStyle(
                                            fontSize: 18,
                                          decoration: TextDecoration.lineThrough,
                                        ),

                                      ):Text(
                                        "Name: ${_dataaction["Customer"]}",
                                        style: TextStyle(
                                            fontSize: 18),

                                      ),
                                      Text(
                                        "Current: ${_dataaction["Current"]}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Goal: ${_dataaction["Goal"]}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 5),

                                      LinearPercentIndicator(

                                        animation: true,
                                        animationDuration: 1000,
                                        lineHeight: 15.0,
                                        percent:perc,
                                        progressColor: Colors.green,
                                        center: Text('${(perc*100).toStringAsFixed(0)}%'),
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


  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Collection Drive", "request": "New Request","priority":"High"},
    {"id": 2, "name": "Team Management", "request": "pending Approval","priority":"Normal"},
    {"id": 3, "name": "Customer Management", "request": "New Request","priority":"Normal"},
    {"id": 4, "name": "Pilot Management", "request": "Rejected","priority":"Low"},
    {"id": 5, "name": "Process Management", "request": "New Request","priority":"Low"},
    {"id": 6, "name": "Customer Management", "request": "Pending","priority":"High"},
    {"id": 7, "name": "Process Management", "request": "Rejected","priority":"Normal"},
    {"id": 8, "name": "Portfolio Quality", "request": "Rejected","priority":"High"},
    {"id": 9, "name": "Team Management","request": "Pending Approval","priority":"High"},
    {"id": 10, "name": "Pilot Management", "request": "Rejected ","priority":"Normal"},
    {"id": 10, "name": "Collection Drive", "request": "Rejected ","priority":"Normal"},
  ];
  List<Map<String, dynamic>> _foundUsers = [];
  void _searchFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  void _statusFilter(String _status) {
    List<Map<String, dynamic>> results = [];
    switch(_status) {

      case "high": {results = _allUsers
          .where((user) =>
          user["priority"].toLowerCase().contains(_status.toLowerCase())).where((user) =>  user["name"].toLowerCase().contains(widget.title.toLowerCase()))
          .toList();}
      break;

      case "normal": {  results = _allUsers
          .where((user) =>
          user["priority"].toLowerCase().contains(_status.toLowerCase())).where((user) =>  user["name"].toLowerCase().contains(widget.title.toLowerCase()))
          .toList(); }
      break;

      case "low": { results = _allUsers
          .where((user) =>
          user["priority"].toLowerCase().contains(_status.toLowerCase())).where((user) =>  user["name"].toLowerCase().contains(widget.title.toLowerCase()))
          .toList();}
      break;
      case "All": { results = _allUsers
          .where((user) =>  user["name"].toLowerCase().contains(widget.title.toLowerCase()))
          .toList();; }
    }


    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  List data =[];
  var _key=GlobalKey();

  Future<String> getData() async {
    const apiUrl = 'https://sun-kingfieldapp.herokuapp.com/api/tasks';
    final response = await http.get(Uri.parse(apiUrl,),headers:{
      "Content-Type": "application/json",});

    this.setState(() {
      data = json.decode(response.body);
    });


    return "Success!";
  }
  @override
  void initState(){
    this.getData();
    this._statusFilter("All");
    this._searchFilter(widget.title);
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
                    StreamBuilder(
                      stream: TaskData().CountPriority(widget.title,'high').asStream(),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" High",style: TextStyle(color: Colors.green));
                      },
                    ),
                    StreamBuilder(
                      stream: TaskData().CountPriority(widget.title,'normal').asStream(),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Normal",style: TextStyle(color: Colors.orange));
                      },
                    ),
                    StreamBuilder(
                      stream: TaskData().CountPriority(widget.title,'low').asStream(),
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

          StreamBuilder<QuerySnapshot>(
              stream:TaskData().getData(widget.title,'approved').asStream(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          return Expanded(
              child:snapshot.hasData
                  ? ListView.separated(
                  itemCount: snapshot.data!.size,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  var tasklist = TaskCount(data.id);
                  return
                    GestureDetector(
                      onTap: () {
                        _getAction(data.id,data['sub_task']);
                        //_TaskList(data.id,data['sub_task']);
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
                                      "Task: ${data['sub_task']}",
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
                                              "${data['task_area']}",
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
                                              "20/4/2023",
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
                separatorBuilder: (BuildContext context, int index) { return  Divider();}):const Text(
                'No results found',
                style: TextStyle(fontSize: 15),
              ));;
        }else if(snapshot.hasError){
          return Expanded(child:Text('Error Loding data'));
        }else{
          return Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text('Loading...'),
            ],
          );
        }
    }
          )
        ],
      ),
      /*SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return TaskDetail(task_title: data[index]['task_title'].toString(),
                  priority: data[index]['priority'].toString(),
                  ahq_name: data[index]['task_area'].toString(),
                  date: data[index]['task_start_date'].toString(),
                  task: data[index]['id'].toString(),
                  status: data[index]['task_status'].toString(),
                  sub_task: data[index]['sub_task'].toString(),
                  description: data[index]['task_description'].toString(),
                  task_with: data[index]['task_with'].toString(),
                  region: data[index]['task_region'].toString(),
                  color: Colors.red,
                );
              })*/
    );
  }


}

class TaskDetail extends StatelessWidget {
  final String task_title;
  final String region;
  final String sub_task;
  final String priority;
  final String ahq_name;
  final String description;
  final String date;
  final String task;
  final String status;
  final String task_with;
  final Color color;
  const TaskDetail({Key? key,
    required this.task_title,
    required this.region,
    required this.task_with,
    required this.sub_task,
    required this.description,
    required this.priority,
    required this.ahq_name,
    required this.date,
    required this.task,
    required this.status,
    required this.color,


  });
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      ),
      elevation: 3,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            //task label
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Task Name:", style:TextStyle(fontWeight: FontWeight.bold,fontSize:12),),
                  Text("Sub Task:", style:TextStyle(fontWeight: FontWeight.bold,fontSize:12),),
                  Text("Task description:", style:TextStyle(fontWeight: FontWeight.bold,fontSize:12),),
                  Text("Task task with:", style:TextStyle(fontWeight: FontWeight.bold,fontSize:12),),
                  Text("Task Priority:", style:TextStyle(fontWeight: FontWeight.bold,fontSize:12),)
                ],
              ),

            ),
            SizedBox(width: 10,),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task_title, style:TextStyle(fontSize:13),),
                  Text(sub_task,style:TextStyle(fontSize:13)),
                  Text(description,style:TextStyle(fontSize:13)),
                  Text(task_with,style:TextStyle(fontSize:13)),
                  Text(priority,style:TextStyle(fontSize:13)),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
/*Column(
children: [
Center(child: Text(task_title,
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
Row(
children: [
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 15),
Text(sub_task, style: TextStyle(fontSize: 15,)),
],
),
Row(
children: [
Text("Task Description:",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 15),
Flexible
(child: new Text(description,
style: TextStyle(
color: Colors.black,
fontSize: 15.0,),
overflow: TextOverflow.clip,),)
],
),
Row(
children: [
Text("Task With:",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 15),
Text(task_with, style: TextStyle(fontSize: 15,)),
],
),
Row(
children: [
Text("Region:",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 15),
Text(region, style: TextStyle(fontSize: 15,)),
],
),
Row(
children: [
Text("Area:",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 15),
Text(ahq_name, style: TextStyle(fontSize: 15,)),
],
),
Row(
children: [
Text("Priority:",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 5),
Text(priority, style: TextStyle(fontSize: 15,)),
SizedBox(width: 20),
Text("Status:",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
SizedBox(width: 5),
Text(status, style: TextStyle(fontSize: 15,)),
],
),
Row(
children: [
Text("Date start:",
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
SizedBox(width: 5),
Text(date, style: TextStyle(fontSize: 15,)),
SizedBox(width: 20),
Text("Date end:",
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
SizedBox(width: 5),
Text(date, style: TextStyle(fontSize: 15,)),
],
),
ElevatedButton(
style: ElevatedButton.styleFrom(
minimumSize: Size.fromHeight(
40), // fromHeight use double.infinity as width and 40 is the height
),
onPressed: () {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text(sub_task.toString()),
content: Text(sub_task.toString()+" Saved successfully"),
);
}
);
},
child: Text("Update Task")),
SizedBox(height: 5),
],
)*/