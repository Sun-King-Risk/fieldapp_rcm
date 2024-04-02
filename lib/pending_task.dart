// main.dart
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PendingTask extends StatefulWidget {
  const PendingTask({Key? key}) : super(key: key);

  @override
  PendingTaskState createState() => PendingTaskState();
}
class PendingTaskState extends State<PendingTask> {
   bool isDescending = false;
_taskStatus(docid)async{
  bool approved = false;
  showDialog(
    context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
        content: const Text('Do you approve or reject this action?'),
                actions: <Widget>[
                  Column(
                    children: [
                      Text(docid.toString()),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          TextButton(
                            child: const Text('Approve'),
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
                              var resultTask = jsonDecode(response.body);

                              print(resultTask);

                            },
                          ),
                          TextButton(
                            child: const Text('Reject'),
                            onPressed: () async{
                              Map data = {
                                'is_approved': 'Rejected'
                              };
                              var body = json.encode(data);
                              var url = Uri.parse('https://www.sun-kingfieldapp.com/api/task/update/$docid/');
                              http.Response response = await http.put(url, body: body, headers: {
                                "Content-Type": "application/json",
                              });
                              var resultTask = jsonDecode(response.body);

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
  List<Map<String, dynamic>> _filtertask = [];
List? data = [];
  List? singledata = [];
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    getUserAttributes();
    print("nee $name");


  }


  List<String> attributeList = [];
  String name ="";
  String region = '';
   String userRegion = '';
  String country ='';
   String zone ='';
  String role = '';
   void getUserAttributes() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
       setState(() {
       });
       name = prefs.getString("name")!;
     region =  prefs.getString("region")!;
       country =  prefs.getString("country")!;
       role = prefs.getString("role")!;
       zone =  prefs.getString("zone")!;
       fetchData();
       if (kDebugMode) {
         print("object kd");
       }
       // Process the user attributes


   }
  void fetchData() async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    var response = await http.get(url);
    print("Sdsf $name");
    print(response.statusCode);
    if (response.statusCode == 200) {

        var jsonData = jsonDecode(response.body);
        if(role == 'Regional Collections Manager'){
            data = jsonData.where((task)=>
            task['is_approved'] == 'Pending'
                && task['submited_role'] == 'ACE'
                && task['country'] == country
                && task['task_region'] == region
            ).toList();
        }else if(role == 'Zonal Credit Manager'){
          setState(() {
            data = jsonData.where((task)=>
            task['is_approved'] == 'Pending'
                && task['submited_role'] == 'Regional Collections Manager'
                && task['task_country'] == country
                && task['task_region'] == region
            ).toList();
          });


        }else if(role == 'Country Credit Manager'){
            data = jsonData.where((task)=>
            task['is_approved'] == 'Pending'
                && task['submited_role'] == 'ACE'
                && task['country'] == country
                && task['task_region'] == region
            ).toList();

        }

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
      _filtertask = results;
    });
  }
  void _statusFilter(String status) {
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
                    const PopupMenuItem(
                        value: "All",
                        child: Text("All")
                    ),
                    const PopupMenuItem(
                        value: "Complete",
                        child: Text("Complete")
                    ),
                    const PopupMenuItem(
                        value: "Pending",
                        child: Text("Pending")
                    ),
                    const PopupMenuItem(
                        value: "Over due",
                        child: Text("Over Due")
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
    )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
    //Text(data.toString()),
    Expanded(
      child: data!.isEmpty?Center(child: Text("No new request task $data"),):ListView.separated(
        itemCount: data!.length, // Replace with your actual item count
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.grey,
            height: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          var task = data![index];
          print(data);
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
                const SizedBox(
                  width: 5,
                ),
              Flexible(
                child: SizedBox(
                  width: 350,
                  height: 100,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding:  const EdgeInsets.fromLTRB(20.0, 10, 0, 0),
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
  var task_id;
  var description;
  final List<String> _priorities = ['High', 'Medium', 'Low'];
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
        task_id = filteredTasks[0]['id'];
        taskgoal = filteredTasks;
      });
      safePrint(data);
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
  }
  Future<void> TaskUpdate(id)async {
    var task = Uri.parse('https://www.sun-kingfieldapp.com/api/$id/taskgoals');
    var goalUrl = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    Map data = {
      "goals": goal ?? taskgoal![0]['goals'],
      "account_number":taskgoal![0]['account_number'],
      "task_description": description ?? taskgoal![0]['task_description'],
      "priority": priority ?? taskgoal![0]['priority'],
      "task":taskgoal![0]['task']
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals/$task_id/update/');
    http.Response response = await http.put(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    Navigator.pop(context);
    var resultTask = jsonDecode(response.body);
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
                  Text(taskgoal.toString()),
                  TextField(
                      decoration: const InputDecoration(
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: 'Enter Target',
                      labelText: 'New Target',
                    ),
                    onChanged: (value) {
                      setState(() {
                        goal =  value;
                      });
                    },
                  ),
                  const SizedBox(height: 8,),
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
                  Center(child: ElevatedButton(onPressed: () {
                    TaskUpdate(widget.id);



                  }, child: const Text('Update')))
                ],
              ),
            )
          ],
        ),
      );
        });
  }
  _taskStatus(docid)async{
    bool approved = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: AlertDialog(
                  content: const Text('Do you approve or reject this task?'),
                  actions: <Widget>[
                    Column(
                      children: [
                        Text(docid.toString()),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            TextButton(
                              child: const Text('Approve'),
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
                                var resultTask = jsonDecode(response.body);

                                print(resultTask);
                                Navigator.pop(context);
                                Navigator.of(context).pop();

                              },
                            ),
                            TextButton(
                              child: const Text('Reject'),
                              onPressed: () async{
                                Map data = {
                                  'is_approved': 'Rejected'
                                };
                                var body = json.encode(data);
                                var url = Uri.parse('https://www.sun-kingfieldapp.com/api/task/update/$docid/');
                                http.Response response = await http.put(url, body: body, headers: {
                                  "Content-Type": "application/json",
                                });
                                var resultTask = jsonDecode(response.body);
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
        padding: const EdgeInsets.all(8),
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
                            style: const TextStyle(
                              fontSize: 15,
                            ),

                          ),
                          Text(
                            "Task: ${data['sub_task']}",
                            style: const TextStyle(
                              fontSize: 15,
                            ),

                          ),
                          Text(
                            "Region:${data['task_region']} Area: ${data['task_area']}",
                            style: const TextStyle(
                              fontSize: 15,
                            ),

                          ),
                          Text(
                            "Start:${data['task_start_date']}  End:${data['task_end_date']} ",
                            style: const TextStyle(
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
              physics: const NeverScrollableScrollPhysics(),
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
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "Description: ${task['task_description']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "Priority: ${task['priority']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "current: ${task['previous_goal']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),

                                  ),
                                  Text(
                                    "Goal: ${task['goals']}",
                                    style: const TextStyle(
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
                }, child: const Text("Approve"))

          ],
        ),
      ),),
    );
  }
  
}
