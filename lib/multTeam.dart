import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/db.dart';
import 'multform.dart';
class TeamTaskCreate extends StatefulWidget {
  final title;
  final sub;
  const TeamTaskCreate({super.key, required this.title,required this.sub});

  @override
  _TeamTaskCreateState createState() => _TeamTaskCreateState();
}
enum TaskMode {
  Task, SubTask, Region, Area, TableTask, ActionPlan, Date, Preview ,TeamCountry,
  TeamZone,TeamRegion,TeamArea,TeamRole,

}
class _TeamTaskCreateState extends State<TeamTaskCreate> {
  DateTime selectedDate = DateTime.now();
  int currentYear = DateTime.now().year;
  String endDate =  "";
  String startDate = "";
  List? users =[];
  bool userComplete = false;
  void RoleList() async {
      switch (submited_role) {
        case "Admin":
          setState(() {

          });

          break;
        case "Fraud Manager":
          setState(() {

          });

          break;
        case "Credit Analyst":
        case "CCA":

          setState(() {
            Role = [
              'ACE',
              'RCM'
            ];
          });

          break;
        case "CCM":

        setState(() {
          Role = [
            'ACE',
            'Credit Analyst',
            'CLE',
            'Fraud Analyst'
          ];
        });
          break;

        case "CLE":
        case "RCM":
          setState(() {
           Role= [


              'CLE',

            ];
          });

        // Code to handle Admin role

          break;
        default:
      }
      print(Role);


  }
  void Users() async  {
    var connection = await Database.connect();
    try {
      var results = await connection.query( "SELECT first_name, last_name FROM fieldappusers_feildappuser WHERE Role = @role AND Country = @country",
        substitutionValues: {"role":"ACE","country": country},);
      print(results.map((row) => row[0]).where((role) => role != null && role.isNotEmpty).toSet().toList());
      setState(() {
        users =results.map((row) => "${row[0]} ${row[1]}").where((name) => name.isNotEmpty).toSet().toList();
        userComplete = true;
      });

    }catch(e){
      print("error");
      print(e.toString());
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(currentYear),
      lastDate: DateTime(currentYear+1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        List<String> parts = picked.toString().split(" ");
        startDate = parts[0];
      });
    }
  }
  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(currentYear),
      lastDate: DateTime(currentYear+1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        List<String> parts = picked.toString().split(" ");
        endDate = parts[0];
      });
    }
  }
  TaskMode _taskMode = TaskMode.Task;
  List<String> keys = [];
  String searchQuery = '';
  String selectedRegion = '';
  bool target =true;
  String rate = '';
  final int _currentPage = 0;
  final int _pageSize = 9;
  List getPageData() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    return taskData!.sublist(startIndex, endIndex);
  }
  Map<String, String> selectedValues = {};
  final List<String> _priorities = ['High', 'Medium', 'Low'];
  final Map<String, Map<String, String>> _actions = {};
  List<String> textFieldValues = [];
  List<String> dropdownValues = [];
  bool isLoading = true;
  bool isLoadingArea = true;
  List<String> attributeList = [];
  String name ="";
  String task_zone ="";
  String submited_role ="";
  String singleRegion = '';
  String country ='';
  String userRegion = '';
  List? data = [];
  String zone ='';
  String email = "";
  String role = '';
  String selectedArea = '';
  List? areadata = [];
  List<String> region= [];
  Future<void> Area() async {
    List<String> uniqueArea = [];
    final jsonArea = data?.where((item) => item['Region'] == selectedRegion).toList();
    for (var areaList in jsonArea!) {
      String area = areaList['Area'];
      //region?.add(region);
      uniqueArea.add(area);
    }
    setState(() {

      areadata = uniqueArea.toSet().toList();
      isLoadingArea = false;
      safePrint('File_team: $data');
    });
    //safePrint('Area: $area');
  }
  void _saveNo() async{
    Map data = {
      'task_title': widget.title,
      'sub_task': SelectedSubtask,
      'task_region': singleRegion,
      'task_area':selectedArea,
      "task_start_date": startDate,
      "timestamp": 1683282979,
      "task_end_date": endDate,
      "submited_by":name,
      'is_approved': 'Pending',
      'task_status':'Pending',
      "task_zone": task_zone,
      "submited_role": submited_role,
      "task_country": country,
    };

    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/create');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    var resultTask = jsonDecode(response.body);
    print(resultTask);
    print(resultTask["id"]);
    taskActionNo(resultTask["id"]);

  }

  void taskActionNo(id) async {
    print(_actions);
    for (final entry in _actions.entries) {
      String taskName = entry.key;

        Map data =   {
          "task": id,
          "account_number":entry.key,
          "goals": 0,
          "task_description": entry.value['action'],
          "priority": entry.value['priority'],
          "task_status": "pending",
          "previous_goal":0
        };
        var body = json.encode(data);
        var url = Uri.parse('${AppUrl.baseUrl}/taskgoal/create/');
        http.Response response = await http.post(url, body: body, headers: {
          "Content-Type": "application/json",
        });
        print(response.body);


    }

    const snackBar = SnackBar(
      content: Text('Task Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
  List<Map<String, dynamic>> selectedItems = [];
  String key= 'Agent';
  final int _sortColumnIndex = 2;
  final bool _sortAscending = true;
  List? taskData = [];
  List? Role = [];
  bool isLoadingTable = true;
  List<Map<String, dynamic>> taskDataList = [];
  Future<void> TableData() async{
    setState(() {
      taskData =  data?.where((item) => item['Region'] == singleRegion && item['Area']== selectedArea).toList();
      keys = taskData!.isNotEmpty ?taskData![0].keys.toList() : [];
      //key
      if(keys.contains('Agent')){
        key = 'Agent';
      }else if(keys.contains('Angaza ID')){
        key = 'Angaza ID';
      }else if(keys.contains('Account Number')){
        key = 'Account Number';
      }else if(keys.contains('Customer')){
        key = 'Customer';
      }else if(keys.contains('Customer Name')){
        key = 'Customer Name';
      }
      //rate
      if(keys.contains('Success Rate')){
        rate = 'Success Rate';
      }
      else if(keys.contains('%Unreachabled rate within SLA')){
        rate = '%Unreachabled rate within SLA';
      }else if(keys.contains('Collection Score')){
        rate = 'Collection Score';
      }
      isLoadingTable = false;

    });

  }
  void getUserAttributes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      userRegion =  prefs.getString("region")!;
      country =  prefs.getString("country")!;
      role = prefs.getString("role")!;
      zone =  prefs.getString("zone")!;
    });

    if (kDebugMode) {
    }
    // Process the user attributes


  }


  final int _currentStep = 0;
  final List<String>CCM = [
    "CCM 1",
    "CCM 3",
    "CCM 2",
    "CCM 4"
  ];

  final List<String> ZCM = [
    "ZCM 1",
    "ZCM 3",
    "ZCM 2",
    "ZCM 4"
  ];
  final List<String> RCM = [
    "RCM 1",
    "RCM 3",
    "RCM 2",
    "RCM 4"
  ];
  final List<String> ACE = [
    "ACE 1",
    "ACE 3",
    "ACE 2",
    "ACE 4"
  ];
  String SelectedSubtask = '';
  List<String> Taskoptions = [
    'Counrty Credit Manager',
    'Zonal Credit Manager',
    'Region Credit Manager',
    'Area Collection',
  ];
  String selectedOption = '';
