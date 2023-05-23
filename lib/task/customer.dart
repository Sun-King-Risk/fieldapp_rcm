import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../widget/drop_down.dart';


class CustomerManagement extends StatefulWidget {
  final Function(List?) onSave;
  final String? subtask;
  final String? area;
  final List? data;

  CustomerManagement(
      {required this.data,
    required this.area,
    required this.subtask,
    required this.onSave});
  @override
  State<CustomerManagement> createState() => _CustomerManagementState();
}

class _CustomerManagementState extends State<CustomerManagement> {
  @override
  initState() {
    getTaskList();
  }
  Future<void> getTaskList() async {
    List<Map<String, dynamic>> uniqueAgentList = [];
    final jsonresult = widget.data;
    final jsonData =
    jsonresult?.where((item) => item['Area'] == widget.area).toList();
    //List<dynamic> jsonDataList = jsonDecode(jsonData);
    if (widget.subtask ==
        'Visiting of issues raised') {
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, dynamic> dataItem = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    } else if (widget.subtask == 'Repossession of customers needing repossession') {
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, dynamic> dataItem = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    } else if (widget.subtask == 'Look at the number of replacements pending at the shops') {
      for (var item in jsonData!) {
        String customerName = item['Customer Name'];
        String angazaID = item['Angaza ID'];
        Map<String, dynamic> dataItem = {
          'display': '$customerName - $angazaID',
          'value': '$customerName - $angazaID',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    } else if (widget.subtask == 'Look at the number of repossession pending at the shops') {
      for (var item in jsonData!) {
        String suspect = item['Suspect Name'];
        String account = item['Account Number'];

        Map<String, dynamic> dataItem = {
          'display': '$suspect - $account',
          'value': '$suspect - $account',
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    } else if (widget.subtask == 'Others') {
      for (var item in jsonData!) {
        String agent = item['Agent'];
        Map<String, dynamic> dataItem = {
          'display': agent,
          'value': agent,
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }

    setState(() {
      safePrint('File_team: $uniqueAgentList');
    });
  }
  String? selectedSubTask;
  List? dataTask = [];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      AppMultselect(
        title: widget.subtask!,
        onSave: (value) {
          widget.onSave(value);
          if (value == null) return;

          widget.onSave(value);
        },
        items: dataTask,
      )
    ]);
  }
}



