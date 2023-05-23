
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/task_view.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class TeamTask extends StatefulWidget {
  @override
  TeamTaskState createState() => new TeamTaskState();
}

class TeamTaskState extends State<TeamTask> {
  initState() {
    getFileProperties();
    agentList.toList();
  }
  Future<void> getFileProperties() async {
    List<String> uniqueAgentList = [];
    try {
      StorageGetPropertiesResult<StorageItem> result =
      await Amplify.Storage.getProperties(
        key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json',
      ).result;
      StorageGetUrlRequest fileResult = await Amplify.Storage.getUrl(
          key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json')
          .request;
      StorageItem dd = result.storageItem;
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: 'Agents_with_low_welcome_calls_2023-05-14T0204_r95sHZ.json')
          .result;
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      for (var item in jsonData) {
        String agent = item['Area'];
        uniqueAgentList.add(agent);
      }
      setState(() {
        agentList = uniqueAgentList.toSet().toList();
      });

      safePrint('File size: $dd');
      safePrint('File url: ${agentList}');
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
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

  Future<String> getData() async {
    const apiUrl = 'https://sun-kingfieldapp.herokuapp.com/api/tasks';
    final response = await http.get(Uri.parse(apiUrl,),headers:{
      "Content-Type": "application/json",});

    this.setState(() {
      data = json.decode(response.body);
    });


    return "Success!";
  }
  void _nameFilter(String _status) {
    List<Map<String, dynamic>> results = [];
    switch(_status) {

      case "Abdallah": { results = _allUsers.where((user) =>
          user["name"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;

      case "Dennis": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;

      case "Jackson": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;
      case "zainab": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(_status.toLowerCase()))
          .toList(); }
      break;
      case "Candy": {  results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(_status.toLowerCase()))
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
               Text("Team Members"),
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

                       PopupMenuItem(
                           child: Text("All"),
                           value: "All"
                       ),
                       PopupMenuItem(
                           child: Text("Abdallah"),
                           value: "Abdallah"
                       ),
                       PopupMenuItem(
                           child: Text("Dennis"),
                           value: "Dennis"
                       ),
                       PopupMenuItem(
                           child: Text("Jackson"),
                           value: "Jackson"
                       ),
                       PopupMenuItem(
                           child: Text("Zainab"),
                           value: "zainab"
                       ),
                       //mewnu
                       PopupMenuItem(child: Text("Candy"),
                           value: "Candy"
                       )
                     ],
                     icon: Icon(
                         Icons.filter_list_alt,color: Colors.yellow
                     ),

                   )
                 ],
               )


             ],
           ),
           Expanded(child: ListView.builder(
             itemCount: _foundUsers.length,

             itemBuilder: (context, index) {

               final sortedItems = _foundUsers
                 ..sort((item1, item2) => isDescending
                     ? item2['name'].compareTo(item1['name'])
                     : item1['name'].compareTo(item2['name']));
               return Container(
                 margin: EdgeInsets.all(15),
                 child: InkWell(
                   onTap: (){
                     Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) =>  TaskView()));
                   },
                   child:Row(
                     children: [
                       CircleAvatar(
                         backgroundColor: Colors.amber.shade800,
                         radius:35,
                         child: Text(_foundUsers[index]['name'][0]),),
                       SizedBox(width: 10,),
                       Flexible(
                         child: Container(
                           width: 350,
                           height: 90,
                           child: Card(
                             elevation: 5,

                             child: Padding(
                               padding: EdgeInsets.fromLTRB(20.0,10,0,0),
                               child: Column(

                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Name: ${_foundUsers[index]['name']}"),
                                   Text("Region:${_foundUsers[index]['region']}"),
                                   Text("Area ${_foundUsers[index]['area']}"),
                                   Text("On Progess Task: ${_foundUsers[index]['task']}")

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
          child: Text("Click"),
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