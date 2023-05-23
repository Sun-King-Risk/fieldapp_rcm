import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/task_actions.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:http/http.dart' as http;

class Portfolio extends StatefulWidget {
  final Function(List?) onSave;
  final String? subtask;
  final String? area;
  final List? data;

  Portfolio({required this.data,required this.area,required this.subtask,required this.onSave});
  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  List<String> _data = [];
  List? dataTask = [];
  /*Future<StorageItem?> listItems(key) async {
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
        print("Key: $key");
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
      final jsonresult = jsonDecode(response.body);
      final jsonData = jsonresult.where((item) => item['Area'] == widget.area).toList();
      //List<dynamic> jsonDataList = jsonDecode(jsonData);
      if(widget.subtask == 'Visiting unreachable welcome call clients'){
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
      }else if(widget.subtask == 'Work with the Agents with low welcome calls to improve'){
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
      }else if(widget.subtask == 'Change a red zone CSAT area to orange'){
        for (var item in jsonData) {
          String CustomerName = item['Customer Name'];
          String AngazaID = item['Angaza ID'];
          Map<String, dynamic> dataItem = {
            'display': '$CustomerName - $AngazaID',
            'value': '$CustomerName - $AngazaID',
          };
          data?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Attend to Fraud Cases'){
        for (var item in jsonData) {
          String Suspect = item['Suspect Name'];
          String Account = item['Account Number'];

          Map<String, dynamic> dataItem = {
            'display': '$Suspect - $Account',
            'value': '$Suspect - $Account',
          };
          data?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Visit at-risk accounts'){
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
      }else if(widget.subtask == 'Visits FPD/SPDs'){
        for (var item in jsonData) {
          String agent = item['Agent'];
          String unreachabilityRate = item['%Unreachabled rate within SLA'];
          Map<String, dynamic> dataItem = {
            'display': '$agent',
            'value': '$agent',
          };
          data?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }



      setState(() {
        safePrint('File_team: $uniqueAgentList');
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }*/
  Future<void> getTaskList() async {
    List<Map<String, dynamic>>  uniqueAgentList = [];
      final jsonresult = widget.data;
      final jsonData = jsonresult?.where((item) => item['Area'] == widget.area).toList();
      //List<dynamic> jsonDataList = jsonDecode(jsonData);
      if(widget.subtask == 'Visiting unreachable welcome call clients'){
        for (var item in jsonData!) {
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
          dataTask?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Work with the Agents with low welcome calls to improve'){
        for (var item in jsonData!) {
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
          dataTask?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Change a red zone CSAT area to orange'){
        for (var item in jsonData!) {
          String CustomerName = item['Customer Name'];
          String AngazaID = item['Angaza ID'];
          Map<String, dynamic> dataItem = {
            'display': '$CustomerName - $AngazaID',
            'value': '$CustomerName - $AngazaID',
          };
          dataTask?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Attend to Fraud Cases'){
        for (var item in jsonData!) {
          String Suspect = item['Suspect Name'];
          String Account = item['Account Number'];

          Map<String, dynamic> dataItem = {
            'display': '$Suspect - $Account',
            'value': '$Suspect - $Account',
          };
          dataTask?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Visit at-risk accounts'){
        for (var item in jsonData!) {
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
          dataTask?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }else if(widget.subtask == 'Visits FPD/SPDs'){
        for (var item in jsonData!) {
          String agent = item['Agent'];
          String unreachabilityRate = item['%Unreachabled rate within SLA'];
          Map<String, dynamic> dataItem = {
            'display': '$agent',
            'value': '$agent',
          };
          dataTask?.add(dataItem);
          uniqueAgentList.add(dataItem);
        }
      }



      setState(() {
        safePrint('File_team: $uniqueAgentList');
      });

  }
  List? _mydata = [];
  initState() {
    getTaskList();
    //listItems(widget.subtask?.replaceAll(" ", "_"));
    super.initState();
  }

  List<dynamic>? _myActivities;
  late String _myActivitiesResult;
  List? datastatic =   [
  {
  "display": "Task 1",
  "value": "Task 1",
  },
  {
  "display": "Task 2",
  "value": "Task 2",
  },
  {
  "display": "Task 3",
  "value": "Task 3",
  },
  {
  "display": "Task 4",
  "value": "Task 4",
  },
  {
  "display": "Task 5",
  "value": "Task 5",
  },
  {
  "display": "Task 6",
  "value": "Task 6",
  },
  {
  "display": "Task 7",
  "value": "Task 7",
  },
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        SizedBox(height: 10,),
    Column(
    children: [
    Text("Number of Task ${dataTask!.length}"),
    AppMultselect(
    title: widget.subtask!,
    onSave: (value) {

    widget.onSave(value);
    if (value == null) return;

    widget.onSave(value);
    },
    items: dataTask,


    )
/*
        if(widget.subtask == 'Visiting unreachable welcome call clients')
          Column(
            children: [
              AppMultselect(
                title: widget.subtask!,
                onSave: (value) {

                  widget.onSave(value);
                  if (value == null) return;

                  widget.onSave(value);
                },
                items: data,


              ),
            ],
          ),
        if(widget.subtask == 'Work with the Agents with low welcome calls to improve')
          Column(
            children: [
              Text("Number of agent ${data!.length}"),
              AppMultselect(
                title: widget.subtask!,
                onSave: (value) {

                  widget.onSave(value);
                  if (value == null) return;

                  widget.onSave(value);
                },
                items: data,


              )


              /*AppMultselect(
                title: widget.subtask!,
                onSave: (value) {
                  _myActivities = value;
                },
                onChange:(value){
                  print(value);
                  setState(() {
                    _myActivities = value;
                  });
                  print(_myActivities);
                },
                items: _mydata,

              ),*/
            ],
          ),
        if(widget.subtask == 'Change a red zone CSAT area to orange')
          Container(
            child: Column(
              children: [
                Text("Number of case ${data!.length}"),
                AppMultselect(
                  title: widget.subtask!,
                  onSave: (value) {
                    if (value == null) return;
                    widget.onSave(value);
                  },
                  items: data,


                ),
              ],
            ),
          ),
        if(widget.subtask == 'Attend to Fraud Cases')
          Column(
            children: [
              Text("Number of Fraud Case ${data!.length}"),
              AppMultselect(
                title: widget.subtask!,
                onSave: (value) {
                  if (value == null) return;
                  widget.onSave(value);
                },
                items: data,


              ),
            ],
          ),
        if(widget.subtask == 'Visit at-risk accounts')
          Column(
            children: [
              Text("Number of accounts ${data!.length}"),
              AppMultselect(
                title: widget.subtask!,
                onSave: (value) {
                  if (value == null) return;
                  widget.onSave(value);
                  setState(() {
                    _myActivities = value;
                  });

                },
                items: data,


              ),
              Text(_myActivities.toString())
            ],
          ),

        if(widget.subtask== 'Visits FPD/SPDs')
          Container(
            child: Column(
              children: [
                Text("Number of accounts ${data!.length}"),
                AppMultselect(
                  title: widget.subtask!,
                  onSave: (value) {
                    if (value == null) return;
                    widget.onSave(value);
                  },
                  items: data,


                ),
              ],
            ),
          ),
        if(widget.subtask== 'Others')
          Container(
            child: Column(
              children: [
                Text("Number of accounts ${data!.length}"),
                AppMultselect(
                  title: widget.subtask!,
                  onSave: (value) {
                    if (value == null) return;
                    widget.onSave(value);
                  },
                  items: data,


                ),
              */],
            ),
          ]);
  }
}


