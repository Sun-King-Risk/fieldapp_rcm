import 'dart:convert';

import 'package:flutter/material.dart';
import '../task_actions.dart';
import '../widget/drop_down.dart';
import 'package:http/http.dart' as http;
class CollectionUpdate extends StatefulWidget {


  final title;
  final id;
  final subtask;
  final taskGoalId;
  const CollectionUpdate(
      {Key? key,
        required this.subtask,
        required this.id,
        required this.taskGoalId,
        required this.title})
      : super(key: key);
  @override
  State<CollectionUpdate> createState() => _CollectionUpdateState();
}

class _CollectionUpdateState extends State<CollectionUpdate> {
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
    String? selectedValue;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskGoalId.toString()),
            Text(widget.id.toString()),
            const SizedBox(height: 10,),
            AppDropDown(
                disable: true,
                label: widget.title,
                hint: "hint",
                items: [widget.title],
                onChanged: (value) {}),
            const SizedBox(height: 10,),
            AppDropDown(
                disable: true,
                label: widget.subtask,
                hint: widget.subtask,
                items: [widget.subtask],
                onChanged: (value) {}),
            const SizedBox(height: 10,),
            if(widget.subtask == 'Field Visits with low-performing Agents in Collection Score')
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
            if(widget.subtask == 'Repossession of accounts above 180')
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
            if(widget.subtask == 'Visits Tampering Home 400')
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
            if(widget.subtask == 'Work with restricted Agents')
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
            if(widget.subtask == 'Calling of special book')
              Campaign(
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
            if(widget.subtask == 'Sending SMS to clients')
              Campaign(
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
            if(widget.subtask == 'Table Meeting/ Collection Sensitization Training')
              Campaign(
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