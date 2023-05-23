import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Visiting extends StatefulWidget {
  final docid;
  Visiting({required this.docid});
  @override
  State<Visiting> createState() => _Visiting();
}

class _Visiting extends State<Visiting> {
  @override
  void initState() {
    _getDocuments();
    super.initState();
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> _data = [];
  List<DocumentSnapshot> _result = [];
  Future<void> _getDocuments() async {

    QuerySnapshot querySnapshot =
    await firestore.collection("task").doc(widget.docid).collection('action').get();
    setState(() {
      _result = querySnapshot.docs;
      _data = _result.map((doc) => doc['Customer'].toString()).toSet().toList();
      print(_data.length);

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
          if (selectedaction == 'Yes')

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
            print("endif");
          }, child: Text("Dennis"))
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _data = '';
  List<DocumentSnapshot> _result = [];
  Future<void> _getDocuments() async {
    final documentReference = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.id)
        .collection('action')
        .doc(widget.docid);
    final documentSnapshot = await documentReference.get();


    /*QuerySnapshot querySnapshot =
    await firestore.collection("task").doc(widget.id).collection('action').doc(widget.docid).get();*/
    setState(() {
      //_result = querySnapshot.docs;
      _data =documentSnapshot['Customer'];
      print(_data);

    });
  }
  @override
  void initState() {
    _getDocuments();
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
              ],
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
              print("demm");
              /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    FormScreenUpdate()));*/
            }, child: Text("Update"), )
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
        Icon(Icons.attach_file)
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _data = '';
  List<DocumentSnapshot> _result = [];
  _YesUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"Yes",
      "date":DateTime.now()
    });

  }
  _NoUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"No",
      "date":DateTime.now()
    });

  }
  Future<void> _getDocuments() async {
    final documentReference = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.id)
        .collection('action')
        .doc(widget.docid);
    final documentSnapshot = await documentReference.get();

    setState(() {
      //_result = querySnapshot.docs;
      _data =documentSnapshot['Customer'];
      print(_data);

    });
  }
  @override
  void initState() {
    _getDocuments();
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
          Text(widget.id),
          SizedBox(height: 10,),
          Text(widget.docid),
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

  froudAction(String? value) {
    setState(() {
      selectedfroud = value;
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
              SizedBox(height: 10,),
              if(selectedfroud == 'Yes')
                Text("Please record the case to the froud app"),
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _data = '';
  List<DocumentSnapshot> _result = [];
  _YesUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"Yes",
      "date":DateTime.now()
    });

  }
  _NoUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"No",
      "date":DateTime.now()
    });

  }
  Future<void> _getDocuments() async {
    final documentReference = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.id)
        .collection('action')
        .doc(widget.docid);
    final documentSnapshot = await documentReference.get();

    setState(() {
      //_result = querySnapshot.docs;
      _data =documentSnapshot['Customer'];
      print(_data);

    });
  }
  @override
  void initState() {
    _getDocuments();
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
          Text(widget.id),
          SizedBox(height: 10,),
          Text(widget.docid),
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
  @override
  State<TVcostomers> createState() => _TVcostomers();
}
class _TVcostomers extends State<TVcostomers>{
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
            ],
          ),
        SizedBox(height: 10,),
        if(selectedaction == 'No' )
          Column(
            children: [
              Text("Please rise a froud case")
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _data = '';
  List<DocumentSnapshot> _result = [];
  _YesUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"Yes",
      "date":DateTime.now()
    });

  }
  _NoUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"No",
      "date":DateTime.now()
    });

  }
  Future<void> _getDocuments() async {
    final documentReference = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.id)
        .collection('action')
        .doc(widget.docid);
    final documentSnapshot = await documentReference.get();

    setState(() {
      //_result = querySnapshot.docs;
      _data =documentSnapshot['Customer'];
      print(_data);

    });
  }
  @override
  void initState() {
    _getDocuments();
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
          Text(widget.id),
          SizedBox(height: 10,),
          Text(widget.docid),
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _data = '';
  List<DocumentSnapshot> _result = [];
  _YesUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"Yes",
      "date":DateTime.now()
    });

  }
  _NoUpdate(String doc,String id){
    print(feedbackController.text);
    DocumentReference task = firestore.collection("task").doc(doc);
    DocumentReference subCollectionReference = task.collection('action').doc(id);
    subCollectionReference.update({
      "Feedback":feedbackController.text,
      "Status":"Complete",
      "Get user":"No",
      "date":DateTime.now()
    });

  }
  Future<void> _getDocuments() async {
    final documentReference = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.id)
        .collection('action')
        .doc(widget.docid);
    final documentSnapshot = await documentReference.get();

    setState(() {
      //_result = querySnapshot.docs;
      _data =documentSnapshot['Customer'];
      print(_data);

    });
  }
  @override
  void initState() {
    _getDocuments();
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
          Text(widget.id),
          SizedBox(height: 10,),
          Text(widget.docid),
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
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'what do you achieve in percent',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final regex = RegExp(r'^\d+\.?\d{0,2}$');
                        if (regex.hasMatch(newValue.text)) {
                          return newValue;
                        }
                        return oldValue;
                      })
                    ],
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