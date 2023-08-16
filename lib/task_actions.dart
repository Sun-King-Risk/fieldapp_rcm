import 'dart:convert';

import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Visiting extends StatefulWidget {
  final docid;
  Visiting({required this.docid});
  @override
  State<Visiting> createState() => _Visiting();
}

class _Visiting extends State<Visiting> {
  @override
  void initState() {
    super.initState();
  }

  List<String> _data = [];

  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        taskgoal = filteredTasks;
        print(taskgoal);
      });

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }


    _YesUpdate(id, subtask);
  }
  _YesUpdate(int doc,int id) async {


    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":45,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":34,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });

  }


  String? selectedSubTask;
  String? selectedaction;
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          AppDropDown(
              disable: false,
              label: 'Select user',
              hint: 'Select a user',
              items: _data,
              onChanged: (value){

              }),
          SizedBox(height: 10,),
          DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: "Did we find the right customer?",
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Did we find the right customer?",
              ),
              items: taskaction.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: taskAction),
          SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(onPressed:(){

                }, child: Text("Update"))

              ],
            ),


          if (selectedaction == 'Yes')
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(Icons.camera_alt),
                SizedBox(
                  height: 10,
                ),
                Icon(Icons.location_on),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed:(){

                }, child: Text("Update"))
              ],
            ),


        ],
      ),
    );
  }
}

//Work With agent
class Work extends StatefulWidget {
  final docid;
  final id;
  Work({required this.docid,required this.id});
  @override
  State<Work> createState() => _Work();
}

class _Work extends State<Work> {
  String _data = '';

  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        taskgoal = filteredTasks;
        print(taskgoal);
      });

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }


    _YesUpdate(id, subtask);
  }
  _YesUpdate(int doc,int id) async {


    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });

  }
  @override
  void initState() {

    super.initState();
  }
  String? selectedSubTask;
  String? selectedaction;
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
AppDropDown(
      disable: false,
      label: "Did you manage to work with the Agent?",
      hint: "Did you manage to work with the Agent?",
      items: taskaction,
      onChanged: taskAction),
          SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
          Column(
            children: [
              Text("If it related to frud please rise it through fraud App"),
              TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 1.0),
                    ),
                    labelText: 'Additional details',
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)
                ),
                onPressed:(){
                  print("demm");
                  _NoUpdate(23, 23);
                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: Text("Update"), )
            ],
          ),
          if (selectedaction == 'Yes')
            Column(
              children: [
                AppDropDown(
                  disable: false,
                    label: 'Select user',
                    hint: 'Select a user',
                    items: [_data],
                    onChanged: (value){

                    }),
                SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'More Feedback',
                  ),

                ),
                SizedBox(
                  height: 10,
                ),
                Icon(Icons.camera_alt),
                SizedBox(
                  height: 10,
                ),
                Icon(Icons.location_on),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    _YesUpdate(32, 23);
                    print("demm");
                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: Text("Update"), )
              ],
            ),



        ],
      ),
    );
  }
}

//Change a red zone CSAT area to orange
class RedZone extends StatefulWidget {
  @override
  State<RedZone> createState() => _RedZone();
}

class _RedZone extends State<RedZone> {
  String? selectedSubTask;
  String? selectedaction;
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Issues highlighted',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Additional details',
            )),




        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

//Attend to Fraud Cases
class Fraud extends StatefulWidget {
  @override
  State<Fraud> createState() => _Fraud();
}

class _Fraud extends State<Fraud> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Issues highlighted',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Feedback from the client',
            )),




        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Audity extends StatefulWidget {
  @override
  State<Audity> createState() => _Audity();
}
class _Audity extends State<Audity>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: AppColor.mycolor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Takeaway',
            )),
        SizedBox(height: 10,),
        TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: AppColor.mycolor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Recommendation',
            )),
        SizedBox(height: 10,),
        Icon(Icons.attach_file),

      ],
    );
  }

}
class FieldVisit extends StatefulWidget {
  final docid;
  final id;
  FieldVisit({required this.docid,required this.id});
  @override
  State<FieldVisit> createState() => _FieldVisit();
}
class _FieldVisit extends State<FieldVisit> {
  String _data = '';
  _YesUpdate(String doc,String id) async {
    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);

  }
  _NoUpdate(String doc,String id) async {
    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);

  }
  @override
  void initState() {

    super.initState();
  }
  String? selectedSubTask;
  String? selectedaction;
  TextEditingController feedbackController = TextEditingController();
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to work with the Agent?",
              hint: "Did you manage to work with the Agent?",
              items: taskaction,
              onChanged: taskAction),
          SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.docid);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: Text("No"), )
              ],
            ),
          if (selectedaction == 'Yes')

            Column(
                children: [
                  AppDropDown(
                      disable: false,
                      label: 'Select user',
                      hint: 'Select a user',
                      items: [_data],
                      onChanged: (value){

                      }),
                  SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.camera_alt),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.location_on),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _YesUpdate(widget.id,widget.docid);
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: Text("Update Yes"), )
                ])
        ],
      ),
    );
  }
}

