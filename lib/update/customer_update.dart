import '../task_actions.dart';
import 'package:flutter/material.dart';

import '../widget/drop_down.dart';


class CustomerUpdate extends StatefulWidget {
  final title;
  final id;
  final task;
  final subtask;
  CustomerUpdate(
      {Key? key,
        required this.subtask,
        required this.task,
        required this.id,
        required this.title})
      : super(key: key);
  @override
  State<CustomerUpdate> createState() => _CustomerUpdateState();
}

class _CustomerUpdateState extends State<CustomerUpdate> {
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
            if(selectedSubTask == 'Visiting of issues raised')
              Audity(),
            if(selectedSubTask == 'Repossession of customers needing repossession')
              Repo(
                docid: widget.id,
                id: widget.task,
              ),
            if(selectedSubTask == 'Look at the number of replacements pending at the shops')
              Accuracy(),
            if(selectedSubTask == 'Look at the number of repossession pending at the shops')
              Fraud(),
          ],
        ),
      ),
    );
  }
}


