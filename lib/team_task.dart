
import 'package:flutter/foundation.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/db.dart';
class TeamTask extends StatefulWidget {
  const TeamTask({super.key});

  @override
  TeamTaskState createState() => TeamTaskState();
}

class TeamTaskState extends State<TeamTask> {
  @override
  initState() {
    getUserAttributes();
    agentList.toList();
    getUser();

  }
  List<String> agentList = [];
  List data =[];
  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Abdallah", "region":"Northern", "task":5,"area":"Kahama"},
    {"id": 2, "name": "Dennis", "region":"South", "task":7,"area":"Arusha"},
    {"id": 3, "name": "Jackson", "region":"Coast", "task":9,"area":"Mwanza"},
    {"id": 4, "name": "Barbara","region":"Central", "task":12,"area":"Mbeya"},
    {"id": 5, "name": "Candy", "region":"West", "task":1,"area":"Tanga"},

  ];
  bool isDescending =false;
  String name ="";
  String region = '';
  String userRegion = '';
  String country ='';
  String zone ='';
  String role = '';
  String email = "";
  void getUserAttributes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      userRegion =  prefs.getString("region")!;
      country =  prefs.getString("country")!;
      role = prefs.getString("role")!;
      zone =  prefs.getString("zone")!;
    });

    if (kDebugMode) {
    }
    // Process the user attributes


  }
  Future<String> getUser() async {
    var connection = await Database.connect();
    var role = "";
    if(role== 'RCM'){
       role = 'ACE';
    }else if(role == 'ZCM' ||role == 'Credit Analyst'){
       role = 'RCM';
    }else if(role == 'CCM'){
       role = 'Credit Analyst';
    }else if(role  == 'ACE'||role == 'Area Collection Executive'){
       role = '';
    }
    var results = await connection.query( "SELECT * FROM fieldappusers_feildappuser WHERE role = @role AND country = @country",
        substitutionValues: {"role":role,"country": country});


    setState(() {
      data = results;
      print(data);
    });
    return "Success!";
  }
  void _nameFilter(String status) {
    List<Map<String, dynamic>> results = [];
    switch(status) {

      case "Abdallah": { results = _allUsers.where((user) =>
          user["name"].toLowerCase().contains(status.toLowerCase()))
          .toList(); }
      break;

      case "Dennis": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(status.toLowerCase()))
          .toList(); }
      break;

      case "Jackson": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(status.toLowerCase()))
          .toList(); }
      break;
      case "zainab": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(status.toLowerCase()))
          .toList(); }
      break;
      case "Candy": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(status.toLowerCase()))
          .toList(); }
      break;
      case "All": {  results = _allUsers; }
    }


    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  List<Map<String, dynamic>> _foundUsers = [];
  @override


  @override
  Widget build(BuildContext context) {
       return  Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text("Team Members"),
               Row(
                 children: [
                   Container(
                     alignment: Alignment.center,
                     child: IconButton(
                       onPressed: () =>
                           setState(() => isDescending = !isDescending),
                       icon: Icon(
                         isDescending ? Icons.arrow_upward : Icons.arrow_downward,
                         size: 20,
                         color: Colors.yellow,
                       ),
                       splashColor: Colors.lightGreen,
                     ),
                   ),
                   PopupMenuButton(
                     onSelected:(reslust) =>_nameFilter(reslust),
                     itemBuilder: (context) => [

                       const PopupMenuItem(
                           value: "All",
                           child: Text("All")
                       ),
                     ],
                     icon: const Icon(
                         Icons.filter_list_alt,color: Colors.yellow
                     ),

                   )
                 ],
               )


             ],
           ),
           Expanded(child: ListView.builder(
             itemCount: data.length,

             itemBuilder: (context, index) {
               return Container(
                 margin: const EdgeInsets.all(15),
                 child: InkWell(
                   onTap: (){
                    /* Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) =>  TaskView()));*/
                   },
                   child:Row(
                     children: [
                       CircleAvatar(
                         backgroundColor: Colors.amber.shade800,
                         radius:35,
                         child: Text(data[index][6]),),
                       const SizedBox(width: 10,),
                       Flexible(
                         child: SizedBox(
                           width: 350,
                           height: 100,
                           child: Card(
                             elevation: 5,

                             child: Padding(
                               padding: const EdgeInsets.fromLTRB(20.0,10,0,0),
                               child: Column(

                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Name: ${data[index][6]} ${data[index][7]}"),
                                   Text("Region:${data[index][9]}"),
                                   Text("Area ${data[index][10]}"),
                                   Text("Role ${data[index][11]}"),

                                 ],
                               ),
                             ),
                           ),
                         ),
                       )

                     ],
                   ),
                 ),
               );
             },
           ))
         ],
       );
  }
}

class MySource extends DataTableSource {
  List value;
  MySource(this.value) {
    print(value);
  }
  @override
  DataRow getRow(int index) {
    // TODO: implement getRow
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(value[index]["id"].toString())),
        DataCell(Text(value[index]["task_title"].toString())),
        DataCell(Text(value[index]["task_status"].toString())),
        DataCell(Text(value[index]["task_start_date"].toString())),
        DataCell(InkWell(
          onTap:(){
            //fill the form above the table and after user fill it, the data inside the table will be refreshed
          },
          child: const Text("Click"),
        ),),
      ],);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => value.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount =>0;
}
/* ListTile(
          title:
          leading:
          ),
        )*/