class Accuracy extends StatefulWidget {
  @override
  State<Accuracy> createState() => _Accuracy();
}
class _Accuracy extends State<Accuracy>{
  var taskaction = ["Correct location", "Wrong location","Not found"];
  var froud = ["No", "Yes"];
  String? selectedaction;
  String? selectedfroud;
  List? taskgoal = [];


  froudAction(String? value) {
    setState(() {
      selectedfroud = value;
    });
  }
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        taskgoal = filteredTasks;
        print(taskgoal);
      });

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }


    _YesUpdate(id, subtask);
  }
  _YesUpdate(int doc,int id) async {


    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":34,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":67,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });

  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              labelText: "Did we find the location?",
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Did we find the location?",
            ),
            items: taskaction.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: taskAction),
        SizedBox(height: 10,),
        if(selectedaction == 'Correct location')
          Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
            ],
          ),

        if(selectedaction == 'Wrong location' )
          Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Does it relate with froud?",
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Does it relate with froud?",
                  ),
                  items: froud.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: froudAction),
              if(selectedfroud == 'No')
                TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColor.mycolor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Reason for moving',
                    )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)
                ),
                onPressed:(){
                  //_getDocuments();
                  _YesUpdate(67,34);

                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: Text("No"), ),
              SizedBox(height: 10,),
              if(selectedfroud == 'Yes')
                Column(
                  children: [
                    Text("Please record the case to the froud app"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)
                      ),
                      onPressed:(){
                        //_getDocuments();
                        _YesUpdate(32,45);

                        /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                      }, child: Text("No"), )
                  ],
                )

            ],
          ),
          SizedBox(height: 10,),
        if(selectedaction == 'Not found' )
          Column(
            children: [
              Text("Please rise a froud case")
            ],
          ),


      ],
    );
  }

}

class Repo extends StatefulWidget {
  final docid;
  final id;
  Repo({required this.docid,required this.id});
  @override
  State<Repo> createState() => _Repo();
}
class _Repo extends State<Repo>{

  String _data = '';
  _YesUpdate(String doc,String id) async {
    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });

  }
  _NoUpdate(String doc,String id) async {
    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });

  }
  @override
  void initState() {

    super.initState();
  }
  String? selectedSubTask;
  String? selectedaction;
  TextEditingController feedbackController = TextEditingController();
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to visit customer?",
              hint: "Did you manage to visit customer?",
              items: taskaction,
              onChanged: taskAction),
          SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.docid);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: Text("No"), )
              ],
            ),
          if (selectedaction == 'Yes')

            Column(
                children: [
                  AppDropDown(
                      disable: false,
                      label: 'Select user',
                      hint: 'Select a user',
                      items: [_data],
                      onChanged: (value){

                      }),
                  SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.camera_alt),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.location_on),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _YesUpdate(widget.id,widget.docid);
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: Text("Update Yes"), )
                ])
        ],
      ),
    );
  }

}
class TVcostomers extends StatefulWidget {
  final docid;
  final id;
  TVcostomers({required this.docid,required this.id});
  @override
  State<TVcostomers> createState() => _TVcostomers();
}
class _TVcostomers extends State<TVcostomers>{
  String? selectedaction;
  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        taskgoal = filteredTasks;
        print(taskgoal);
      });

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }


    _YesUpdate(id, subtask);
  }
  _YesUpdate(int doc,int id) async {


    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : ""
    };
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });

  }
  var taskaction = ["No", "Yes"];
  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              labelText: "Did you get the customers, Yes?",
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Did you get the customers, Yes?",
            ),
            items: taskaction.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: taskAction),
        SizedBox(height: 10,),
        if(selectedaction == 'Yes')
          Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)
                ),
                onPressed:(){
                  //_getDocuments();
                  _YesUpdate(widget.id,widget.docid);

                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: Text("No"), )
            ],
          ),
        SizedBox(height: 10,),
        if(selectedaction == 'No' )
          Column(
            children: [
              Text("Please rise a froud case"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)
                ),
                onPressed:(){
                  //_getDocuments();
                  _NoUpdate(widget.id,widget.docid);

                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: Text("No"), )
            ],
          ),


      ],
    );
  }

}

class Campaign extends StatefulWidget {
  @override
  State<Campaign> createState() => _Campaign();
}
class _Campaign extends State<Campaign>{
  String? selectedaction;
  var taskaction = ["I Will do by myself", "I will assign someone"];
  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              labelText: "Did you get the customers?",
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Did you get the customers, Yes?",
            ),
            items: taskaction.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: taskAction),
        SizedBox(height: 10,),
        if(selectedaction == 'I Will do by myself')
          Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
            ],
          ),
        SizedBox(height: 10,),
        if(selectedaction == 'I will assign someone' )
          Column(
            children: [
              Text("Please rise a froud case")
            ],
          ),


      ],
    );
  }

}