@override
void initState() {
    // TODO: implement initState
    super.initState();
    getUserAttributes();
    Users();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Task'),
        ),
        body: Container(
          child: Column(
            children: [
              if(_taskMode == TaskMode.Task)
                Expanded(
                  child:
                  Role!.isEmpty?const Center(
          child: Column(
            children: [

              CircularProgressIndicator(),
              Text(' Please wait...')
            ],
          ),
        ):Column(children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: Role!.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                                title: Text(Role![index]),
                                value: Role![index],
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value.toString();
                                    print(selectedOption);
                                    Users();
                                    _taskMode = TaskMode.SubTask;

                                  });
                                }
                            );
                          }
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const MyTaskNew(

                            )),
                          );
                        }, child: const Text("Back")),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            _taskMode = TaskMode.SubTask;

                          });
                        }, child: const Text("Next"))
                      ],
                    )
                  ],),
                ),
              if(_taskMode == TaskMode.SubTask)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: users!.isEmpty&&userComplete==false?const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              Text(' Please wait...')
                            ],
                          ),
                        ): users!.isEmpty&& userComplete==true?Center(
                          child: Text("No users found with role ${Role![0]}."),
                        ):
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: users!.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                  title: Text(users![index]),
                                  value: users![index],
                                  groupValue: SelectedSubtask,
                                  onChanged: (value) {
                                    setState(() {
                                      SelectedSubtask = value.toString();
                                      print(SelectedSubtask);

                                    });
                                  }
                              );
                            }
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){

                            setState(() {
                              _taskMode = TaskMode.Task;
                              users= [];
                            });
                          }, child: const Text("Back")),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              _actions[SelectedSubtask] = {'action': '', 'priority': _priorities[0]};
                                _taskMode = TaskMode.ActionPlan;

                            });
                          }, child: const Text("Next"))
                        ],
                      )
                    ],
                  ),
                ),

              if(_taskMode == TaskMode.ActionPlan)
                Expanded(
                  child: Column(
                    children: [
                       Expanded(
                        child:

                             Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            TextField(
                                              decoration: const InputDecoration(
                                                hintText: 'Enter action plan',
                                                labelText: 'Action Plan',
                                              ),
                                              onChanged: (value) {

                                                print(value);
                                                setState(() {
                                                  _actions[SelectedSubtask]!['action'] = value;
                                                  print("_actions after update: $_actions");
                                                });
                                              },
                                              maxLines: 3,
                                            ),
                                            const SizedBox(height: 8),
                                            const SizedBox(height: 8),
                                            AppDropDown(
                                                disable: true,
                                                label: "Priority",
                                                items: _priorities,
                                                hint: "Priority",
                                                onSave: (value){
                                                  _actions[SelectedSubtask]!['priority'] = value!;
                                                },
                                                onChanged: (value){
                                                  setState(() {
                                                    _actions[SelectedSubtask]!['priority'] = value;
                                                  });
                                                })

                                          ]

                                      )
                                  )
                              )
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){
                            setState(() {
                              _taskMode = TaskMode.SubTask;
                            });
                          }, child: const Text("Back")),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              _taskMode = TaskMode.Date;
                              print(_actions);
                            });
                          }, child: const Text("Next"))
                        ],
                      )
                    ],
                  ),
                ),
              if(_taskMode == TaskMode.Date)
                Expanded(child: Column(
                  children: [
                    ElevatedButton(onPressed: (){
                      _selectDate(context);
                    }, child: const Text("Date start")),
                    ElevatedButton(onPressed: (){
                      _endDate(context);
                    }, child: const Text("Date End")),

                    Text("Start: $startDate"),
                    Text("End: $endDate"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        ElevatedButton(onPressed: (){
                          setState(() {
                            _taskMode = TaskMode.ActionPlan;
                          });
                        }, child: const Text("Back")),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            _taskMode = TaskMode.Preview;
                          });
                        }, child: const Text("Next"))
                      ],
                    )
                  ],
                )),
              if(_taskMode == TaskMode.Preview)
                Expanded(
                  child: Column(
                    children: [
                      const Text("Preveiw"),
                      Text(
                        'Region: $singleRegion',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Area: $selectedArea',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Task: ${widget.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sub Task: ${widget.sub}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Task start date: $startDate',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Task End date: $endDate',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Task Action:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [SelectedSubtask].map((task) {
                              String taskName = SelectedSubtask;
                              Map<String, String>? actions = _actions[taskName];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: $taskName '),
                                  const SizedBox(height: 8),
                                  Text("Priority: ${actions!['priority']}"),
                                  Text("Action Plan: ${actions['action']}"),

                                  const SizedBox(height: 8),
                                ],
                              );
                            }).toList(),)


                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){
                            setState(() {
                              _taskMode = TaskMode.Date;
                            });
                          }, child: const Text("Back")),
                          ElevatedButton(onPressed: (){
                            print(target);
                            _saveNo();
                          }, child: const Text("Submit"))
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
        )
    );
  }
}
