import 'dart:convert';

import 'package:fieldapp_rcm/routing/bottom_nav.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'models/db.dart';

class Visiting extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;

  const Visiting({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<Visiting> createState() => _Visiting();
}

class _Visiting extends State<Visiting> {
  @override
  void initState() {
    super.initState();
  }
  final List<String> _data = [];
  final List<DocumentSnapshot> _result = [];
  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('${AppUrl.baseUrl}/taskgoals');
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
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );

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
          const SizedBox(height: 10,),
          DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: "Did we find the right customer?",
                border: const OutlineInputBorder(),
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
          const SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                const Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(onPressed:(){

                }, child: const Text("Update"))

              ],
            ),


          if (selectedaction == 'Yes')
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Icon(Icons.camera_alt),
                const SizedBox(
                  height: 10,
                ),
                const Icon(Icons.location_on),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed:(){

                }, child: const Text("Update"))
              ],
            ),


        ],
      ),
    );
  }
}

//Work With agent
class Work extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const Work({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<Work> createState() => _Work();
}

class _Work extends State<Work> {

  final String _data = '';
  final List<DocumentSnapshot> _result = [];
  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('${AppUrl.baseUrl}/taskgoals');
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
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );
    print(response.body);

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
          const SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
          Column(
            children: [
              const Text("If it related to frud please rise it through fraud App"),
              TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 1.0),
                    ),
                    labelText: 'Additional details',
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)
                ),
                onPressed:(){
                  print("demm");
                  _NoUpdate(23, 23);
                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: const Text("Update"), )
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
                const SizedBox(height: 10,),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'More Feedback',
                  ),

                ),
                const SizedBox(
                  height: 10,
                ),
                const Icon(Icons.camera_alt),
                const SizedBox(
                  height: 10,
                ),
                const Icon(Icons.location_on),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    _YesUpdate(32, 23);
                    print("demm");
                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: const Text("Update"), )
              ],
            ),



        ],
      ),
    );
  }
}

//Change a red zone CSAT area to orange
class RedZone extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const RedZone({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
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
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Issues highlighted',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            maxLines: 5,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Additional details',
            )),




        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

//Attend to Fraud Cases
class Fraud extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const Fraud({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<Fraud> createState() => _Fraud();
}

class _Fraud extends State<Fraud> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Issues highlighted',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            maxLines: 5,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Feedback from the client',
            )),




        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Audity extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const Audity({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
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
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: AppColor.appColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Takeaway',
            )),
        const SizedBox(height: 10,),
        TextFormField(
            maxLines: 5,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: AppColor.appColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: 'Recommendation',
            )),
        const SizedBox(height: 10,),
        const Icon(Icons.attach_file),

      ],
    );
  }

}
class FieldVisit extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const FieldVisit({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<FieldVisit> createState() => _FieldVisit();
}
class _FieldVisit extends State<FieldVisit> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String _data = '';
  final List<DocumentSnapshot> _result = [];
  _YesUpdate(String doc,String id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );

  }
  _NoUpdate(String doc,String id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );


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
          const SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to work with the Agent?",
              hint: "Did you manage to work with the Agent?",
              items: taskaction,
              onChanged: taskAction),
          const SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                const Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.sub);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: const Text("No"), )
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
                  const SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.camera_alt),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.location_on),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _YesUpdate(widget.id,widget.sub);
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: const Text("Update Yes"), )
                ])
        ],
      ),
    );
  }
}

class Accuracy extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const Accuracy({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
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
    var url = Uri.parse('${AppUrl.baseUrl}/taskgoals');
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


    Map data = { "report_title": "Visits Tampering Home 400",
      "taskgoal_id": doc, "sub_task": "Visits Tampering Home 400",
      "report_details": "test",
      "report_area": "Mwanza", "report_region":
      "North", "report_country": "('East',)",
      "report_gps_coordinate_latitude": null, "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": null, "report_customer_found_fraud_case": "No",
      "report_priority": "Low", "report_status": "Complete",
      "report_amount_collected": null, "report_customer_account_number": null,
      "report_customer_count_visited": null, "report_agent_target": null,
      "report_agent_found_yes_no": "Yes", "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null, "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null, "report_count_agent_visited": null, "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null, "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null, "report_visited_fraud_amount": null, "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null, "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null, "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null, "report_previous_customer_angaza_ID": null, "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null, "report_previous_customer_phone_number": null, "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null, "report_new_customer_phone_number": null, "report_repo_location": null, "report_repo_product": null,
      "report_repo_reselling_agent": null, "report_repo_unit_is_complete": null, "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null, "report_calling_criteria": null, "report_who_calling": null,
      "report_calling_reason_for_assigning": null, "report_calling_call_count": null, "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null, "report_table_meetings_AOC": null, "team_assist_completion_rate": false, "team_raise_reminder": false,
      "team_raise_warning": false, "team_raise_new_task": false, "team_inform_next_visit": false, "team_who": null, "team_when": null,
      "headline": null, "submited_by": "('test',)", "timestamp": "2023-06-26T06:04:50.663Z"};
    var body = json.encode(data);
    var url = Uri.parse('h${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);



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
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
              border: const OutlineInputBorder(),
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
        const SizedBox(height: 10,),
        if(selectedaction == 'Correct location')
          const Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
            ],
          ),

        if(selectedaction == 'Wrong location' )
          Column(
            children: [
              const Icon(Icons.camera_alt_rounded),
              const Icon(Icons.location_on),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Does it relate with froud?",
                    border: const OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColor.appColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Reason for moving',
                    )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)
                ),
                onPressed:(){
                  //_getDocuments();
                  _YesUpdate(67,34);

                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: const Text("No"), ),
              const SizedBox(height: 10,),
              if(selectedfroud == 'Yes')
                Column(
                  children: [
                    const Text("Please record the case to the froud app"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50)
                      ),
                      onPressed:(){
                        //_getDocuments();
                        _YesUpdate(32,45);

                        /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                      }, child: const Text("No"), )
                  ],
                )

            ],
          ),
          const SizedBox(height: 10,),
        if(selectedaction == 'Not found' )
          const Column(
            children: [
              Text("Please rise a froud case")
            ],
          ),


      ],
    );
  }

}