class TableMeeting extends StatefulWidget {
  @override
  State<TableMeeting> createState() => _TableMeeting();
}
class _TableMeeting extends State<TableMeeting>{
  String? selectedaction;
  var taskaction = ["No", "Yes"];
  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              labelText: "Did you get the customers?",
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Did you get the customers, Yes?",
            ),
            items: taskaction.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: taskAction),
        SizedBox(height: 10,),
        if(selectedaction == 'I Will do by myself')
          Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
            ],
          ),
        SizedBox(height: 10,),
        if(selectedaction == 'I will assign someone' )
          Column(
            children: [
              Text("Please rise a froud case")
            ],
          ),


      ],
    );
  }

}

class WorkUpdate extends StatefulWidget {
  final docid;
  final id;
  WorkUpdate({required this.docid,required this.id});
  @override
  State<WorkUpdate> createState() => _WorkUpdate();
}
class _WorkUpdate extends State<WorkUpdate> {

  String _data = '';
  _YesUpdate(String doc,String id) async {
    Map data = {
      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : feedbackController.text
    };
    var body = json.encode(data);
    var url = Uri.parse('https://2d1e-41-216-166-170.ngrok-free.app/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(feedbackController.text);

  }
  _NoUpdate(String doc,String id){
    print(feedbackController.text);


  }

  @override
  void initState() {

    super.initState();
  }
  String? selectedSubTask;
  String? selectedaction;
  TextEditingController feedbackController = TextEditingController();
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to work with the Agent?",
              hint: "Did you manage to work with the Agent?",
              items: taskaction,
              onChanged: taskAction),
          SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.docid);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: Text("No"), )
              ],
            ),
          if (selectedaction == 'Yes')

            Column(
                children: [
                  AppDropDown(
                      disable: false,
                      label: 'Select user',
                      hint: 'Select a user',
                      items: [_data],
                      onChanged: (value){

                      }),
                  SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.camera_alt),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.location_on),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _YesUpdate(widget.id,widget.docid);
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: Text("Update Yes"), )
                ])
        ],
      ),
    );
  }
}


class Agent extends StatefulWidget {
  final docid;
  final id;
  Agent({required this.docid,required this.id});
  @override
  State<Agent> createState() => _Agent();
}
class _Agent extends State<Agent> {
  String _data = '';
  File? imageFile;

  void getImage() async{
    final file  = await ImagePicker().pickImage(source: ImageSource.camera);
    if(file?.path != null){
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }
  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoals');
    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",

    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['task'] == id)
          .toList();
      setState(() {
        taskgoal = filteredTasks;
        print(taskgoal);
      });

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }


    _YesUpdate(id, subtask);
  }
  _YesUpdate(int doc,int id) async {


    Map data = {

      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : feedbackController.text
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print('nne');
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "sub_task":"Visits Tampering Home 400",
      "taskgoal_id":widget.id,
      "report_title":"Visits Tampering Home 400",
      "country": "Tanzania",
      "report_area": "Mwanza",
      "report_region": "North",
      "report_country": "East",
      "submited_by":"test",
      "report_agent_found_yes_no" : "Yes",
      "report_customer_found_fraud_case" :"No",
      "report_priority" :"Low",
      "report_status" : "Complete",
      "report_details" : feedbackController.text
    };
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    print(feedbackController.text);

  }
  @override
  void initState() {

    super.initState();
  }
  String? selectedSubTask;
  String? selectedaction;
  TextEditingController feedbackController = TextEditingController();
  var taskaction = ["No", "Yes"];
  onSubTaskChanged(String? value) {
    setState(() {
      selectedSubTask = value;
    });
  }

  taskAction(String? value) {
    setState(() {
      selectedaction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to work with the Agent?",
              hint: "Did you manage to work with the Agent?",
              items: taskaction,
              onChanged: taskAction),
          SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mycolor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.docid);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: Text("No"), )
              ],
            ),
          if (selectedaction == 'Yes')

            Column(
                children: [
                  AppDropDown(
                      disable: false,
                      label: 'Select user',
                      hint: 'Select a user',
                      items: [_data],
                      onChanged: (value){

                      }),
                  SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed:()=>getImage(),
                      icon: const Icon(Icons.camera),
                      label: const Text("Capture Image"),

                    ),
                  ),
                  Container( //show captured image
                    padding: const EdgeInsets.all(30),
                    child: imageFile == null?
                    const Text("No image captured"):
                    Image.file(File(imageFile!.path), height: 300,),
                    //display captured image
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.location_on),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _getAction(widget.id,widget.docid);
                      print("{doc id}");
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: Text("Update Yes"), )
                ])
        ],
      ),
    );
  }
}