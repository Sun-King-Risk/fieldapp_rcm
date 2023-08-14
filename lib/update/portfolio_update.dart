import '../task_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../widget/drop_down.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PortfolioUpdate extends StatefulWidget {
  PortfolioUpdate(
      {Key? key,
      required this.subtask,
      required this.id,
        required this.taskGoalId,
      required this.title})
      : super(key: key);
  final title;
  final id;
  final subtask;
  final taskGoalId;

  @override
  PortfolioUpdateState createState() => new PortfolioUpdateState();
}

class PortfolioUpdateState extends State<PortfolioUpdate> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 10,
            ),
            AppDropDown(
                disable: true,
                label: widget.subtask,
                hint: widget.subtask,
                items: [widget.subtask],
                onChanged: (value) {}),
            SizedBox(
              height: 10,
            ),
            if (widget.subtask == 'Visiting unreachable welcome call clients')
              Visiting(
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
            if (widget.subtask ==
                'Work with the Agents with low welcome calls to improve')
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
            if (widget.title ==
                'Work with the Agents with low welcome calls to improve')
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
                report_details: "None",),
            if (widget.title == 'Change a red zone CSAT area to orange')
              RedZone(
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
            if (widget.title == 'Attend to Fraud Cases') Fraud(
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
            if (widget.title == 'Visit at-risk accounts')
              FieldVisit(
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
            if (widget.title == 'Visits FPD/SPDs')
              FieldVisit(
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
          )),
    );
  }
}
