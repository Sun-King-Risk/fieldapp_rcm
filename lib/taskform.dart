// main.dart
import 'dart:convert';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'package:fieldapp_rcm/area/customer_vist.dart';
import 'package:fieldapp_rcm/services/calls_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldapp_rcm/services/user_detail.dart';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

import '../widget/drop_down.dart';
import 'area/customer_profile.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  PendingCallsState createState() => PendingCallsState();
}

class PendingCallsState extends State<UserList> {
  String _searchText = '';
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
    final httpPackageUrl = Uri.https('payg.angazadesign.com', '/data/clients',{"account_qid" : "AC5156322"},
    );
    var uri = Uri.parse('https://payg.angazadesign.com/data/accounts/$angazaid');
    var response = await http.get(uri, headers: headers);
    var data = response.body;
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }
    final birthday = DateTime(1967, 10, 12);
    final date2 = DateTime.now();
    var dd = json.decode(response.body);
    return data;
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
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
  void userArea(){
    UserDetail().getUserArea().then((value){
      setState(() {
        Area = value;
      });
    });
  }
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

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
        "date": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
        "Task Type": "Call",
        "Status": "Complete",
        "Promise date": dateInputController.text,
      });
      CollectionReference feedBack = firestore.collection("FeedBack");
      await feedBack.add({
        "Angaza ID":angaza,
        "Duration": duration1update,
        "User UID": currentUser?.uid,
        "date": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
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
    'System will be repossessed',
    'At the shop for replacement',
    'Product is with EO',
    'Not the owner',
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

  bool isDescending = false;

  final List<Map<String, dynamic>> _allUsers = [
    {
      "id": 1,
      "name": "Collection Score",
      "request": "New Request",
      "status": "Complete"
    },
    {
      "id": 2,
      "name": "Team Management",
      "request": "pending Approval",
      "status": "Complete"
    },
    {
      "id": 3,
      "name": "Customer Management",
      "request": "New Request",
      "status": "Over due"
    },
    {
      "id": 4,
      "name": "Pilot Management",
      "request": "Rejected",
      "status": "Complete"
    },
    {
      "id": 5,
      "name": "Process Management",
      "request": "New Request",
      "status": "Pending"
    },
    {
      "id": 6,
      "name": "Customer Management",
      "request": "Pending",
      "status": "Pending"
    },
    {
      "id": 7,
      "name": "Process Management",
      "request": "Rejected",
      "status": "Pending"
    },
    {
      "id": 8,
      "name": "Collection Score",
      "request": "Rejected",
      "status": "Over due"
    },
    {
      "id": 9,
      "name": "Team Management",
      "request": "Pending Approval",
      "status": "Over due"
    },
    {
      "id": 10,
      "name": "Pilot Management",
      "request": "Rejected ",
      "status": "New Request"
    },
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];

  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _allUsers;
    userArea();
    super.initState();
  }

  // This function is called whenever the text field changes
  void _searchFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  void _statusFilter(String _status) {
    List<Map<String, dynamic>> results = [];
    switch (_status) {
      case "Complete":
        {
          results = _allUsers
              .where((user) =>
              user["status"].toLowerCase().contains(_status.toLowerCase()))
              .toList();
        }
        break;

      case "Pending":
        {
          results = _allUsers
              .where((user) =>
              user["status"].toLowerCase().contains(_status.toLowerCase()))
              .toList();
        }
        break;

      case "Over due":
        {
          results = _allUsers
              .where((user) =>
              user["status"].toLowerCase().contains(_status.toLowerCase()))
              .toList();
        }
        break;
      case "All":
        {
          results = _allUsers;
        }
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              /* Container(
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
                  onSelected:(reslust) =>_statusFilter(reslust),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Text("All"),
                          value: "All"
                      ),
                      PopupMenuItem(
                          child: Text("Complete"),
                          value: "Complete"
                      ),
                      PopupMenuItem(
                          child: Text("Pending"),
                          value: "Pending"
                      ),
                      PopupMenuItem(
                          child: Text("Over Due"),
                          value: "Over due"
                      ),
                    ],
                    icon: Icon(
                      Icons.filter_list_alt,color: Colors.yellow
                    ),

                  ),*/
              Expanded(
                child: TextField(
                  onChanged:  (value) {
                    setState(() {
                      _searchText = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(

              stream: firestore
                  .collection("new_calling")
                  .where("Area", isEqualTo:Area).where('Status', isNotEqualTo: 'Complete')
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {

                  return Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Loading...'),
                    ],
                  );
                } else {
                  List<QueryDocumentSnapshot> docsdata = snapshot.data!.docs
                      .where((doc) => doc["Customer Name"].toString().toLowerCase().contains(_searchText))
                      .toList();
                  return Expanded(
                    child:snapshot.data!.docs.length>0
                        ? ListView.separated(
                      itemCount: docsdata.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = docsdata[index];
                        String phoneList =
                            '${data["Customer Phone Number"]},'+
                                '${data["Phone Number 1"].toString()},'+
                                '${data["Phone Number 2"].toString()},'+
                                '${data["Phone Number 3"].toString()},'+
                                '${data["Phone Number 4"].toString()},'
                        ;

                        /*final sortedItems = _foundUsers
                            ..sort((item1, item2) => isDescending
                                ? item2['name'].compareTo(item1['name'])
                                : item1['name'].compareTo(item2['name']));
                          final name = sortedItems[index]['name'];*/
                        /*FutureBuilder(
                                future: getPhoto(),
                                builder: (BuildContext context, AsyncSnapshot<dynamic> accountdata) {
      if (accountdata.hasData) {

      }else if(accountdata.hasError){
        return Text("Error loading data");
      }else{
        return CircularProgressIndicator();
      }

                                },

                              );*/
                        return FutureBuilder(
                          future: getAccountData(data['Angaza ID']),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> accountdata) {
                            if (accountdata.hasData) {
                              var querydata =  accountdata.data.toString();
                              var accountdetail = jsonDecode(querydata);
                              bool isdisable = false;
                              var date = DateTime.parse(accountdetail["payment_due_date"]);
                              var days = daysBetween(date,DateTime.now());
                              if(days<0){
                                days = 0;
                              }
                              if(accountdetail["status"] =='DISABLED'){
                                isdisable = true;
                              }

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CProfile(id: data.id,
                                              angaza: data['Angaza ID'],
                                            ),
                                      ));
                                },
                                key: ValueKey(snapshot.data!.docs[index]),
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                        future: getPhoto(accountdetail["client_qids"][0]),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> photourl) {
                                          if (photourl.hasData) {
                                            String photo = photourl.data!;
                                            return SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Image.network(photo),
                                            );
                                          } else if (snapshot.hasError) {
                                            return CircleAvatar(
                                              backgroundColor: Colors.blueGrey.shade800,
                                              radius: 20,

                                            );
                                          }else {
                                            return CircularProgressIndicator();
                                          }
                                        }),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Flexible(
                                      child: Container(
                                        height: 70,
                                        child: Card(
                                          color: isdisable?Colors.red:Colors.green.withOpacity(0.6),
                                          elevation: 5,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(5.0, 5, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Name:", style: TextStyle(
                                                            fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold)),
                                                        Text("Account:",style: TextStyle(
                                                            fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold)),
                                                        Text("Disable:",style: TextStyle(
                                                            fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold)),
                                                        // Text("${account}"),

                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${data['Customer Name']}",style: TextStyle(
                                                          fontSize: 13, color: Colors.black,)),
                                                        Text("${data['Account Number']
                                                            .toString()}",style: TextStyle(
                                                          fontSize: 13, color: Colors.black,)),
                                                        Text("$days",style: TextStyle(
                                                          fontSize: 13, color: Colors.black,)),
                                                        // Text("${account}"),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                if(data["Task Type"] != 'Visit')
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          padding: new EdgeInsets.all(0.0),
                                                          onPressed: () {
                                                            _callNumber(
                                                                phoneList,
                                                                data.id,
                                                                data["Angaza ID"]
                                                            );
                                                          },
                                                          icon: Icon(Icons.phone,size: 20.0)),
                                                      IconButton(
                                                          padding: new EdgeInsets.all(0.0),
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
                                                          icon: Icon(Icons
                                                              .location_on_outlined,size: 20.0))
                                                    ],
                                                  ),
                                                if(data["Task Type"] == 'Visit')
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          padding: new EdgeInsets.all(0.0),
                                                          onPressed: () {

                                                          },
                                                          icon: Icon(Icons.phone_disabled,size: 20.0)),
                                                      IconButton(
                                                          padding: new EdgeInsets.all(0.0),
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
                                                          icon: Icon(Icons
                                                              .location_on_outlined,size: 20.0))
                                                    ],
                                                  )


                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }else if(accountdata.hasError){
                              return Text("Error loading data");
                            }else{
                              return CircularProgressIndicator();
                            }

                          },

                        );
                        /* return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CProfile(id: data.id),
                                      ));
                                },
                                key: ValueKey(snapshot.data!.docs[index]),
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                        future: getPhoto(),
                                        builder: (BuildContext context,
      AsyncSnapshot<dynamic> photourl) {
      if (photourl.hasData) {
        String photo = photourl.data!;
        return CircleAvatar(
          backgroundColor: Colors.blueGrey.shade800,
          radius: 20,
          child: Image.network(photo),
        );
      } else if (snapshot.hasError) {
       return CircleAvatar(
          backgroundColor: Colors.blueGrey.shade800,
          radius: 20,

        );
      }else {
        return CircularProgressIndicator();
      }
                                        }),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Flexible(
                                      child: Container(
                                        height: 80,
                                        child: Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5.0, 5, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Name: ${data['Customer Name']}"),
                                                    Text("Account: ${data['Account Number']
                                                        .toString()}"),
                                                    Text("Days Disable: 0",style: TextStyle(color: Colors.red),),
                                                   // Text("${account}"),

                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          _callNumber(
                                                              data[
                                                                  'Customer Phone Number'],
                                                              data.id);
                                                        },
                                                        icon: Icon(Icons.phone)),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CustomerVisit(id: data.id),
                                                              ));
                                                        },
                                                        icon: Icon(Icons
                                                            .location_on_outlined))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );*/
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    )
                        : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }
                ;
              }),
        ],
      ),
    );
  }
}
