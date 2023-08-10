import '../task_actions.dart';
import 'package:flutter/material.dart';

import '../widget/drop_down.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class TeamUpdate extends StatefulWidget {
  final title;
  final id;
  final subtask;
  final taskGoalId;
  TeamUpdate(
      {Key? key,
        required this.subtask,
      required this.taskGoalId,
        required this.id,
        required this.title})
      : super(key: key);
  @override
  State<TeamUpdate> createState() => _TeamUpdateState();
}

class _TeamUpdateState extends State<TeamUpdate> {
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
      body: SingleChildScrollView(
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
                report_details: "None",
              ),
            if(selectedSubTask == 'Conduct a pilot audit')
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
                report_details: "None",
              ),
            if(selectedSubTask == 'Testing the GPS accuracy of units submitted')
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
                report_details: "None",
              ),
            if(selectedSubTask == 'Reselling of repossessed units')
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
            if(selectedSubTask == 'Repossessing qualified units for Repo and Resale')
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
            if(selectedSubTask == 'Increase the Kazi Visit Percentage')
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
    );
  }
}


