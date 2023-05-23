import 'dart:ffi';

import 'package:fieldapp_rcm/http_online.dart';
import 'package:fieldapp_rcm/routing/bottom_nav.dart';
import 'package:fieldapp_rcm/task/collection.dart';
import 'package:fieldapp_rcm/task/pilot_process.dart';
import 'package:fieldapp_rcm/task/portfolio.dart';
import 'package:fieldapp_rcm/task/team.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'task/customer.dart';

class StepAddTask extends StatefulWidget {
  @override
  _StepAddTaskState createState() => _StepAddTaskState();
}

class _StepAddTaskState extends State<StepAddTask> {
 late String _region;
  Future<void> _getRegion() async {

    var  query = await firestore.collection('Users').where("UID", isEqualTo: currentUser).get();
    var snapshot = query.docs[0];
    var data = snapshot.data();
    setState(() {
      _region = data['Region'];
    });
    return ;
  }
  var caseselected;
  var customerselected;
  List<TextEditingController> _controllers = [];
  formPost() async {
    CollectionReference task = firestore.collection("task");
    var currentUser = FirebaseAuth.instance.currentUser;
    await task.add({
      "task_title": selectedTask,
      "User UID": currentUser?.uid,
      "sub_task": selectedSubTask,
      "task_description": _text.text.toString(),
      "process_audit":"",
      "task_start_date":  DateTime.now(),
      "task_end_date": DateTime.now(),
      "task_status": "Pending",
      "task_with": agentselected,
      "task_area": areaselected.toString(),
      "task_region": regionselected,
      "submited_by":currentUser?.displayName ,
      "case_name":caseselected,
      "Customer": customerselected,
      "submited_role": null,
      "task_country": "Tanzania",
      "priority": priority,
      "timestamp": DateTime.now(),
      "is_approved": "pending"
    }
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavPage()),
    );

