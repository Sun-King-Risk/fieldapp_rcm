import '../task_actions.dart';
import 'package:flutter/material.dart';

import '../widget/drop_down.dart';


class TeamUpdate extends StatefulWidget {
  final title;
  final id;
  final task;
  final subtask;
  TeamUpdate(
      {Key? key,
        required this.subtask,
        required this.task,
        required this.id,
        required this.title})
      : super(key: key);
  @override
  State<TeamUpdate> createState() => _TeamUpdateState();
}

class _TeamUpdateState extends State<TeamUpdate> {
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
              Audity(),
            if(selectedSubTask == 'Conduct a pilot audit')
              Audity(),
            if(selectedSubTask == 'Testing the GPS accuracy of units submitted')
              Accuracy(),
            if(selectedSubTask == 'Reselling of repossessed units')
              Fraud(),
            if(selectedSubTask == 'Repossessing qualified units for Repo and Resale')
              Repo(
                docid: widget.id,
                id: widget.task,
              ),
            if(selectedSubTask == 'Increase the Kazi Visit Percentage')
              Agent(
                docid: widget.id,
                id: widget.task,
              ),
          ],
        ),
      ),
    );
  }
}