class Repo extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const Repo({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<Repo> createState() => _Repo();
}
class _Repo extends State<Repo>{
  _YesUpdate(String doc,String id) async {

    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    print(data);
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );

  }
  _NoUpdate(String doc,String id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );

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
          const SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to visit customer?",
              hint: "Did you manage to visit customer?",
              items: taskaction,
              onChanged: taskAction),
          const SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                const Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.sub);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: const Text("No"), )
              ],
            ),
          if (selectedaction == 'Yes')

            Column(
                children: [
                  AppDropDown(
                      disable: false,
                      label: 'Select user',
                      hint: 'Select a user',
                      onChanged: (value){

                      }),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.camera_alt),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.location_on),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      _YesUpdate(widget.submited_by,widget.report_area);
                      if (kDebugMode) {
                        print(widget.sub);
                      }

                      //_getDocuments();
                      //_YesUpdate(widget.id,widget.docid);
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: const Text("Update Yes"), )
                ])
        ],
      ),
    );
  }

}
class TVcostomers extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const TVcostomers({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<TVcostomers> createState() => _TVcostomers();
}
class _TVcostomers extends State<TVcostomers>{
  String? selectedaction;
  List? taskgoal = [];
  Future<void> _getAction(id,subtask) async {
    var url = Uri.parse('${AppUrl.baseUrl}/taskgoals');
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
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );
    print(response.body);


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );

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
              border: const OutlineInputBorder(),
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
        const SizedBox(height: 10,),
        if(selectedaction == 'Yes')
          Column(
            children: [
              const Icon(Icons.camera_alt_rounded),
              const Icon(Icons.location_on),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)
                ),
                onPressed:(){
                  //_getDocuments();
                  _YesUpdate(widget.id,widget.sub);

                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: const Text("No"), )
            ],
          ),
        const SizedBox(height: 10,),
        if(selectedaction == 'No' )
          Column(
            children: [
              const Text("Please rise a froud case"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)
                ),
                onPressed:(){
                  //_getDocuments();
                  _NoUpdate(widget.id,widget.sub);

                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                }, child: const Text("No"), )
            ],
          ),


      ],
    );
  }

}

class Campaign extends StatefulWidget {
  const Campaign(
      {super.key, 
        required this.sub,
        required this.id,
        required this.report_area,
        required this.report_region,
        required this.report_country,
        required this.sub_task,
        required this.submited_by,
        required this.report_title,
        required this.report_priority,
        required this.report_details,

      }
      );
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
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
              border: const OutlineInputBorder(),
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
        const SizedBox(height: 10,),
        if(selectedaction == 'I Will do by myself')
          const Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
            ],
          ),
        const SizedBox(height: 10,),
        if(selectedaction == 'I will assign someone' )
          const Column(
            children: [
              Text("Please rise a froud case")
            ],
          ),


      ],
    );
  }

}

class TableMeeting extends StatefulWidget {
  const TableMeeting(
      {super.key, 
        required this.sub,
        required this.id,
        required this.report_area,
        required this.report_region,
        required this.report_country,
        required this.sub_task,
        required this.submited_by,
        required this.report_title,
        required this.report_priority,
        required this.report_details,

      }
      );
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
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
              border: const OutlineInputBorder(),
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
        const SizedBox(height: 10,),
        if(selectedaction == 'I Will do by myself')
          const Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.location_on),
            ],
          ),
        const SizedBox(height: 10,),
        if(selectedaction == 'I will assign someone' )
          const Column(
            children: [
              Text("Please rise a froud case")
            ],
          ),


      ],
    );
  }

}

