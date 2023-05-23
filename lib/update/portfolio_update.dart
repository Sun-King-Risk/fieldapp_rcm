import '../task_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../widget/drop_down.dart';

class PortfolioUpdate extends StatefulWidget {
  PortfolioUpdate(
      {Key? key,
      required this.subtask,
      required this.task,
      required this.id,
      required this.title})
      : super(key: key);
  final title;
  final id;
  final task;
  final subtask;

  @override
  PortfolioUpdateState createState() => new PortfolioUpdateState();
}

class PortfolioUpdateState extends State<PortfolioUpdate> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> _getDocuments() async {
    final querySnapshot =
        await firestore.collection("task").doc(widget.task).get();
    final data = querySnapshot.data();
    print(data?['Area']);
  }
  @override
  void initState() {
    _getDocuments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              docid: widget.id,
            ),
          if (widget.subtask ==
              'Work with the Agents with low welcome calls to improve')
            Agent(
              docid: widget.id,
              id: widget.task,
            ),
          if (widget.title ==
              'Work with the Agents with low welcome calls to improve')
            Agent(docid: widget.id, id: widget.id),
          if (widget.title == 'Change a red zone CSAT area to orange')
            RedZone(),
          if (widget.title == 'Attend to Fraud Cases') Fraud(),
          if (widget.title == 'Visit at-risk accounts')
            FieldVisit(
              docid: widget.id,
              id: widget.task,
            ),
          if (widget.title == 'Visits FPD/SPDs')
            FieldVisit(
              docid: widget.id,
              id: widget.task,
            ),
        ],
      )),
    );
  }
}