    /* Map data = {
        'task_title': _myActivitiesResult.toString().replaceAll("(^\\[|\\]", ""),
        'sub_task': _subtaskResult,
        'task_region': _regionResult,
        'task_area': _areaResult,
        'priority': priority.toString(),
        'task_with': _userRoleResult,
        'task_description': 'Testing',
        'task_start_date': '2022-11-04',
        'task_end_date': '2022-11-09',
        'task_status': 'Pending',
        'submited_by': 'Dennis',
        'timestamp': '23454',
        'is_approved': 'No'
      };
      var body = json.encode(data);
      var url = Uri.parse('https://sun-kingfieldapp.herokuapp.com/api/create');
      http.Response response = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
      });
      print(response.body);*/
  }


  late String _myActivitiesResult;
  bool _validate = false;
  List? _myActivities;
  late bool laststep;
  final _text = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _getRegion();
    _myActivities = [];
    _myActivitiesResult = '';
    laststep = false;
  }

  _saveForm() {
    var form = _formKey.currentState!;
    if (form.validate()) {
      print(_myActivities);
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
        items1 = _myActivities!.toList();
        int? num = _myActivities?.toList().length;
        print(items1?.length);
        for (int i = 0; i < items1!.toString().length; i++) {
          print(items1?[i]);
        }
      });
    }
  }

  int _currentStep = 0;
  late String selectedTask='';
  late String selectedSubTask='';
  late String regionselected ='';
  late String areaselected ='';
  late String agentselected= '';
  late String priority = '';
  late String target;
  List? items1;
  List<String> priortySelected = [];
  StepperType stepperType = StepperType.vertical;
  bool _isSelected = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    List<Step> stepList() => [
      /*Step(title: Text('Location'), content: TaskForm(
        onregionselected: (value) {
          regionselected = value;
        },
        onareaselected: (value) {
          areaselected = value;
        },) ),*/
      Step(title: Text('Task'),content: TaskForm(
    onregionselected: (value) {
    regionselected = value;
    },
    onareaselected: (value) {
    areaselected = value!;
    },
        onTask: (value) {
          selectedTask = value;
        },
        taskResult: (value){
          _myActivities = value;
        },
        onSubTask: (value) {
          selectedSubTask = value;
        },
      ),),

      Step(title: Text('Confirm details'),content: Column(
        children: [
          Text(regionselected??""),
          Text(areaselected??''),
          Text(selectedTask??''),
          Text(selectedSubTask??''),
          Text(_myActivities.toString()),
          Text(target??'')

        ],
      ))
    ];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        TaskForm(
          onregionselected: (value) {
            regionselected = value;
          },
          onareaselected: (value) {
            areaselected = value!;
          },
          onTask: (value) {
            selectedTask = value;
          },
          taskResult: (value){
            _myActivities = value;
          },
          onSubTask: (value) {
            selectedSubTask = value;
          },
        ),
        ElevatedButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActionScreen(
                        customers: _myActivities, onChange:
                          (value) {
                      }, Area: areaselected,
                        region: regionselected,
                        task: selectedTask,
                        subtask: selectedSubTask,)));
            }, child: Text('Next'))
      ],
    );
  }


}
/*
class LocationForm extends StatefulWidget {
  final Function(String) onregionselected;
  final Function(String) onareaselected;
  const LocationForm({super.key, required this.onregionselected,required this.onareaselected});

  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {


  String? regionselected;
  String? areaselected;
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    return Column(children: <Widget>[
      SizedBox(
        height: 10,
      ),
      StreamBuilder(
          stream: firestore
              .collection("Users")
              .where('UID', isEqualTo: currentUser!.uid)
              .get()
              .asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            List<String> region = List.generate(snapshot.data!.size, (index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return data['Region'].toString();
            }).toSet().toList();
            if (snapshot.hasData) {
              return AppDropDown(
                label: 'Region',
                hint: 'Select Region',
                items: region ?? [],
                onChanged: (String value) {
                  widget.onregionselected(value!);
                },
                onSave: (value) {
                  widget.onregionselected(value!);
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
      SizedBox(
        height: 10,
      ),
      StreamBuilder(
          stream: firestore
              .collection("TZ_agent_welcome_call")
              .where('Region', isEqualTo: "Lake Zone")
              .get()
              .asStream(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<String> area = List.generate(snapshot.data!.size, (index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                return data['Area'].toString();
              }).toSet().toList();
              return AppDropDown(
                label: 'Area',
                hint: 'Select Area',
                items: area ?? [],
                onChanged: (String value) {
                  widget.onareaselected(value!);
                },
                onSave: (value) {
                  widget.onareaselected(value!);
                },
              );
            }
            return CircularProgressIndicator();
          }),
    ]);
  }
}
*/
class TaskForm extends StatefulWidget {
  final Function(String) onTask;
  final Function(String) onSubTask;
  final Function(List?) taskResult;
  final Function(String) onregionselected;
  final Function(String?) onareaselected;

  TaskForm({required this.onregionselected, required this.onareaselected,required this.onTask,required this.onSubTask, required this.taskResult});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  String _region ="";
  initState() {
    // at the beginning, all users are shown

  // _getRegion();
   //_getArea();
    super.initState();
  }
  void _getRegion() async {

    var  query = await firestore.collection('Users').where("UID", isEqualTo: currentUser).get();
    var snapshot = query.docs[0];
    var data = snapshot.data();
    setState(() {
      _region = data['Region'];

    });
    return ;
  }
  List<String> _area = [];
  Future<void> _getArea() async {

    QuerySnapshot querySnapshot =
    await firestore.collection("TZ_agent_welcome_call")
        .where("Region", isEqualTo:await _region)
        .get();
    setState(() {
      _area =querySnapshot.docs.map((doc) => doc["Area"].toString()).toSet().toList();
      print(_area);

    });
  }
  String? selectedTask;

  String? selectedSubTask;

  bool _isSelected = false;
  onTaskChanged(value) {
    setState(() {
      print(value);
      selectedTask= value;
      _isSelected = true;
    });
  }

  late Map<String, List<String>> dataTask = {
    'Portfolio Quality': portfolio,
    'Team Management': team,
    'Collection Drive': collection,
    'Pilot/Process Management': pilot,
    'Customer Management': customer,
  };


  final List<String> Task = [
    'Portfolio Quality',
    'Team Management',
    'Collection Drive',
    'Pilot/Process Management',
    'Customer Management',
  ];

