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
class TaskAddDrop extends StatefulWidget {
  const TaskAddDrop({super.key});


  @override
  _TaskAddState createState() => _TaskAddState();
}
enum TaskMode {
  Task, SubTask, Region, Area, TableTask, ActionPlan, Date, Preview ,TeamCountry,
  TeamZone,TeamRegion,TeamArea,TeamRole,

}
class _TaskAddState extends State<TaskAddDrop> {
  TaskMode _taskMode = TaskMode.Task;
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
  String selectedRegion = '';
  List<String> areadata = [];
  String zone ='';
  String role = '';
  String email = "";
  List<String> region= [];
  List<String> taskTitle =[];
  List<String> SubTaskTitle =[];
  String selectedOption = '';
  String SelectedSubtask = '';
  bool istaskLoding = true;
  bool subvisibility = false;
  bool areaVisibility = false;
  bool regionVisibility = false;
  bool isSubLoading = true;
  bool isRegionLoad = true;
  var taskResult= [];
  var regionResult = [];
  bool isLoadingTable = true;
  List? taskData = [];
  List<Map<String, dynamic>> taskDataList = [];
  List<Map<String, dynamic>> selectedItems = [];
  String key= 'Agent';
  List<String> keys = [];
  String rate = '';
  String searchQuery = '';
  int _sortColumnIndex = 2;
  bool _sortAscending = true;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool target =true;
  bool loadVisibility = false;
  String filetext = '';
  bool buttonVisibility= false;
  final List<String> _priorities = ['High', 'Medium', 'Low'];
  DateTime selectedDate = DateTime.now();
  int currentYear = DateTime.now().year;
  String endDate =  "";
  String startDate = "";
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
    var url = Uri.parse('https:/sun-kingfieldapp.herokuapp.com/api/create');
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
    var url = Uri.parse('https://sun-kingfieldapp.herokuapp.com/api/create');
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
        var url = Uri.parse('https://sun-kingfieldapp.herokuapp.com/api/taskgoal/create/');
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
        var url = Uri.parse('https://sun-kingfieldapp.herokuapp.com/api/taskgoal/create/');
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
  List getPageData() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    return taskData!.sublist(startIndex, endIndex < taskData!.length ? endIndex : taskData!.length);
  }
  TaskData()async{
    var connection = await Database.connect();
    var results = await connection.query( "SELECT * FROM myfieldapp_title");
    for (var title in results) {
      taskTitle.add(title[1]);
    }
    setState(() {
      istaskLoding = false;
      taskResult =results;
    });
  }
  SubTaskData(id)async{
    var connection = await Database.connect();
    var results = await connection.query( "SELECT * FROM myfieldapp_sub_title WHERE kpititleid_id = @kpititleid_id",
        substitutionValues: {"kpititleid_id":id});
    for (var title in results) {
      SubTaskTitle.add(title[1]);
      print(SubTaskTitle);
    }
    setState(() {
      isSubLoading = false;
    });
    print(results);
  }
  regionData()async{
    var connection = await Database.connect();
    var results = await connection.query("SELECT * FROM myfieldapp_region WHERE country = @country",
        substitutionValues: {"country":country});
    for (var title in results) {
      region.add(title[1]);
      print(region);
    }
    setState(() {
      isRegionLoad = false;
      regionResult = results;
    });
    print(results);
  }
  AreaData(id)async{
    var connection = await Database.connect();
    var results = await connection.query( "SELECT * FROM myfieldapp_area WHERE regionameid_id = @regionameid_id",
        substitutionValues: {"regionameid_id":id});
    for (var area in results) {
      areadata.add(area[1]);
      print(areadata);
    }
    setState(() {
      isLoadingArea = false;
    });
    print(results);
  }
  Future<StorageItem?> listItems(key) async {
    print("dennis $key");
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
       setState(() {
          loadVisibility = true;
          isLoading = false;
       });
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
          .where((task) =>
          task['Country'] == country
      ).toList();
      print("county: $country $filteredTasks");
      print(filteredTasks.length);
      if(filteredTasks.isEmpty){
        setState(() {
          isLoading = false;
        });



      }else{
        setState(() {
          data = filteredTasks;
          isLoading = false;
          TableData();
          _taskMode = TaskMode.TableTask;
        });
      }

    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  Future<void> TableData() async{
    setState(() {
      taskData =  data?.where((item) => item['Region'] == selectedRegion && item['Area']== selectedArea).toList();
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


  @override
  void initState() {
    super.initState();
    getUserAttributes();
    TaskData();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
    body: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if(_taskMode == TaskMode.Task)
            Expanded(
              child: Column(
                children: [
                  istaskLoding?const Center(
                    child: CircularProgressIndicator(),
                  ):
                  AppDropDown(
                      disable: true,
                      label: "Task Title",
                      hint: "hint",
                      items: taskTitle,
                      onChanged: (value){

                        setState(() {
                          isSubLoading =true;
                          SubTaskTitle =[];
                          selectedOption =value;
                          subvisibility = true;
                          loadVisibility =  false;
                          buttonVisibility= false;
                        });
                          var id = taskResult.firstWhere((taskid) => taskid[1]==selectedOption)[0];
                        SubTaskData(id);
                        print(isSubLoading);
                      }),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: subvisibility,
                    child: isSubLoading?const Center(
                      child: CircularProgressIndicator(),
                    ):AppDropDown(
                        disable: true,
                        label: "Sub Task",
                        hint: "Select option",
                        items: SubTaskTitle,
                        onChanged: (value){
                          setState(() {
                            isRegionLoad =true;
                            region = [];

                            SelectedSubtask =value;
                            regionVisibility= true;
                            areaVisibility = false;
                            areadata = [];
                            loadVisibility =  false;
                            buttonVisibility= false;
                          });
                            regionData();


                        }),
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: regionVisibility,
                    child:  isRegionLoad?const Center(
                      child: CircularProgressIndicator(),
                    ):AppDropDown(
                        disable: true,
                        label: "Region",
                        hint: "Select Region",
                        items: region,
                        onChanged: (value){
                          setState(() {
                            areadata = [];
                            isLoadingArea = true;
                            selectedRegion =value;
                            areaVisibility =true;
                            buttonVisibility= false;
                            loadVisibility =  false;

                          });
                          var id = regionResult.firstWhere((regionname) => regionname[1]==selectedRegion)[0];
                          print("region selected $selectedRegion");
                          AreaData(id);

                        }),
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: areaVisibility,
                    child:  isLoadingArea?const Center(
                      child: CircularProgressIndicator(),
                    ):AppDropDown(
                        disable: true,
                        label: "Area",
                        hint: "Select Area",
                        items: areadata,
                        onChanged: (value){
                          setState(() {
                            selectedArea =value;
                            loadVisibility =  false;
                            buttonVisibility= true;
                          });

                        }),
                  ),
                  Visibility(
                    visible: buttonVisibility,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(

                            onPressed: () {
                              if(selectedOption=='Team Management'){
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => TeamTaskCreate(
                                    title: selectedOption,
                                    sub: SelectedSubtask,
                                  )),
                                );
                              }else{
                                if(country == "Kenya"){
                                  print("Kenya");
                                  listItems("KE/${SelectedSubtask.replaceAll(' ', '_')}");
                                }else if(country == "Nigeria"){
                                  print("Nigeria");
                                  listItems("NG/${SelectedSubtask.replaceAll(' ', '_')}");
                                }else if(country == "Tanzania"){
                                  print("Tanzania");
                                  listItems("TZ/${SelectedSubtask.replaceAll(' ', '_')}");
                                }else{
                                  print("other");
                                  listItems("other/${SelectedSubtask.replaceAll(' ', '_')}");
                                }
                                setState(() {
                                  loadVisibility =  true;
                                  isLoading = true;
                                });
                              }

                            },
                            child: const Text("Next"),

                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: loadVisibility,
                    child: Center(
                      child: isLoading?const Column(
                        children: [
                          CircularProgressIndicator(),
                          Text("Please wait data is loding.."),
                        ],
                      ):Column(children: [
                        Text("No task: $SelectedSubtask for the selected Area: $selectedArea")
                      ],),
                    ),
                  )
                ],
              ),),
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
                            _taskMode = TaskMode.Task;
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