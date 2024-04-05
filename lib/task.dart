import 'dart:convert';
import 'package:fieldapp_rcm/report.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/task_table.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
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
                ))

              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BoxTittle(color: Colors.red, title: "title"),
                BoxTittle(color: Colors.red, title: "title"),
                BoxTittle(color: Colors.red, title: "title")
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BoxContent(color: Colors.red, title: "greeen"),
                BoxContent(color: Colors.red, title: "greeen"),
                BoxContent(color: Colors.red, title: "greeen"),
              ],
            ),
            Row(
              children: [
                Expanded(child: BoxTittle(color: Colors.red, title: "title")),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: Container(height: 100,

              child:  Row(
                children: [
                  const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Work with restricted Agents:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Calling of special book:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Sending SMS to clients:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Count Disabled Over 7 Days:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "C2",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "3:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),

                    ],
                  ),

                ],
              ),
            )),
            Row(
              children: [
                Expanded(child: BoxTittle(color: Colors.red, title: "title")),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: Container(height: 100,

              child:  Row(
                children: [
                  const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Work with restricted Agents:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Calling of special book:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Sending SMS to clients:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Table Meeting/ Collection Sensitization Training:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "Count Disabled Over 7 Days:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "C2",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "3:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),

                    ],
                  ),

                ],
              ),
            )),



          ],
        ),
      ),
    );
  }
  }
class BoxTittle extends StatelessWidget {
  final Color color;
  final title;

  const BoxTittle({Key? key, required this.color, required this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = (screenWidth - 32) / 3;
    return Container(
      width: boxWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.yellowAccent.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      height: 30,
      child: Center(child: Text(title)),
    );
  }
}
class BoxContent extends StatelessWidget {
  final Color color;
  final title;

  const BoxContent({Key? key, required this.color, required this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = (screenWidth - 32) / 3;
    return Container(
      child: Column(
        children: [
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data")


        ],
      ),
    );
  }
}