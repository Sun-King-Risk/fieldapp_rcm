import 'dart:convert';
import 'package:fieldapp_rcm/report.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/task_table.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/title_view.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dailyupdate.dart';
import 'location.dart';
import 'models/db.dart';
import 'pending_task.dart';
import 'team_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}
class _TaskState extends State<Task> {
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
        children: <Widget>[
        Container(
        constraints: const BoxConstraints.expand(height: 40),
    child: const TabBar(tabs: [
    Tab(
    text: "My Task",
    ),
    Tab(text: "Team Task"),
    Tab(
    text: "Report",
    ),
    ]),
    ),
      Expanded(
        child: Container(
          child: TabBarView(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(

                  children: [

                    Row(
                      children: [
                        Expanded(child:  ElevatedButton(onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LocationMap(),
                              ));
                        },
                          child: const Text("Map"),
                        )),
                        SizedBox(width: 10,),
                        Expanded(child:  ElevatedButton(onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TaskAddDrop(),
                              ));

                        },
                          child: const Text("Add Task"),
                        )),


                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      BoXDesign(cardLength: 2,title: "Portfolio Quality",),
                      BoXDesign(cardLength: 2,title: "Collection Drive",),
                    ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      BoXDesign(cardLength: 2,title: "Cusromer Management",),
                      BoXDesign(cardLength: 2,title: "Process Management",),
                    ],),
                    TitleView(
                      titleTxt: 'Upcoming Task',
                      subTxt: 'Details',
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: 5,
                          separatorBuilder: (context, index) => SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Task ${index + 1}'),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(child: TeamTask()),
            Container(child: Report()),


          ]
        ),
      ),

    ),
    ]
        ));
  }
  }
class BoXDesign extends StatelessWidget{
  final int cardLength;
  final String title;
  BoXDesign({required this.cardLength,required this.title});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth - 28) / this.cardLength;
    return Card(
        child: Container(
          width: cardWidth,
          height: 158,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8.0),
              Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FlexColumnWidth(1), // Width of the first column
                  1: FlexColumnWidth(1),
                  // Width of the second column
                },
                  children: [
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Header row background color
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Task',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                    ),
                    TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pending'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('30'),
                            ),
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pending'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('30'),
                            ),
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pending'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('30'),
                            ),
                          ),
                        ]
                    )

                  ]
              ),

            ],
          ),
        )
    );
    // TODO: implement build
    throw UnimplementedError();
  }

}
