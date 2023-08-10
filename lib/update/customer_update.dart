import '../task_actions.dart';
import 'package:flutter/material.dart';

import '../widget/drop_down.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CustomerUpdate extends StatefulWidget {
  final title;
  final id;
  final subtask;
  final taskGoalId;
  CustomerUpdate(
      {Key? key,
        required this.subtask,

        required this.id,
        required this.taskGoalId,
        required this.title})
      : super(key: key);
  @override
  State<CustomerUpdate> createState() => _CustomerUpdateState();
}

class _CustomerUpdateState extends State<CustomerUpdate> {
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
        child:
        Column(
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
            if(selectedSubTask == 'Visiting of issues raised')
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
            if(selectedSubTask == 'Repossession of customers needing repossession')
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
            if(selectedSubTask == 'Look at the number of replacements pending at the shops')
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
            if(selectedSubTask == 'Look at the number of repossession pending at the shops')
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
          ],
        ),
      ),
    );
  }
}


