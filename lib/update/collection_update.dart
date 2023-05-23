import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../task_actions.dart';
import '../widget/drop_down.dart';
class CollectionUpdate extends StatefulWidget {
  final title;
  final id;
  final task;
  final subtask;
  CollectionUpdate(
      {Key? key,
        required this.subtask,
        required this.task,
        required this.id,
        required this.title})
      : super(key: key);
  @override
  State<CollectionUpdate> createState() => _CollectionUpdateState();
}

class _CollectionUpdateState extends State<CollectionUpdate> {
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
            SizedBox(height: 10,),
            if(widget.subtask == 'Field Visits with low-performing Agents in Collection Score')
              FieldVisit(
                docid: widget.id,
                id: widget.task,
              ),
            if(widget.subtask == 'Repossession of accounts above 180')
              Repo(
                docid: widget.id,
                id: widget.task,
              ),
            if(widget.subtask == 'Visits Tampering Home 400')
              FieldVisit(
                docid: widget.id,
                id: widget.task,
              ),
            if(widget.subtask == 'Work with restricted Agents')
              Agent(
                docid: widget.id,
                id: widget.task,
              ),
            if(widget.subtask == 'Calling of special book')
              Campaign(),
            if(widget.subtask == 'Sending SMS to clients')
              Campaign(),
            if(widget.subtask == 'Table Meeting/ Collection Sensitization Training')
              Campaign(),

          ],
        ),
      ),
    );
  }
}