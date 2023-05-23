
import 'package:fieldapp_rcm/add_task.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/task_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pending_task.dart';
import 'team_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 40),
              child: TabBar(tabs: [

                Tab(text: "My Task",),
                Tab(text: "Team Task"),
                Tab(text: "Pending/Request"),
              ]),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15),
                child: TabBarView(children: [
                  SingleChildScrollView(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                            ),
                            onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTask(),
                                    ));
                            },
                            child: Text("Add New Task")),
                        Card(
                          shadowColor: Colors.amber,
                          color: Colors.black,
                          child: ListTile(
                            title: Center(child: Text("Overrall Task Complete Rate 34%", style: TextStyle(fontSize: 15,color: Colors.yellow))),
                            dense: true,
                          ),
                        ),

                        TaskList(
                          task_title: 'Collection Drive',
                          
                          task_complete:"9",
                          task: '5',

                        ),
                        TaskList(
                          task_title: 'Process Management',
                         
                          task_complete: '45',
                          task: '5',

                        ),
                        TaskList(
                          task_title: 'Pilot Management',
                         
                          task_complete: '45',
                          task: '5',

                        ),
                        TaskList(
                          task_title: 'Portfolio Quality',
                          
                          task_complete: '45',
                          task: '5',

                        ),
                        TaskList(
                          task_title: 'Customer Management',
                         
                          task_complete: '45',
                          task: '5',

                        ),
                      ],
                    ),

                  ),
                  Container(
                    child: TeamTask(),
                  ),
                  Container(

                    child:PendingTask(),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class TaskList extends StatefulWidget {

  final String task_title;
  
  final String task;
  final String task_complete;
  const TaskList({Key? key,
    required this.task_title,
    required this.task,
    required this.task_complete,

  })
      : super(key: key);



  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM').format(now);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyTaskView(endPoint: 'tasks',title: widget.task_title,),
            ));
      },

      child: StreamBuilder<int>(
        stream: TaskData().CountTask(widget.task_title).asStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Container(
              height: 60,
              padding:EdgeInsets.only(left: 5,right: 5,bottom: 0,top: 5),
              margin: EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.task_title,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  SizedBox(height:5),
                  Row(children: [
                    StreamBuilder(
                      stream: TaskData().CountTask(widget.task_title).asStream(),
                      builder: (context, snapshot){
                    return Text(snapshot.data.toString()+" Total,",style: TextStyle(color: Colors.red),);
                    },
                    ),
                    StreamBuilder(
                      stream: TaskData().CountByStatus(widget.task_title,'Completed').asStream(),
                      builder: (context, snapshot){
                        return Text(snapshot.data.toString()+" Completed, ",style: TextStyle(color: Colors.green),);
                      },
                    ),
                    StreamBuilder(
                      stream: TaskData().CountByStatus(widget.task_title,'Pending').asStream(),
                      builder: (context, snapshot){
                        return  Text(snapshot.data.toString()+" Pending",style: TextStyle(color: Colors.orange));
                      },
                    ),
                  ],),

                ],
              ),
            );
          }
          else if(snapshot.hasError){
            return Text('Error Loding data');
          }else{
            return Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Loading...'),
              ],
            );
          }

        }
      ),

    );
  }
}



