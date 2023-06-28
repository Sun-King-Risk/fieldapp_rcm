import 'dart:convert';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/dash_view.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'utils/themes/theme.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;



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

            Text("Dennis Juma",style: TextStyle(fontSize: 10),),
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
                        value: 'Detached Rate',
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItems('Reginal');
  }
  List? data = [];
  bool isLoading = true;
  List<String> region= [];
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      );

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;
        RegionTask(latestFile.key);
        print(latestFile.key);
        print("Key: $key");

        return resultList.first;

      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }

      for (StorageItem item in resultList) {
        print('Key: ${item.key}');
        print('Last Modified: ${item.lastModified}');
        // Access other properties as needed
      }

      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
  }
  Future<void> RegionTask(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");

    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['Region'] == 'Central' && task['Country'] =='Tanzania' )
          .toList();
      print('File_team: $jsonData');
      for (var item in filteredTasks) {
        //String region = item['Region'];
        //region?.add(region);
        if(item['Region'] == null){
        }else{
          uniqueRegion.add(item['Region']);
        }

      }
      setState(() {
        data = filteredTasks;
        region = uniqueRegion.toSet().toList();
        safePrint('File_team: $jsonData');
        isLoading = false;
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  @override

  Widget build(BuildContext context) {

    return Expanded(
      child:  InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashView(widget.value,widget.value),
              ));

        },
        key: ValueKey("dad"),
        child: Card(
          elevation: 8,
          child: Container(
            height: 60,
            width: 50,
            child: Column(
              children: [
                Text(data![0][widget.value], style: TextStyle(fontSize: 20,)),
                Text(widget.label, style: TextStyle(fontSize: 9))
              ],
            ),
          ),
        ),
    )
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
