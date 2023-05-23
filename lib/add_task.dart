import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/task/collection.dart';
import 'package:fieldapp_rcm/task/customer.dart';
import 'package:fieldapp_rcm/task/pilot_process.dart';
import 'package:fieldapp_rcm/task/portfolio.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'http_online.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late String selectedTask = '';
  late String selectedSubTask = '';
  late String regionselected = '';
  late String areaselected = '';
  late String agentselected = '';
  late String priority = '';
  late String target;
  List? _myActivities;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          AddTaskForm(
            onregionselected: (value) {
              regionselected = value;
            },
            onareaselected: (value) {
              areaselected = value!;
            },
            onTask: (value) {
              selectedTask = value;
            },
            taskResult: (value) {
              _myActivities = value;
              print(_myActivities!.length);
            },
            onSubTask: (value) {
              selectedSubTask = value;
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActionScreen(
                              customers: _myActivities?.toSet().toList(),
                              onChange: (value) {},
                              Area: areaselected,
                              region: regionselected,
                              task: selectedTask,
                              subtask: selectedSubTask,
                            )));
              },
              child: Text('Next'))
        ],
      ),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  final Function(String) onTask;
  final Function(String) onSubTask;
  final Function(List?) taskResult;
  final Function(String) onregionselected;
  final Function(String?) onareaselected;

  AddTaskForm(
      {super.key, required this.onregionselected,
      required this.onareaselected,
      required this.onTask,
      required this.onSubTask,
      required this.taskResult});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  initState() {

    //listItems("visit");
    super.initState();
   //getFileProperties();
    //agentList.toList();
  }
  List<String> region= [];
  List<String> area =[];
  List<String> agentList = [];
  String? selectedarea;
  String? selectedregion;
  late String selectedTask = '';
  late Map<String, List<String>> dataTask = {
    'Portfolio Quality': portfolio,
    'Team Management': team,
    'Collection Drive': collection,
    'Pilot/Process Management': pilot,
    'Customer Management': customer,
  };
  final List<String> portfolio = [
    'Visiting unreachable welcome call clients',
    'Work with the Agents with low welcome calls to improve',
    'Change a red zone CSAT area to orange',
    'Attend to Fraud Cases',
    'Visit at-risk accounts',
    'Visits FPD/SPDs',
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
  String? selectedSubTask;
  List? data = [];
  List? dataList = [];
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = await Amplify.Storage.list(
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
        print("Key: $key");

        return resultList.first;

      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }

      for (StorageItem item in resultList) {
        print('Key: ${item.key}');
        print('Last Modified: ${item.lastModified}');
        // Access other properties as needed
      }

      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
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
      print('File_team: $jsonData');
      for (var item in jsonData) {
        //String region = item['Region'];
        //region?.add(region);
        if(item['Region'] == null){
          uniqueRegion.add('No region');
        }else{
          uniqueRegion.add(item['Region']);
        }

      }
      setState(() {
        data = jsonData;
        region = uniqueRegion.toSet().toList();
        safePrint('File_team: $jsonData');
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  Future<void> Area(region) async {

    List<String> uniqueArea = [];

    final jsonData = data?.where((item) => item['Region'] == region).toList();
    for (var areaList in jsonData!) {
      String area = areaList['Area'];
      //region?.add(region);
      uniqueArea.add(area);
    }
    setState(() {
      dataList = jsonData;
      area = uniqueArea.toSet().toList();
      //safePrint('File_team: $data');
    });
    //safePrint('Area: $area');
  }
  /*Future<void> getFileProperties() async {
    List<String> uniqueAgentList = [];
    try {
      StorageGetPropertiesResult<StorageItem> result =
          await Amplify.Storage.getProperties(
        key: 'Change_a_red_zone_CSAT_area_to_orange_2023-05-21T2123_8whzDw.json',
      ).result;
      StorageGetUrlRequest fileResult = await Amplify.Storage.getUrl(
              key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json')
          .request;
      StorageItem dd = result.storageItem;
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
              key: 'Change_a_red_zone_CSAT_area_to_orange_2023-05-21T2123_8whzDw.json')
          .result;
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      for (var item in jsonData) {
        String agent = item['Area'];
        uniqueAgentList.add(agent);
      }
      setState(() {
        agentList = uniqueAgentList.toSet().toList();
      });

      //safePrint('File size: $dd');
     // safePrint('File url: ${agentList}');
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }*/

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
        child: Column(
      children: <Widget>[


        AppDropDown(
            disable: true,
            label: "Task Title",
            hint: "Task Title",
            items: dataTask.keys.toList(),
            onChanged: (value) {

              // widget.onTask(value!);
              selectedTask = value;
              setState(() {
                selectedTask = value;
                print(value);
                widget.onTask(value);
              });

            }),
        SizedBox(
          height: 8,
        ),
        AppDropDown(
            disable: false,
            label: "Sub Task",
            hint: "Sub Task",
            items: dataTask[selectedTask] ?? [],
            onChanged: (value) {
              listItems(value?.replaceAll(' ', '_'));
              setState(() {
                selectedSubTask = value!;

                print(value);
              });
              widget.onSubTask(value!);
            }),
        SizedBox(
          height: 8,
        ),
        AppDropDown(
            disable: true,
            label: "Region",
            hint: "Region",
            items: region,
            onChanged: (value) {
              widget.onregionselected(value!);
              selectedregion = value;
              Area(value);
              //_getArea();
            }),
        SizedBox(
          height: 8,
        ),
        AppDropDown(
            disable: true,
            label: "Area",
            hint: "Area",
            items: area,
            onChanged: (value) {
              setState(() {
                selectedarea = value;
              });
              widget.onareaselected(value!);
            }),
        SizedBox(
          height: 8,
        ),

        Builder(builder: (context) {
          if (selectedTask ==  'Portfolio Quality' && selectedarea != null) {
            return Portfolio(
              data: dataList,
                area: selectedarea,
                subtask: selectedSubTask,
                onSave: (value) {
                  widget.taskResult(value);
                });
          } else if (
          selectedTask == 'Team Management' && selectedarea != null)
           return Portfolio(
             data: dataList,
              onSave: (value) {
                widget.taskResult(value);
              },
              subtask: selectedSubTask??'',
             area: selectedarea,);
          else if (selectedTask == 'Collection Drive' && selectedarea != null)
            return Collection(
              data: dataList,
              onSave: (value) {
                widget.taskResult(value);
              },
              subtask: selectedSubTask??'',
              area: selectedarea,);
          else if (selectedTask == 'Pilot/Process Management')
            return Pilot(
              data: dataList,
              onSave: (value) {
                widget.taskResult(value);
              },
              subtask: selectedSubTask??'',
              area: selectedarea,
            );
          else if (selectedTask == 'Customer Management' && selectedarea != null)
           return CustomerManagement(
             data: dataList,
             onSave: (value) {
               widget.taskResult(value);
             },
             subtask: selectedSubTask??'',
             area: selectedarea,
           );
          else
            return const Column(
              children: [
               Text("There is no Task under this category and area")
              ],
            );

        }),
      ],
    ));
  }
}

class ActionPlan extends StatefulWidget {
  @override
  initState() {}

  final List? customers;
  final Function(List?) onChange;
  final String region;
  final String Area;
  final String task;
  final String subtask;

  const ActionPlan(
      {required this.customers,
      required this.onChange,
      required this.Area,
      required this.region,
      required this.task,
      required this.subtask});

  @override
  _ActionPlanState createState() => _ActionPlanState();
}

class _ActionPlanState extends State<ActionPlan> {
  initState() {
    print(widget.customers?.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Action Plan"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.customers!.length,
                itemBuilder: (context, int index) {
                  return Card(child: Text(widget.customers!.length.toString()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
