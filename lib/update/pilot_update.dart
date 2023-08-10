import '../task_actions.dart';
import 'package:flutter/material.dart';

import '../widget/drop_down.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PilotUpdate extends StatefulWidget {
  final title;
  final id;
  final subtask;
  final taskGoalId;
  PilotUpdate(
      {Key? key,
        required this.subtask,
        required this.taskGoalId,
        required this.id,
        required this.title})
      : super(key: key);
  @override
  State<PilotUpdate> createState() => _PilotUpdateState();
}

class _PilotUpdateState extends State<PilotUpdate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  List? data = [];
  void fetchData() async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks/${widget.id}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        print(jsonDecode(response.body));
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        data = [jsonData];
        print(data?[0]["task_title"]);
      });
    }else{
      print('Request failed with status: ${response.statusCode}');
    }
  }
  String? selectedSubTask;
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? _selectedValue;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 10,),
          AppDropDown(
              disable: true,
              label: widget.title,
              hint: "hint",
              items: [widget.title],
              onChanged: (value) {}),
              SizedBox(height: 10,),
              AppDropDown(
                  disable: true,
                  label: widget.subtask,
                  hint: widget.subtask,
                  items: [widget.subtask],
                  onChanged: (value) {}),
              if(selectedSubTask == 'Conduct the process audit')
                Audity(
                  sub: widget.subtask,
                  id: widget.id,
                  report_area: data?[0]["task_area"],
                  report_region: data?[0]["region"],
                  report_country: data?[0]["task_country"],
                  sub_task: data?[0]["sub_task"],
                  submited_by: data?[0]["submited_by"],
                  report_title: data?[0]["task_title"],
                  report_priority: "Normal",
                  report_details: "None",),
              if(widget.subtask == 'Conduct a pilot audit')
                Audity(
                  sub: widget.subtask,
                  id: widget.id,
                  report_area: data?[0]["task_area"],
                  report_region: data?[0]["region"],
                  report_country: data?[0]["task_country"],
                  sub_task: data?[0]["sub_task"],
                  submited_by: data?[0]["submited_by"],
                  report_title: data?[0]["task_title"],
                  report_priority: "Normal",
                  report_details: "None",),
              if(widget.subtask == 'Testing the GPS accuracy of units submitted')
                Accuracy(
                  sub: widget.subtask,
                  id: widget.id,
                  report_area: data?[0]["task_area"],
                  report_region: data?[0]["region"],
                  report_country: data?[0]["task_country"],
                  sub_task: data?[0]["sub_task"],
                  submited_by: data?[0]["submited_by"],
                  report_title: data?[0]["task_title"],
                  report_priority: "Normal",
                  report_details: "None",),
              if(widget.subtask == 'Reselling of repossessed units')
                Fraud(
                  sub: widget.subtask,
                  id: widget.id,
                  report_area: data?[0]["task_area"],
                  report_region: data?[0]["region"],
                  report_country: data?[0]["task_country"],
                  sub_task: data?[0]["sub_task"],
                  submited_by: data?[0]["submited_by"],
                  report_title: data?[0]["task_title"],
                  report_priority: "Normal",
                  report_details: "None",
                  ),
              if(widget.subtask == 'Repossessing qualified units for Repo and Resale')
                Repo(
                  sub: widget.subtask,
                  id: widget.id,
                  report_area: data?[0]["task_area"],
                  report_region: data?[0]["region"],
                  report_country: data?[0]["task_country"],
                  sub_task: data?[0]["sub_task"],
                  submited_by: data?[0]["submited_by"],
                  report_title: data?[0]["task_title"],
                  report_priority: "Normal",
                  report_details: "None",
                ),
              if(widget.subtask == 'Increase the Kazi Visit Percentage')
                Agent(
                  sub: widget.subtask,
                  id: widget.id,
                  report_area: data?[0]["task_area"],
                  report_region: data?[0]["region"],
                  report_country: data?[0]["task_country"],
                  sub_task: data?[0]["sub_task"],
                  submited_by: data?[0]["submited_by"],
                  report_title: data?[0]["task_title"],
                  report_priority: "Normal",
                  report_details: "None",
                ),
            ],
          ),
        ),
      ),
    );
  }
}


