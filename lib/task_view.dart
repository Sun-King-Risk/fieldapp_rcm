
import 'dart:convert';
import 'package:fieldapp_rcm/single_task_view.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

class TaskView extends StatefulWidget {
  @override
  TaskViewState createState() => TaskViewState();
}
class TaskViewState extends State<TaskView> {
  List data =[];
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<String> getData() async {
    const apiUrl = 'https://sun-kingfieldapp.herokuapp.com/api/tasks';
    final response = await http.get(Uri.parse(apiUrl,),headers:{
      "Content-Type": "application/json",});

    this.setState(() {
      data = json.decode(response.body);
    });


    return "Success!";
  }
  @override
  void initState(){
    this.getData();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
      ),
      body:  Column(
        children: [
          Container(
            height: 200,

            padding:EdgeInsets.only(left: 15,right: 25,bottom: 5,top: 5),
            margin: EdgeInsets.only(left: 20,right: 25,bottom: 0,top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Task Summary",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 15.0,
                  percent: 0.4,
                  progressColor: Colors.red,
                  center: Text("40.0%"),
                ),

                SizedBox(height: 10,),
                SizedBox(
                  height: 5,
                ),
                Text("Task Status",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("6 Complete",style: TextStyle(color: Colors.green),),
                Text("3 Pending",style: TextStyle(color: Colors.orange)),
                Text("5 Over Due",style: TextStyle(color: Colors.red)),



              ],
            ),
                SizedBox(height: 10,),
              Text("Priority",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                SizedBox(height:10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Text("6 High",style: TextStyle(color: Colors.green)),
                    Text("3 Normal",style: TextStyle(color: Colors.orange)),
                    Text("5 Low",style: TextStyle(color: Colors.red)),


                  ],
                ),

              ],
            ),
          ),
          Container(
            padding:EdgeInsets.only(left: 30, right: 30, bottom: 5, top: 5),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
            height: 30,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                Icon(Icons.filter_alt_rounded),
               Icon(Icons.search),
                               ],
            )
          ),
          SizedBox(height: 5,),
          Expanded(
            child:SingleChildScrollView(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(6),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) =>PendingRequest(id: data[index]['id'], TittleName: data[index]['sub_task'], status:Colors.cyan)));

                    },
                    child:Row(
                      children: [
                        Icon(Icons.brightness_1,color: Colors.green,),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Container(
                            width: 350,
                            height: 70,
                            child: Card(
                              elevation: 5,

                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20.0,10,0,0),
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Title:"),
                                    Text("Sub Task:"),
                                    Text("Date Created: 23/11/22")

                                  ],
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }


}

class TaskDetail extends StatelessWidget {
  final String task_title;
  final String sub_task;
  final String date;
  const TaskDetail({Key? key,
    required this.task_title,
    required this.sub_task,
    required this.date,
  });
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Card(
        elevation: 3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(task_title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
              Row(

                children: [
                  Text("Sub Task:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(width: 15),
                  Text(sub_task, style: TextStyle(fontSize: 15,)),
                ],
              ),


              Row(

                children: [
                  Text("Date start:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(width: 5),
                  Text(date, style: TextStyle(fontSize: 15,)),
                  SizedBox(width: 20),
                  Text("Date end:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(width: 5),
                  Text(date, style: TextStyle(fontSize: 15,)),
                ],
              ),
              SizedBox(height: 5),

            ],
          ),
        ),
      ),
    );
  }
}


