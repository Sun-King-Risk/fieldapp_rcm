import 'dart:convert';

import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widget/drop_down.dart';
import 'customer_vist.dart';

class CProfile extends StatefulWidget {
  final String id;
  final angaza;
  const CProfile({Key? key, required this.id,required this.angaza}) : super(key: key);

  @override
  CProfileState createState() => CProfileState();

}

class CProfileState extends State<CProfile> {
  var fnumberupdate;
  var cmnumberupdate;
  var number1update;
  var name1update;
  var calltypeupdate;
  var timedateupdate;
  var duration1update;
  var accidupdate;
  var simnameupdate;
  String? Status;
  String? Area;
  void callLogs(String docid,String feedback,String angaza) async {
    String _docid = docid;

    Iterable<CallLogEntry> entries = await CallLog.get();
    fnumberupdate = entries.elementAt(0).formattedNumber;
    cmnumberupdate = entries.elementAt(0).cachedMatchedNumber;
    number1update = entries.elementAt(0).number;
    name1update = entries.elementAt(0).name;
    calltypeupdate = entries.elementAt(0).callType;
    timedateupdate = entries.elementAt(0).timestamp;
    duration1update = entries.elementAt(0).duration;
    accidupdate = entries.elementAt(0).phoneAccountId;
    simnameupdate = entries.elementAt(0).simDisplayName;


    if (duration1update >= 30) {
      CollectionReference newCalling = firestore.collection("new_calling");
      await newCalling.doc(_docid).update({
        'Duration': duration1update,
        'ACE Name': currentUser?.displayName,
        "User UID": currentUser?.uid,
        "date": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        "Task Type": "Call",
        "Status": "Complete",
        "Promise date": dateInputController.text,
      });
      CollectionReference feedBack = firestore.collection("FeedBack");
      await feedBack.add({
        "Angaza ID":angaza,
        "Duration": duration1update,
        "User UID": currentUser?.uid,
        "date": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        "Task Type": "Call",
        "Status": "Complete",
        "Promise date": dateInputController.text,
        "Feedback":feedback
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your call has been record successfull'),
        ),
      );
      return Navigator.of(context, rootNavigator: true).pop();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text('the call was not recorded as its not meet required duretion'),
        ),
      );
      return Navigator.of(context, rootNavigator: true).pop();

    }
  }
  String? feedbackselected;
  var feedback = [
    'Customer will pay',
    'system will be repossessed',
    'at the shop for replacement',
    'Product is with EO',
    'not the owner',
  ];
  String? phoneselected;
  TextEditingController feedbackController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  _callNumber(String phoneNumber, String docid,String angaza) async {
    List<String> phone = phoneNumber.split(',');
    phone  = phone.toSet().toList();


    String _docid = docid;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
                title: Text('Customer Feedback'),
                content: Container(
                    height: 400,
                    child: Column(children: <Widget>[
                      AppDropDown(
                        disable: false,
                          label: 'Phone Number',
                          hint: 'Select Phone Number',
                          items: phone,
                          onChanged: (String value) async {
                            setState((){
                              phoneselected = value;
                            });
                            await FlutterPhoneDirectCaller.callNumber(phoneselected!);
                          }),
                      SizedBox(height: 10,),
                      DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "feedback",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Name",
                          ),
                          items: feedback.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items,overflow: TextOverflow.clip, maxLines: 2,),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              feedbackselected = val!;
                            });
                          }),
                      TextField(
                        maxLines: 4,
                        controller: feedbackController,
                        decoration: InputDecoration(
                          labelText: 'Additional Feedback',
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Date',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 1)),
                        ),
                        controller: dateInputController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 5)));

                          if (pickedDate != null) {
                            dateInputController.text =pickedDate.toString();
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                callLogs(_docid,feedbackController.text,angaza);
                              },
                              child: Text('Submit'),
                            ),
                          ])
                    ]))),
          );
        });
  }


  void initState() {
    print(widget.id);
    super.initState();
  }
  getPhoto(String client) async {

    String username = 'dennis+angaza@greenlightplanet.com';
    String password = 'sunking';
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "method": "GET",
      "Authorization": '${basicAuth}',
      "account_qid": "AC5156322",
    };
    var uri = Uri.parse('https://payg.angazadesign.com/data/clients/$client');
    var response = await http.get(uri, headers: headers);
    var body = json.decode(response.body);
    var attribute = body["attribute_values"];
    List<Map<String, dynamic>> attributes =
        attribute.cast<Map<String, dynamic>>();
    String photo = attributes
        .firstWhere((attr) => attr['name'] == 'Client Photo')['value'];
    return photo;
  }
  var dennis ='';
  getAccountData(String angazaid) async {

    String username = 'dennis+angaza@greenlightplanet.com';
    String password = 'sunking';
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "method":"GET",
      "Authorization": '${basicAuth}',
      "account_qid" : "AC5156322",
    };
    var uri = Uri.parse('https://payg.angazadesign.com/data/accounts/$angazaid');
    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body);
    var id = data['client_qids'][0];

    var uriphoto = Uri.parse('https://payg.angazadesign.com/data/clients/$id');
    var responsephoto = await http.get(uriphoto, headers: headers);

    var bodyphoto = json.decode(responsephoto.body);

    var attribute = bodyphoto["attribute_values"];


    List<Map<String, dynamic>> attributes =
    attribute.cast<Map<String, dynamic>>();

    String photo = attributes
        .firstWhere((attr) => attr['name'] == 'Client Photo')['value'];
    return photo;
  }
  var currentUser = FirebaseAuth.instance.currentUser;
  bool onclick = false;
  final querySnapshot =
      FirebaseFirestore.instance.collection('new_calling').doc().get();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Center(
                child: FutureBuilder<dynamic>(
                    future: getAccountData(widget.angaza),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> photourl) {
                      if (photourl.hasData) {
                        String photo = photourl.data!;
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: 150.0,
                          height: 150.0,
                          color: Colors.grey.withOpacity(0.3),
                          child:  Center(child: Image.network(photo)),
                        );
                      } else if (photourl.hasError) {
                        return
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              width: 150.0,
                              height: 150.0,
                              color: Colors.grey.withOpacity(0.3),
                              child:  Center(child:Icon(Icons.person)),
                            )
                        ;
                      } else {
                        return CircularProgressIndicator();
                      }
                    })),
            StreamBuilder(
              stream: firestore.collection("new_calling").doc(widget.id).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DocumentSnapshot data = snapshot.data!;
                  String phoneList =
                      '${data["Customer Phone Number"]},'+
                          '${data["Phone Number 1"].toString()},'+
                          '${data["Phone Number 2"].toString()},'+
                          '${data["Phone Number 3"].toString()},'+
                          '${data["Phone Number 4"].toString()},'
                  ;
                  var agentname = data['Responsible User'].split('(');
                  var date = data['Registration Date'];
                  return Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name:',
                                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                              Text('Account:',
                                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data['Customer Name']}',
                                  style: const TextStyle(fontSize: 20)),
                              Text(' ${data['Account Number']}',
                                  style: const TextStyle(fontSize: 20)),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              _callNumber(
                                  phoneList,
                                  data.id,
                                  data["Angaza ID"]
                              );
                            },
                            child: Text(
                              data['Customer Phone Number'],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerVisit(id: data.id,
                                            angaza: data["Angaza ID"],
                                          ),
                                    ));
                              },
                              child: Text(data['Area'].toString(),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black))),
                        ],
                      ),
                      const Card(
                        shadowColor: Colors.amber,
                        color: Colors.black,
                        child: ListTile(
                          title: Center(
                              child: Text("Account Detail",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.yellow))),
                          dense: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Agent Name: ',
                                    style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                Text(
                                  'Agent Username: ',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Registration Date: ',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Product Name: ',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Is FPD: ',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                Text('Amount to Collect: ',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                Text('Amount Collected: ',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                                Text('Promise date: ',
                                    style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(' ${agentname[0]}',
                                    style: const TextStyle(fontSize: 15)),
                                Text(
                                  ' ${agentname[1].replaceAll(')', '')}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  ' ${DateTime.fromMillisecondsSinceEpoch(date.seconds*1000).toString().substring(0,10)}',
                                  style: const TextStyle(fontSize: 15),
                                ),

                                Text(
                                  ' ${data['Product Name']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  ' ${data['FPD']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(' ${data['Amount to Collect']}',
                                    style: const TextStyle(fontSize: 15)),
                                Text(' ${data['Amount Collected']}',
                                    style: const TextStyle(fontSize: 15)),

                                Text(' ${data['Promise date']}',
                                    style: const TextStyle(fontSize: 15)),
                              ],
                            )
                          ],
                        ),
                      ),


                      SizedBox(
                        height: 10,
                      ),

                    ],
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text("Error Loading data")
                    ],
                  );
                } else {
                  return Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text("Loading data...")
                    ],
                  );
                }
              },
            ),
            const Card(
              shadowColor: Colors.amber,
              color: Colors.black,
              child: ListTile(
                title: Center(
                    child: Text("Call History",
                        style: TextStyle(
                            fontSize: 15, color: Colors.yellow))),
                dense: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "No.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text("Task Type",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    )),
                Text("Date Completed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ))
              ],
            ),
            Container(
                height: 300,

                child: FutureBuilder(
                  future:firestore.collection("FeedBack").where('Angaza ID',isEqualTo: widget.angaza).get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> feedbackdata) {
                    print(feedbackdata);
                    if(feedbackdata.hasData){
                      return ListView.separated(
                          itemCount: feedbackdata.data!.docs.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return CustomFeedBack(
                              serial: index+1,
                              feedback:feedbackdata.data!.docs[index]["Feedback"],
                              task:feedbackdata.data!.docs[index]["Task Type"],
                              date:feedbackdata.data!.docs[index]["date"],

                            );
                          });
                    }else{
                      return Column(
                        children: [
                          Text("No record Found")
                        ],
                      );
                    }

                  },)
            )
          ],
        )


      ),
    );
  }
}

class CustomFeedBack extends StatefulWidget {
  final int serial;
  final String feedback;
  final String task;
  final String date;

  const CustomFeedBack({Key? key,required this.serial, required this.feedback,required this.task,required this.date}) : super(key: key);

  @override
  _CustomFeedBackState createState() => _CustomFeedBackState();
}

class _CustomFeedBackState extends State<CustomFeedBack> {
  bool _showContainer = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _showContainer = !_showContainer;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text((widget.serial).toString()),
                Text(widget.task),
                Text(widget.date.toString()),
              ],
            ),
          ),
          _showContainer
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Feedback: ${widget.feedback}!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
/*
InkWell(
                            onTap: (){
    setState(() {
      onclick = true;
      print(index);
    });
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: onclick?50:20,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text((index+1).toString()),
                                      Text("Visit"),
                                      Text("10/${index.toString()}")
                                    ],
                                  ),
                                  onclick?Text("data"):Spacer()
                                ],
                              ),
                            ),
                          )
 */
