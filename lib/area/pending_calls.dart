// main.dart
import 'dart:convert';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'package:fieldapp_rcm/area/customer_vist.dart';
import 'package:fieldapp_rcm/services/calls_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldapp_rcm/services/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/drop_down.dart';

class PendingCalls extends StatefulWidget {
  const PendingCalls({Key? key}) : super(key: key);

  @override
  PendingCallsState createState() => PendingCallsState();
}

class PendingCallsState extends State<PendingCalls> {
  String _searchText = '';
  bool visit = false;
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
  void userArea() {
    UserDetail().getUserArea().then((value) {
      setState(() {
        Area = value;
      });
    });
  }

  String _searchQuery = '';

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void callLogs(String docid, String feedback, String angaza) async {
    String _docid = docid;

    if (duration1update >= 30) {



      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your call has been record successfull'),
        ),
      );
      return Navigator.of(context, rootNavigator: true).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'the call was not recorded as its not meet required duretion'),
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
  _callNumber(String phoneNumber, String docid, String angaza) async {
    List<String> phone = phoneNumber.split(',');
    final _formKey = GlobalKey<FormState>();
    phone = phone.toSet().toList();
    String txt = feedbackController.text;
    String datetxt = dateInputController.text.toString();

    String _docid = docid;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
                title: Text('Customer Feedback'),
                content: Container(
                    height: 500,
                    child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        AppDropDown(
                            disable: false,
                            label: 'Phone Number',
                            hint: 'Select Phone Number',
                            items: phone,
                            onChanged: (String value) async {
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                            isExpanded: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a feedback option';
                              }
                              return null;
                            },
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
                                child: Text(
                                  items,
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                feedbackselected = val!;
                              });
                            }),
                        TextFormField(
                          onChanged: (value) {
                            txt = value;
                          },
                          maxLines: 4,
                          validator: (value) {
                            if (txt == null || txt.isEmpty) {
                              return 'Please fill additional feedback';
                            }
                            return null;
                          },
                          controller: feedbackController,
                          decoration: InputDecoration(
                            labelText: 'Additional Feedback',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Date',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1)),
                          ),
                          controller: dateInputController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 5)));

                            if (pickedDate != null) {
                              dateInputController.text = pickedDate.toString();
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
                                  if (_formKey.currentState!.validate() &&
                                      phoneselected != null &&
                                      dateInputController.text != null) {
                                    callLogs(_docid, feedbackController.text,
                                        angaza);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Please fill all the detail"),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Submit'),
                              ),
                            ])
                      ]),
                    ))),
          );
        });
  }
 final _data = [];
  bool isDescending = false;

  // This list holds the data for the list view

  @override
  initState() {
    // at the beginning, all users are shown
    userArea();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () => setState(() => isDescending = !isDescending),
                icon: Icon(
                  isDescending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 20,
                  color: Colors.yellow,
                ),
                splashColor: Colors.lightGreen,
              ),
            ),
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'All':

                    print(value);
                    break;
                  case 'Call':
                    print(value);

                    break;
                  case 'Disabled':
                    print(value);

                    break;
                  case 'Visit':
                    print(value);

                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text("All"), value: "All"),
                const PopupMenuItem(child: Text("Call"), value: "Call"),
                const PopupMenuItem(child: Text("Disabled"), value: "Disabled"),
                const PopupMenuItem(child: Text("Visit"), value: "Visit"),
              ],
              icon: const Icon(Icons.filter_list_alt, color: Colors.yellow),
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
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
        Expanded(
          child: _data.length > 0
              ? ListView.separated(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {

                    String phoneList = '${_data[index]["Customer Phone Number"]},' +
                        '${_data[index]["Phone Number 1"].toString()},' +
                        '${_data[index]["Phone Number 2"].toString()},' +
                        '${_data[index]["Phone Number 3"].toString()},' +
                        '${_data[index]["Phone Number 4"].toString()},';
                    if (_data[index]["Task"] == 'Visit') {
                      visit = true;
                    } else {
                      visit = false;
                    }
                    if (_searchQuery.isNotEmpty &&
                        !_data[index]['Customer Name']
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase())) {
                      return SizedBox();
                    }
                    return InkWell(
                      onTap: () {

                      },
                      key: ValueKey(_data[index]),
                      child: Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Name:",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                      ),
                                      Text("Account:",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Text("Product:",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      // Text("${account}"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${_data[index]['Customer Name']}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          )),
                                      Text(
                                          "${_data[index]['Account Number'].toString()}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          )),
                                      Text("${_data[index]['Product Name']}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          )),
                                      // Text("${account}"),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  visit
                                      ? IconButton(
                                          padding: new EdgeInsets.all(0.0),
                                          onPressed: () {},
                                          icon: Transform.rotate(
                                              angle: 90,
                                              child: Icon(Icons.phone_disabled,
                                                  size: 20.0)))
                                      : IconButton(
                                          padding: new EdgeInsets.all(0.0),
                                          onPressed: () {
                                            _callNumber(phoneList, _data[index].id,
                                                _data[index]["Angaza ID"]);
                                          },
                                          icon: Icon(Icons.phone, size: 20.0)),
                                  IconButton(
                                      padding: new EdgeInsets.all(0.0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerVisit(
                                                id: _data[index].id,
                                                angaza: _data[index]["Angaza ID"],
                                              ),
                                            ));
                                      },
                                      icon: Icon(Icons.location_on_outlined,
                                          size: 20.0))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    ;
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                )
              : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 15),
                ),
        )
      ],
    );
  }
}