  final List<String> portfolio = [
    'Visiting unreachable welcome call clients',
    'Work with the Agents with low welcome calls to improve',
    'Change a red zone CSAT area to orange',
    'Attend to Fraud Cases',
    'Visit at-risk accounts',
    'Visits FPD/SPDs',
    'Other'
  ];

  final List<String> customer = [
    'Visiting of issues raised',
    'Repossession of customers needing repossession',
    'Look at the number of replacements pending at the shops',
    'Look at the number of repossession pending at the shops',
    'Other - Please Expound'
  ];

  final List<String> pilot = [
    'Conduct the process audit',
    'Conduct a pilot audit',
    'Testing the GPS accuracy of units submitted',
    'Reselling of repossessed units',
    'Repossessing qualified units for Repo and Resale',
    'Increase the Kazi Visit Percentage',
    'Other'
  ];

  final List<String> collection = [
    'Field Visits with low-performing Agents in Collection Score',
    'Repossession of accounts above 180',
    'Visits Tampering Home 400',
    'Work with restricted Agents',
    'Calling of special book',
    'Sending SMS to clients',
    'Table Meeting/ Collection Sensitization Training',
    'Others'
  ];

  final List<String> team = [
    'Assist a team member to improve the completion rate',
    'Raise a reminder to a team member',
    'Raise a warning to a team member',
    'Raise a new task to a team member',
    'Inform the team member of your next visit to his area, and planning needed',
    'Other'
  ];
  List _myActivities = [];
  String? selectedarea;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Column(
        children: <Widget>[
          AppDropDown(
            disable: true,
              label: "Region",
              hint: "Region",
              items: ["Region 1", "Region 2"],
              onChanged: (value){
                widget.onregionselected(value!);
                _getArea();
              }),
          SizedBox(
            height: 8,
          ),
          AppDropDown(
            disable: true,
              label: "Area",
              hint: "Area",
              items: ["Area 1"],
              onChanged: (value){
              setState(() {
                selectedarea = value;
              });
                widget.onareaselected(value!);
              }),
          SizedBox(
            height: 8,
          ),

          DropdownButtonFormField<String?>(
            value: selectedTask,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Task Title",
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.white),
              hintText: "Task Title",
            ),
            items: dataTask.keys.map((e) {
              return DropdownMenuItem<String?>(
                value: e,
                child: Text(
                  '$e',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value){
              widget.onTask(value!);
              setState(() {
                selectedTask = value;

              });
              widget.onTask(value!);},
            onSaved:(value) {
              widget.onTask(value!);

            } ,
          ),
          SizedBox(
            height: 8,
          ),
          DropdownButtonFormField<String?>(
            value: selectedSubTask,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Sub Task",
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Name",
            ),
            items: (dataTask[selectedTask] ?? []).map((e) {
              return DropdownMenuItem<String?>(
                value: e,
                child: Text(
                  '$e',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubTask = value;
              });
              widget.onSubTask!(value!);},
            onSaved: (value) {widget.onSubTask!(value!);},
          ),
          if (selectedTask ==  'Portfolio Quality' && selectedSubTask != null)
            Portfolio(
              data: [],
              area: selectedarea,
                subtask: selectedSubTask,
                onSave: (value) {
                  widget.taskResult(value);
                })
          else if (
          selectedTask == 'Team Management')
            Team(
              data: [],
              area: selectedarea,
              subtask: selectedSubTask,
              onSave: (value) {
                widget.taskResult(value);
              },)
          else if (selectedTask == 'Collection Drive')
              Collection(
                data: [],
                onSave: (value) {
                  widget.taskResult(value);
                },
                subtask: selectedSubTask??'',
                area: selectedarea,
              )
            else if (selectedTask == 'Pilot/Process Management')
                Pilot(
                  data: [],
                  onSave: (value) {
                    widget.taskResult(value);
                  },
                  subtask: selectedSubTask??'',
                  area: selectedarea,
                )
              else if (selectedTask == 'Customer Management')
                  CustomerManagement(
                    data: [],
                    onSave: (value) {
                      widget.taskResult(value);
                    },
                    subtask: selectedSubTask??'',
                    area: selectedarea,)
        ],
      ),
    );
  }
}
