import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/db.dart';
import 'multTeam.dart';
class MyTaskNew extends StatefulWidget {
  const MyTaskNew({super.key});


  @override
  _MyTaskNewState createState() => _MyTaskNewState();
}
enum TaskMode {
  Task, SubTask, Region, Area, TableTask, ActionPlan, Date, Preview ,TeamCountry,
  TeamZone,TeamRegion,TeamArea,TeamRole,

}
class _MyTaskNewState extends State<MyTaskNew> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAttributes();
  }
  DateTime selectedDate = DateTime.now();
  int currentYear = DateTime.now().year;
   String endDate =  "";
   String startDate = "";
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
  int _currentPage = 0;
  final int _pageSize = 10;
  List getPageData() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    return taskData!.sublist(startIndex, endIndex < taskData!.length ? endIndex : taskData!.length);
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
  String selectedArea = '';
  List? areadata = [];
  String zone ='';
  String role = '';
  String email = "";
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
      'task_title': selectedOption,
      'sub_task': SelectedSubtask,
      'task_region': selectedRegion,
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
    taskActionNo(resultTask["id"]);

  }
  void _save() async{
    Map data = {
      'task_title': selectedOption,
      'sub_task': SelectedSubtask,
      'task_region': selectedRegion,
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
    taskAction(resultTask["id"]);

  }
  void taskAction(id) async {
    for (final entry in _actions.entries) {
      String agentName = entry.key;
      Map<String, dynamic>? agentDetails = taskData!.firstWhere(
              (agent) => agent['Agent'] == agentName
      );

      if (agentDetails != null) {
        String current = agentDetails[rate];
        String? percvalue = current.substring(0,current.length - 1);
        double total = double.parse(entry.value['target']!)+double.parse(percvalue);
        Map data =   {
          "task": id,
          "account_number":entry.key,
          "goals": total,
          "task_description": entry.value['action'],
          "priority": entry.value['priority'],
          "task_status": "pending",
          "previous_goal":double.parse(percvalue)
        };
        var body = json.encode(data);
        var url = Uri.parse('${AppUrl.baseUrl}/taskgoal/create/');
        http.Response response = await http.post(url, body: body, headers: {
          "Content-Type": "application/json",
        });
        print(response.body);


      }
    }
    const snackBar = SnackBar(
      content: Text('Task Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);






  }
  void taskActionNo(id) async {
    for (final entry in _actions.entries) {
      String taskName = entry.key;
      Map<String, dynamic>? taskDetails =taskData!.firstWhere(
              (task) => task[key] == taskName
      );
      if (taskDetails != null) {
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
  int _sortColumnIndex = 2;
  bool _sortAscending = true;
  List? taskData = [];
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

        singleRegion = prefs.getString("region")!;
        name = prefs.getString("name")!;
        userRegion = prefs.getString("region")!;
        country = prefs.getString("country")!;
        submited_role = prefs.getString("role")!;
        task_zone = prefs.getString("zone")!;
      });
      if (kDebugMode) {
        print(submited_role);
        print(name);
        print( task_zone);
      }
      // Process the user attributes


  }
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      );

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;

        RegionTask(latestFile.key);
        print(latestFile.key);
        if(
        SelectedSubtask== 'Work with the Agents with low welcome calls to improve'||
            SelectedSubtask=='Increase the Kazi Visit Percentage' ||
            SelectedSubtask == 'Field Visits with low-performing Agents in Collection Score'
        ){
          target = true;
        }else{
          target = false;
        }
        return resultList.first;
      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }
      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
    return null;
  }
  Future<void> RegionTask(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");


    try {

      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      print('File Data: $jsonData');
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['Region'] == singleRegion &&
          task['Country'] == country
      ).toList();
      print(filteredTasks.length);

      for (var item in filteredTasks) {
        //String region = item['Region'];
        //region?.add(region);
        if(item['Region'] == null){
        }else{
          uniqueRegion.add(item['Region']);
        }

      }
      setState(() {

        data = filteredTasks;
        region = uniqueRegion.toSet().toList();
        isLoading = false;


      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  final int _currentStep = 0;
  final List<String> portfolio = [
    'Visiting unreachable welcome call clients',
    'Work with the Agents with low welcome calls to improve',
    'Change a red zone CSAT area to orange',
    'Attend to Fraud Cases',
    'Visit at-risk accounts',
    'Visits FPD SPDs',
    'Other'
  ];
  final List<String> customer = [
    'Visiting of issues raised',
    'Repossession of customers needing repossession',
    'Look at the number of replacements pending at the shops',
    'Look at the number of repossession pending at the shops',
    'Other - Please Expound'
  ];
  final List<String> pilot = [
    'Conduct the process audit',
    'Conduct a pilot audit',
    'Testing the GPS accuracy of units submitted',
    'Reselling of repossessed units',
    'Repossessing qualified units for Repo and Resale',
    'Increase the Kazi Visit Percentage',
    'Other'
  ];
  final List<String> collection = [
    'Field Visits with low-performing Agents in Collection Score',
    'Repossession of accounts above 180',
    'Visits Tampering Home 400',
    'Work with restricted Agents',
    'Calling of special book',
    'Sending SMS to clients',
    'Table Meeting/ Collection Sensitization Training',
    'Others'
  ];
  final List<String> team = [
    'Assist a team member to improve the completion rate',
    'Raise a reminder to a team member',
    'Raise a warning to a team member',
    'Raise a new task to a team member',
    'Inform the team member of your next visit to his area, and planning needed',
    'Other'
  ];
  String SelectedSubtask = '';
  List<String> Taskoptions = [
    'Portfolio Quality',
    'Collection Drive',
    /*'Pilot/Process Management',
    'Team Management',*/
    'Customer Management',
  ];
  String selectedOption = '';

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
                child: Column(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: Taskoptions.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                            title: Text(Taskoptions[index]),
                            value: Taskoptions[index],
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value.toString();
                                print(selectedOption);
                                _taskMode = TaskMode.SubTask;

                              });
                            }
                        );
                      }
                  )
                ],),
              ),
            if(_taskMode == TaskMode.SubTask)
              Expanded(
                child: Column(
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        switch(selectedOption){
                          case 'Portfolio Quality':
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: portfolio.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                          title: Text(portfolio[index]),
                                          value: portfolio[index],
                                          groupValue: SelectedSubtask,
                                          onChanged: (value) {
                                            setState(() {
                                              SelectedSubtask = value.toString();
                                              print(SelectedSubtask);

                                            });
                                          }
                                      );
                                    }
                                )
                              ],

                            );
                          case 'Team Management':
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: team.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                          title: Text(team[index]),
                                          value: team[index],
                                          groupValue: SelectedSubtask,
                                          onChanged: (value) {
                                            setState(() {
                                              SelectedSubtask = value.toString();
                                              print(SelectedSubtask);

                                            });
                                          }
                                      );
                                    }
                                )
                              ],

                            );
                          case 'Collection Drive':
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: collection.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                          title: Text(collection[index]),
                                          value: collection[index],
                                          groupValue: SelectedSubtask,
                                          onChanged: (value) {
                                            setState(() {
                                              SelectedSubtask = value.toString();
                                              print(SelectedSubtask);

                                            });
                                          }
                                      );
                                    }
                                )
                              ],

                            );
                          case 'Pilot/Process Management':
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: pilot.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                          title: Text(pilot[index]),
                                          value: pilot[index],
                                          groupValue: SelectedSubtask,
                                          onChanged: (value) {
                                            setState(() {
                                              SelectedSubtask = value.toString();
                                              print(SelectedSubtask);

                                            });
                                          }
                                      );
                                    }
                                )
                              ],

                            );
                          case 'Customer Management':
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: customer.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                          title: Text(customer[index]),
                                          value: customer[index],
                                          groupValue: SelectedSubtask,
                                          onChanged: (value) {
                                            setState(() {
                                              SelectedSubtask = value.toString();
                                              print(SelectedSubtask);

                                            });
                                          }
                                      );
                                    }
                                )
                              ],

                            );
                          default:
                            return Container(
                              child: const Text('No option selected'),
                            );


                        }
                      },),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: (){

                          setState(() {
                            _taskMode = TaskMode.Task;
                          });
                        }, child: const Text("Back")),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            if(selectedOption =='Team Management'){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => TeamTaskCreate(
                                  title: selectedOption,
                                  sub: SelectedSubtask,
                                )),
                              );
                            }else{
                              getUserAttributes();
                              listItems(SelectedSubtask.replaceAll(' ', '_'));
                              _taskMode = TaskMode.Region;
                            }

                          });
                        }, child: const Text("Next"))
                      ],
                    )
                  ],
                ),
              ),
            if(_taskMode == TaskMode.Region)
              Expanded(
                child: Column(
                  children: [
                    isLoading?const Center(
                      child: Column(
                        children: [

                          CircularProgressIndicator(),
                          Text(' Please wait...')
                        ],
                      ),
                    ):Container(
                      child: region.isEmpty?Center(child:Text("No Task under $SelectedSubtask")):
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: region.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                                title: Text(region[index]),
                                value: region[index],
                                groupValue: selectedRegion,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRegion = value.toString();
                                    print(selectedRegion);
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
                            isLoading = true;
                            _taskMode = TaskMode.SubTask;
                          });
                        }, child: const Text("Back")),
                        ElevatedButton(onPressed: (){
                          if(region.isEmpty){

                          }else{
                            setState(() {
                              _taskMode = TaskMode.Area;
                              Area();
                            });
                          }

                        }, child: const Text("Next"))
                      ],
                    )
                  ],
                ),
              ),
            if(_taskMode == TaskMode.Area)
              Expanded(
                child: Column(
                  children: [
                    isLoadingArea?const Center(
                      child: CircularProgressIndicator(),
                    ):areadata!.isEmpty?Center(child:Text("No Task under $SelectedSubtask")):
                    Expanded(
                      child: ListTileTheme(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0,),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: areadata?.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                  title: Text(areadata?[index]),
                                  value:areadata?[index],
                                  groupValue: selectedArea,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedArea = value.toString();
                                      print(selectedArea);

                                    });
                                  }
                              );
                            }

                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState(() {
                            _taskMode = TaskMode.Region;
                          });
                        }, child: const Text("Back")),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            TableData();
                            _taskMode = TaskMode.TableTask;
                          });

                        }, child: const Text("Next"))
                      ],
                    )
                  ],
                ),
              ),
            if(_taskMode == TaskMode.TableTask)
              Expanded(
                child: isLoadingTable?const Center(
                  child: CircularProgressIndicator(),
                ):
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            for (int index = 0; index < keys.length; index++)
                              if (keys[index] != 'Country' && keys[index] != 'Region' && keys[index] != 'Area')
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Text(keys[index]),
                                      if (_sortColumnIndex == index)
                                        _sortAscending
                                            ? const Icon(Icons.arrow_upward)
                                            : const Icon(Icons.arrow_downward),
                                    ],
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      if (_sortColumnIndex == columnIndex) {
                                        // Toggle the sorting direction if the same column is selected
                                        _sortAscending = !_sortAscending;
                                      } else {
                                        _sortAscending = true;
                                        _sortColumnIndex = columnIndex;
                                      }
                                      taskData!.sort((a, b) {
                                        var aValue = a[keys[columnIndex]].toString();
                                        var bValue = b[keys[columnIndex]].toString();
                                        return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
                                      });
                                    });
                                  },
                                ),
                            const DataColumn(label: Text('Select')),
                          ],
                          rows: [
                            for (final item in getPageData())
                              DataRow(
                                cells: [
                                  for (int cellIndex = 0; cellIndex < keys.length; cellIndex++)
                                    if (keys[cellIndex] != 'Country' && keys[cellIndex] != 'Region' && keys[cellIndex] != 'Area')

                                      DataCell(
                                        Text(item[keys[cellIndex]].toString()),
                                      ),
                                  DataCell(
                                    Checkbox(
                                      value: taskDataList.contains(item),
                                      onChanged: (value) {
                                        setState(() {
                                          if (taskDataList.contains(item)) {
                                            taskDataList.remove(item);
                                          } else {
                                            taskDataList.add(item);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                                selected: taskDataList.contains(item),
                                onSelectChanged: (value) {
                                  setState(() {
                                    if (taskDataList.contains(item)) {
                                      taskDataList.remove(item);
                                    } else {
                                      taskDataList.add(item);
                                      if (taskDataList.length <= 5) {
                                        if (kDebugMode) {
                                          print(taskDataList);
                                        }
                                      } else {
                                        safePrint('Only 5 tasks allowed');
                                      }
                                    }
                                  });
                                },
                              ),
                          ],
                        )

                        ,
                      ),


                      // Pagination buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: (){
                                setState(() {
                                  _currentPage = _currentPage > 0 ? _currentPage - 1 : 0;
                                });
                              },
                              child: const Text("Previous Table"
                                ,style: TextStyle(color: Colors.black),)),
                          TextButton(
                              onPressed: (){
                                setState(() {
                                  final nextPageStartIndex = (_currentPage + 1) * _pageSize;
                                  if (nextPageStartIndex < taskData!.length) {
                                    _currentPage++;
                                  }
                                });
                              },
                              child: const Text("Next Table"
                                ,style: TextStyle(color: Colors.black),)),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){
                            setState(() {
                              _taskMode = TaskMode.Area;
                              taskDataList = [];
                            });
                          }, child: const Text("Back")),
                          ElevatedButton(onPressed: (){
                            if(taskDataList.length<=5&&taskDataList.isNotEmpty){
                              setState(() {
                                _taskMode = TaskMode.ActionPlan;

                              });

                            }else if(taskDataList.length>5){
                              const snackBar = SnackBar(
                                content: Text('Exceeded task selection limit!'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else{
                              print("No task selected");
                              const snackBar = SnackBar(
                                content: Text('No task selected!'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            }
                          }, child: const Text("Next"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            if(_taskMode == TaskMode.ActionPlan)
              Expanded(
                child: Column(
                  children: [
                    if (target) Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: taskDataList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data = taskDataList[index];
                            String agent = data[key];
                            String agentRate = data[rate];
                            if (!_actions.containsKey(agent)) {
                              _actions[agent] = {'action': '', 'priority': _priorities[0]};
                            }
                            String datanew = taskDataList[index].toString();
                            return Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$key: $agent - $agentRate ',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            decoration: const InputDecoration(
                                              hintText: 'Enter action plan',
                                              labelText: 'Action Plan',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _actions[agent]!['action'] = value;
                                              });
                                            },
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Target',
                                              labelText: 'Target',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _actions[agent]!['target'] = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          AppDropDown(
                                              disable: true,
                                              label: "Priority",
                                              items: _priorities,
                                              hint: "Priority",
                                              onChanged: (value){
                                                setState(() {
                                                  _actions[agent]!['priority'] = value;
                                                });
                                              })

                                        ]

                                    )
                                )
                            );

                          }),
                    ) else

                      Expanded(

                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: taskDataList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = taskDataList[index];
                              String agent = data[key];
                              if (!_actions.containsKey(agent)) {
                                _actions[agent] = {'action': '', 'priority': _priorities[0]};
                              }
                              String datanew = taskDataList[index].toString();
                              return Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$key: $agent',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              decoration: const InputDecoration(
                                                hintText: 'Enter action plan',
                                                labelText: 'Action Plan',
                                              ),
                                              onChanged: (value) {
                                                print(value);
                                                setState(() {
                                                  _actions[agent]!['action'] = value;
                                                });
                                              },
                                              maxLines: 3,
                                            ),
                                            const SizedBox(height: 8),
                                            AppDropDown(
                                                disable: true,
                                                label: "Priority",
                                                items: _priorities,
                                                hint: "Priority",
                                                onChanged: (value){
                                                  setState(() {
                                                    _actions[agent]!['priority'] = value;
                                                  });
                                                })


                                          ]

                                      )
                                  )
                              );

                            }),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState(() {
                            _taskMode = TaskMode.TableTask;
                          });
                        }, child: const Text("Back")),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            _taskMode = TaskMode.Date;
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
                      'Task: $selectedOption',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sub Task: $SelectedSubtask',
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
                    target?Column(
                      children: [
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: taskDataList.map((task) {
                            String taskName = task[key];
                            String current = task[rate];
                            Map<String, String>? actions = _actions[taskName];
                            String? percvalue = current.substring(0,current.length - 1);
                            double total = double.parse(actions!['target']!)+double.parse(percvalue);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: $taskName '),
                                const SizedBox(height: 8),
                                Text("Priority: ${actions['priority']}"),
                                Text("Action Plan: ${actions['action']}"),
                                Text('Current: $percvalue'),
                                Text('Target: ${actions['target']}'),
                                Text('Goal: $total'),

                                const SizedBox(height: 8),
                              ],
                            );
                          }).toList(),)
                      ],
                    ):Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: taskDataList.map((task) {
                            String taskName = task[key];
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
                          target?_save():_saveNo();
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