class WorkUpdate extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const WorkUpdate({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<WorkUpdate> createState() => _WorkUpdate();
}
class _WorkUpdate extends State<WorkUpdate> {

  _YesUpdate(String doc,String id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );


  }
  _NoUpdate(String doc,String id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );

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
          const SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to work with the Agent?",
              hint: "Did you manage to work with the Agent?",
              items: taskaction,
              onChanged: taskAction),
          const SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                const Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.sub_task);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: const Text("No"), )
              ],
            ),
          if (selectedaction == 'Yes')

            Column(
                children: [
                  AppDropDown(
                      disable: false,
                      label: 'Select user',
                      hint: 'Select a user',
                      items: const ["_data"],
                      onChanged: (value){

                      }),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.camera_alt),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.location_on),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _YesUpdate(widget.id,widget.sub_task);
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: const Text("Update Yes"), )
                ])
        ],
      ),
    );
  }
}


class Agent extends StatefulWidget {
  final sub;
  final id;
  final report_area;
  final report_region;
  final report_country;
  final sub_task;
  final submited_by;
  final report_title;
  final report_priority;
  final report_details;
  const Agent({super.key, 
    required this.sub,
    required this.id,
    required this.report_area,
    required this.report_region,
    required this.report_country,
    required this.sub_task,
    required this.submited_by,
    required this.report_title,
    required this.report_priority,
    required this.report_details,

  });
  @override
  State<Agent> createState() => _Agent();
}
class _Agent extends State<Agent> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String _data = '';
  File? imageFile;
  final List<DocumentSnapshot> _result = [];
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
    var url = Uri.parse('${AppUrl.baseUrl}/taskgoals');
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
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );


  }
  _NoUpdate(int doc,int id) async {
    Map data = {
      "report_title":widget.report_title,
      "taskgoal_id": 23,
      "sub_task":widget.sub_task,
      "report_details": widget.report_details,
      "report_area": widget.report_area,
      "report_region": widget.report_region,
      "report_country": widget.report_region,
      "report_gps_coordinate_latitude": null,
      "report_gps_coordinate_longitude": null,
      "report_customer_found_yes_no": selectedaction,
      "report_customer_found_fraud_case": selectedaction,
      "report_priority": "Low",
      "report_status": "Complete",
      "report_amount_collected": null,
      "report_customer_account_number": null,
      "report_customer_count_visited": null,
      "report_agent_target": null,
      "report_agent_found_yes_no": selectedaction,
      "report_agent_angaza_Id": null,
      "report_agent_found_yes_issues": null,
      "report_agent_found_yes_issues_call_with_cls": null,
      "report_agent_found_no_chs": null,
      "report_count_agent_visited": null,
      "report_issue_to_be_reolved_area": null,
      "report_resolution_to_be_reolved_area": null,
      "report_count_fraud_visits": null,
      "report_feedback_fraud_visits": null,
      "report_visited_fraud_amount": null,
      "report_process_list": null,
      "report_audit_report": null, "report_key_takeaways": null,
      "report_recommendation": null, "report_pilots": null,
      "report_coordinate_lamp_found_yes_no": null,
      "report_coordinate_lamp_found_yes_no_reasons_for_moving": null,
      "report_role_submitting": null,
      "report_previous_customer_angaza_ID": null,
      "report_previous_customer_account_number": null,
      "report_previous_customer_customer_name": null,
      "report_previous_customer_phone_number": null,
      "report_new_customer_account_number": null,
      "report_new_customer_customer_name": null,
      "report_new_customer_phone_number": null,
      "report_repo_location": null,
      "report_repo_product": null,
      "report_repo_reselling_agent": null,
      "report_repo_unit_is_complete": null,
      "report_repo_customer_2_weeks_pay": null,
      "report_repo_customer_aware_cond": null,
      "report_calling_criteria": null,
      "report_who_calling": null,
      "report_calling_reason_for_assigning": null,
      "report_calling_call_count": null,
      "report_calling_amount_after_5_days": null,
      "report_table_meetings_done": null,
      "report_table_meetings_AOC": null,
      "team_assist_completion_rate": false,
      "team_raise_reminder": false,
      "team_raise_warning": false,
      "team_raise_new_task": false,
      "team_inform_next_visit": false,
      "team_who": null,
      "team_when": null,
      "headline": null,
      "submited_by": widget.submited_by,};
    print('nne');
    var body = json.encode(data);
    var url = Uri.parse('${AppUrl.baseUrl}/report-create/');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    const snackBar = SnackBar(
      content: Text('Report Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(),
      ),
    );
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
          const SizedBox(height: 10,),
          AppDropDown(
              disable: false,
              label: "Did you manage to work with the Agent?",
              hint: "Did you manage to work with the Agent?",
              items: taskaction,
              onChanged: taskAction),
          const SizedBox(
            height: 10,
          ),
          if (selectedaction == 'No')
            Column(
              children: [
                const Text("If it related to frud please rise it through fraud App"),
                TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      labelText: 'Additional details',
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)
                  ),
                  onPressed:(){
                    //_getDocuments();
                    _NoUpdate(widget.id,widget.sub);

                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                  }, child: const Text("No"), )
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
                  const SizedBox(height: 10,),
                  TextField(
                    controller: feedbackController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'More Feedback',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.location_on),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)
                    ),
                    onPressed:(){
                      //_getDocuments();
                      _getAction(widget.id,widget.sub);
                      print("{doc id}");
                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
                    }, child: const Text("Update Yes"), )
                ])
        ],
      ),
    );
  }
}