import 'package:fieldapp_rcm/dash_view.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'utils/themes/theme.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';



class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //AuthUser user = Amplify.Auth.getCurrentUser() as AuthUser;
    //String loginId = user.username;
    //var loginId = Amplify.Auth.fetchUserAttributes();

    var currentUser = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      child: Container(

        padding: const EdgeInsets.all(12.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("${currentUser?.displayName}",style: TextStyle(fontSize: 10),),
            Text("sd",style: TextStyle(fontSize: 10),),
//summary
            SizedBox(height: 5,),
            Container(
              child: Column(
                children: [

                  KpiTittle(
                    kpicolor: AppColor.mycolor,
                    label: 'Dashboard',
                    txtcolor: Colors.black87,
                  ),
                  KpiTittle(
                    kpicolor: Colors.black87,
                    label: 'Portfolio Quality / Collection Drive',
                    txtcolor: AppColor.mycolor,
                  ),

                  //Portfolio Quality

                  Row(children: [
                    RowData(
                      value: 'Collection Score',
                      label: 'Score',
                    ),
                    RowData(
                      value: 'Repayment Speed 2',
                      label: 'Repayment Speed',
                    ),
                    RowData(
                      value: 'At Risk Rate',
                      label: 'At Risk Rate',
                    ),
                  ]),
                  const Divider(
                    height: 10,
                    thickness: 0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      RowData(
                        value: 'Disabled Rate',
                        label: 'Disabe Rate',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'FSE Revamp',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'Audity',
                      ),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    thickness: 0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  KpiTittle(
                    kpicolor:Colors.black87,
                    label: 'Customer Management',
                    txtcolor: AppColor.mycolor,
                  ),
                  Row(
                    children: [
                      RowData(
                        value: 'Count Replacements',
                        label: 'Fraud Case SLA',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'CC Escalation',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'Replacement SLA',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'Change of Details',
                      ),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    thickness: 0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  KpiTittle(
                    kpicolor: Colors.black87,
                    label: 'Pilot / Process Management',
                    txtcolor: AppColor.mycolor,
                  ),
                  Row(
                    children: [
                      RowData(
                        value: 'Count Replacements',
                        label: 'Agent Restriction',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'Audit Reports',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'Repossession Rate',
                      ),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    thickness: 0,
                    color: Colors.black,
                  ),
                  KpiTittle(
                    kpicolor: Colors.black87,
                    label: 'Team Management',
                    txtcolor: AppColor.mycolor,
                  ),
                  Row(
                    children: [
                      RowData(
                        value: 'Count Replacements',
                        label: 'Replacements',
                      ),
                      RowData(
                        value: 'Count Replacements',
                        label: 'Replacement SLA',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowData extends StatefulWidget {

  final value;
  final String label;

  const RowData({Key? key, required this.value, required this.label})
      : super(key: key);

  @override
  State<RowData> createState() => _RowDataState();
}

class _RowDataState extends State<RowData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override

  Widget build(BuildContext context) {

    return Expanded(
      child:  FutureBuilder(
          future:  RegionData().getData(),
          builder: (BuildContext context, snapshot) {
    if (snapshot.hasData) {
      //DocumentSnapshot data = snapshot.data;
      var data = snapshot.data!.docs[0];
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashView(widget.value,data[widget.value]),
              ));

        },
        key: ValueKey(snapshot.data),
        child: Card(
          elevation: 8,
          child: Container(
            height: 60,
            width: 50,
            child: Column(
              children: [
                Text(data[widget.value], style: TextStyle(fontSize: 20,)),
                Text(widget.label, style: TextStyle(fontSize: 9))
              ],
            ),
          ),
        ),
      );
    }
    else if(snapshot.hasError){
      return InkWell(
        onTap: (){},

        child: Card(
          elevation: 8,
          child: Container(
            height: 70,
            width: 50,
            child: Column(
              children: [
                Text('000', style: TextStyle(fontSize: 30,)),
                Text(snapshot.error.toString(), style: TextStyle(fontSize: 9))
              ],
            ),
          ),
        ),
      );
    }
    else{
      return Column(children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10,
        ),
        Text('run...'),
      ]);
    }
    }

      ),
    );
  }
}

class KpiTittle extends StatelessWidget {
  final Color kpicolor;
  final String label;
  final Color txtcolor;
  const KpiTittle({Key? key, required this.kpicolor, required this.txtcolor,required this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.amber,
      color: kpicolor,
      child: ListTile(
        title: Center(child: Text(label, style: TextStyle(fontSize: 20,color: txtcolor))),
        dense: true,
      ),
    );
  }
}
