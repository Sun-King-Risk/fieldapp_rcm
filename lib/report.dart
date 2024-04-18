// main.dart
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/db.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  ReportState createState() => ReportState();
}
class ReportState extends State<Report> {
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
                                var url = Uri.parse('${AppUrl.baseUrl}/task/update/$docid/');
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
                                var url = Uri.parse('${AppUrl.baseUrl}/task/update/$docid/');
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
  List<Map<String, dynamic>> _foundUsers = [];
  List? data = [];
  List? singledata = [];
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    fetchData();

  }
  void fetchReport() async{
    var url =  Uri.parse('${AppUrl.baseUrl}/reports/');


  }

  void singleTask(){
    var url = Uri.parse('${AppUrl.baseUrl}/tasks');

  }

  void fetchData() async {
    var url = Uri.parse('${AppUrl.baseUrl}/reports/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
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
        Expanded(
          child: ListView.separated(
            itemCount: data!.length, // Replace with your actual item count
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
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
                          builder: (context) => SingleReport(
                              id:task["id"],
                            sub_task: task["report_title"],
                          ),
                        ));

                  },
                  key: ValueKey(task),
                  child: Row(
                      children: [

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
                                      Text("Report : ${task!['report_title']}"),
                                      Text("Sub task : ${task!['sub_task']}"),
                                      Text("submited_by : ${task!['submited_by']}"),
                                      Text("submited_by : ${task!['id']}")

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

class SingleReport extends StatefulWidget{

  final id;
  final sub_task;
  @override
  const SingleReport({Key? key,required this.id,required this.sub_task}) : super(key: key);

  @override
  SingleReportState createState() => SingleReportState();

}
class SingleReportState extends State<SingleReport> {
  Map<String, dynamic>  data = {};
  String code = '';
  Future fetchData() async {
    var url = Uri.parse('${AppUrl.baseUrl}/report/${widget.id}');
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
  final List<String> _priorities = ['High', 'Medium', 'Low'];
  Future fetchGoal(id) async {
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
                      Center(child: ElevatedButton(onPressed: () async {
                        Map data = {
                          "goals": goal,
                          "task_description": description,
                          "priority": priority,
                        };
                        var body = json.encode(data);
                        var url = Uri.parse('${AppUrl.baseUrl}/taskgoals/$id/update/');
                        http.Response response = await http.post(url, body: body, headers: {
                          "Content-Type": "application/json",
                        });
                        var resultTask = jsonDecode(response.body);


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
                                var url = Uri.parse('${AppUrl.baseUrl}/task/update/$docid/');
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
                                var url = Uri.parse('${AppUrl.baseUrl}/task/update/$docid/');
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
                              "Reprot Title: ${data['report_title']}",
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
                              "Region:${data['report_region']} Area: ${data['report_area']}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),

                            ),
                            Text(
                              "Report Detail :${data['report_details']}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),

                            ),
                            Text(
                              "Report Status :${data['report_status']}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),

                            ),
                            Text(
                              "Report Priority :${data['report_priority']}",
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
              if(widget.sub_task=='Visiting unreachable welcome call clients' )
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
                                "Costomer Found: ${data['report_customer_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "is fraud case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                                Text(
                                  "Amount collected: ${data['report_amount_collected']}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),

                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if(widget.sub_task=='Work with the Agents with low welcome calls to improve' || widget.sub_task=='Increase the Kazi Visit Percentage'
              || widget.sub_task=='Field Visits with low-performing Agents in Collection Score'||
                  widget.sub_task=='Work with restricted Agents')
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
                                "is agent: ${data['report_agent_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "issue found: ${data['report_agent_found_yes_issues']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Angaza ID:${data[' report_agent_angaza_Id']} Challenge: ${data['report_agent_found_no_chs']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Change a red zone CSAT area to orange' )
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
                                "Issue: ${data['report_issue_to_be_reolved_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Resolution: ${data['report_resolution_to_be_reolved_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Attend to Fraud Cases' )
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
                                "Customer Visited: ${data['report_customer_count_visited']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Coustomer found: ${data['report_customer_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Fraud Case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Account Number: ${data['report_customer_account_number']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),

                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Visit at-risk accounts' )
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
                                "Customer Visited: ${data['report_customer_count_visited']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Coustomer found: ${data['report_customer_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Fraud Case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Account Number: ${data['report_customer_account_number']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),

                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Visits FPD SPDs' )
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
                                "Customer Visited: ${data['report_customer_count_visited']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Coustomer found: ${data['report_customer_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Fraud Case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Account Number: ${data['report_customer_account_number']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),

                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Visiting of issues raised' )
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
                                "Customer Visited: ${data['report_customer_count_visited']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Coustomer found: ${data['report_customer_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Fraud Case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Account Number: ${data['report_customer_account_number']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),

                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Repossession of customers needing repossession' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Look at the number of replacements pending at the shops' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Look at the number of repossession pending at the shops' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Conduct the process audit'||widget.sub_task=='Conduct a pilot audit' )
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
                                "Report Audity: ${data['report_audit_report']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "takeaways: ${data['report_key_takeaways']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "recommendation: ${data['report_recommendation']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Account Number: ${data['report_customer_account_number']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),

                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Testing the GPS accuracy of units submitted' )
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
                                "Coordinate found: ${data['report_coordinate_lamp_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Reason for moving: ${data['report_coordinate_lamp_found_yes_no_reasons_for_moving']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "takeaways: ${data['report_key_takeaways']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "recommendation: ${data['report_recommendation']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),
                              Text(
                                "Account Number: ${data['report_customer_account_number']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),


                              ),

                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Reselling of repossessed units' )
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
                                "Previous Angaza ID: ${data['report_previous_customer_angaza_ID']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "New Custoemr name: ${data['report_new_customer_customer_name']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Unit is Complete: ${data['report_repo_unit_is_complete']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "2 weeks payment: ${data[' report_repo_customer_2_weeks_pay']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Aware condition: ${data['report_repo_customer_aware_cond']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Agent: ${data[' report_repo_reselling_agent']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Repossessing qualified units for Repo and Resale' )
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
                                "Customer Found: ${data['report_customer_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Is Fraud Case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if(widget.sub_task =='Repossession of accounts above 180' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Visits Tampering Home 400' )
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
                                "Agent Found: ${data['report_agent_found_yes_no']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Fraud case: ${data['report_customer_found_fraud_case']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if(widget.sub_task=='Work with restricted Agents' )
              if(widget.sub_task=='Calling of special book' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Sending SMS to clients' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Table Meeting/ Collection Sensitization Training' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Assist a team member to improve the completion rate' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Raise a reminder to a team member' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Raise a new task to a team member' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
              if(widget.sub_task=='Inform the team member of your next visit to his area, and planning needed' )
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
                                "Reprot Title: ${data['report_title']}",
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
                                "Region:${data['report_region']} Area: ${data['report_area']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),

                              ),
                              Text(
                                "Report Detail :${data['report_details']}",
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
