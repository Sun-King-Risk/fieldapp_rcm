import 'dart:convert';


import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/services/region_data.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashView extends StatefulWidget {
  @override
  final title;
  final value;
  DashView(this.title, this.value);
  DashViewState createState() => DashViewState();
}

class DashViewState extends State<DashView> {
  List? data = [];
  bool isLoading = true;
  List<String> area_data= [];
  Future<StorageItem?> listItems(key) async {
    print(key);
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
        AreaData(latestFile.key);
        print(latestFile.key);
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
  Future<void> AreaData(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");

    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['Region'] == 'Central' &&
          task['Country'] =='Tanzania'
      ).toList();
      filteredTasks.sort((a,b){
        String scoreA = a[widget.title]== null?"0":a[widget.title];
        String scoreB = b[widget.title]== null?"0":b[widget.title];
        double scoreValueA = double.tryParse(scoreA?.replaceAll("%", "") ?? "0") ?? 0;
        double scoreValueB = double.tryParse(scoreB?.replaceAll("%", "") ?? "0") ?? 0;
        if(widget.title =="Collection Score"||widget.title =="Repayment Speed Last 182 Days"||widget.title =="Repayment Speed 2"){
          return scoreValueB.compareTo(scoreValueA);
        }else{
          return scoreValueA.compareTo(scoreValueB);
        }

      });

      print('File_region: $filteredTasks');
      setState(() {

        data = filteredTasks;
        safePrint('File_data: $area_data');
        isLoading = false;
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItems("dashboard");
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 30.0,
              animation: true,
              center: new Text(
                widget.value,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: new Text(
                widget.title,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: AppColor.mycolor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Container(
                    height: 80,
                    width: 150,
                    color: Colors.white,
                    child: isLoading?Center(child: CircularProgressIndicator()):Column(
                      children: [
                        Text(
                          data!.first[widget.title]==null?"0":data!.first[widget.title],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.green),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Best performance")
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 80,
                    width: 150,
                    color: Colors.white,
                    child: isLoading?Center(child: CircularProgressIndicator()):Column(
                      children: [

                        Text(
                    data!.last[widget.title]==null?"0":data!.last[widget.title],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.red),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Text("Poor performance")
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                        trailing:

                        Text(

                          data![index][widget.title] == null ? "0" : data![index][widget.title],
                          style: TextStyle(
                              color: Colors.green, fontSize: 15),
                        ),
                        title: Text( data![index]['Area'],));
                  }),
            )
          ],
        ));
  }
}
