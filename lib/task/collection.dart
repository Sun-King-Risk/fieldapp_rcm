import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import '../widget/drop_down.dart';


class Collection extends StatefulWidget {
  final Function(List?) onSave;
  final String? subtask;
  final String? area;
  final List? data;
  const Collection({super.key, required this.data,required this.area,required this.subtask,required this.onSave});
  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  initState() {
    getTaskList();
  }
  List? dataTask = [];
  Future<void> getTaskList() async {
    List<Map<String, dynamic>>  uniqueAgentList = [];
    final jsonresult = widget.data;
    final jsonData = jsonresult?.where((item) => item['Area'] == widget.area).toList();
    //List<dynamic> jsonDataList = jsonDecode(jsonData);
    if(widget.subtask == 'Field Visits with low-performing Agents in Collection Score'){
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
    }else if(widget.subtask == 'Repossession of accounts above 180'){
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
    }else if(widget.subtask == 'Visits Tampering Home 400'){
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
    }else if(widget.subtask == 'Work with restricted Agents'){
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
    }else if(widget.subtask == 'Calling of special book'){
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
    }else if(widget.subtask == 'Sending SMS to clients'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, dynamic> dataItem = {
          'display': agent,
          'value': agent,
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Table Meeting/ Collection Sensitization Training'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, dynamic> dataItem = {
          'display': agent,
          'value': agent,
        };
        dataTask?.add(dataItem);
        uniqueAgentList.add(dataItem);
      }
    }else if(widget.subtask == 'Others'){
      for (var item in jsonData!) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
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
  List? _myActivities;
  late String _myActivitiesResult;
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 10,),
          AppMultselect(
            title: widget.subtask!,
            onSave: (value) {

              widget.onSave(value);
              if (value == null) return;

              widget.onSave(value);
            },
            items: dataTask,


          )
        ]
    );
  }
}



