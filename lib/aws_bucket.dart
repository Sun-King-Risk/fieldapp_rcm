import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/task.dart';
import 'package:fieldapp_rcm/task/collection.dart';
import 'package:fieldapp_rcm/task/customer.dart';
import 'package:fieldapp_rcm/task/pilot_process.dart';
import 'package:fieldapp_rcm/task/portfolio.dart';
import 'package:fieldapp_rcm/task/team.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

import 'http_online.dart';

class Bucket extends StatefulWidget {
  /*final Function(String) onTask;

  //final Function(String) onSubTask;
  //final Function(List?) taskResult;
  final Function(String) onregionselected;
  final Function(String?) onareaselected;

  Bucket(
      {
      //required this.onregionselected,
   */
      //required this.onareaselected,
     // required this.onTask,
      //required this.onSubTask,
      //required this.taskResult});**/

  @override
  BucketState createState() => new BucketState();
}

class BucketState extends State<Bucket> {
  @override
  initState() {
    getFileProperties();
    agentList.toList();
  }

  final _formKey = GlobalKey<FormState>();
  late String selectedTask = '';
  String selectedSubTask = '';
  late String regionselected = '';
  late String areaselected = '';
  late String agentselected = '';
  List? _myActivities;
  late String priority = '';
  late String target;
  String? selectedarea;
  late String _myActivitiesResult;
  List<String> agentList = [];
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

  Future<void> listItems() async {
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

  Future<void> getFileProperties() async {
    List<String> uniqueAgentList = [];
    try {
      StorageGetPropertiesResult<StorageItem> result =
          await Amplify.Storage.getProperties(
        key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json',
      ).result;
      StorageGetUrlRequest fileResult = await Amplify.Storage.getUrl(
              key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json')
          .request;
      StorageItem dd = result.storageItem;
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
              key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json')
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

      safePrint('File size: $dd');
      safePrint('File url: ${agentList}');
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  final _Key = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new task"),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
            key: _Key,
            child: Column(children: [
              FormBuilderTextField(
                name: "FIRST_NAME",
                decoration: InputDecoration(labelText: 'First Name'),
              ),
          FormBuilderDropdown(
              name: 'dropdown',
          isExpanded: true,

          items: dataTask.keys.map((option) {

            return DropdownMenuItem(
              child: Text("$option"),
              value: option,
            );
          }).toList(),
          ),

              FormBuilderRadioGroup(
                onChanged: (val) {
                  print(val);
                  setState(() {
                    selectedTask = val!;
                  });
                },
                name: "Task",
                orientation: OptionsOrientation.vertical,
                decoration: InputDecoration(
                  labelText: "Task",
                  fillColor: Colors.red,
                  focusColor: Colors.blue,
                  hoverColor: Colors.yellow,
                ),
                options: dataTask.keys.map(
                      (task) => FormBuilderFieldOption(
                    value: task,
                    child: Text(task),
                  ),
                ).toList(),

              ),
            Builder(
                 builder: (context) {
    switch (selectedTask) {
        case 'Collection Drive':
          return Column(
            children: [
              Text("Collection Drive")
            ],
          );
      case 'Team Management':
        return Column(
          children: [
            Text("Team Management")
          ],
        );
      case 'Portfolio Quality':
        return Column(
          children: [
            Text("Portfolio Quality")
          ],
        );
      case 'Collection Drive':
        return Column(
          children: [
            Text("Collection Drive")
          ],
        );
        case '':
          return Column();
        default :
          return Column();

    }

        })



            ]
    )
        ),
      )
    );
  }
}




class TaskAdd extends StatefulWidget{
  @override
  TaskAddState createState() => new TaskAddState();

}
class TaskAddState extends State<TaskAdd>{
  List data = [];
  initState() {
    listItems("welcome_calls".replaceAll(" ", "_"));
  }
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
        print(latestFile.key);
        getTask(latestFile.key);
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
  Future<void> getTask(key) async {
    List<Map<String, dynamic>>  uniqueAgentList = [];

    try {
      StorageGetPropertiesResult<StorageItem> result =
      await Amplify.Storage.getProperties(
        key: key,
      ).result;
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      //List<dynamic> jsonDataList = jsonDecode(jsonData);
      for (var item in jsonData) {
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
        data?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }

      setState(() {
        safePrint('File team: $uniqueAgentList');
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Visiting unreachable welcome call clients"),
          Text("Visiting unreachable welcome call clients".replaceAll(" ", "_")),
          Text("Visiting unreachable welcome call clients".replaceAll(" ", "_")),
        ],
      ),

    );
  }

}