import 'dart:convert';


import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/models/db.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashView extends StatefulWidget {
  @override
  final title;
  final value;
  final country;
  final region;
  final item;
  final zone;
  final role;
  const DashView(
      this.title, this.value,this.country,this.region,this.item,this.zone,this.role, {super.key});
  @override
  DashViewState createState() => DashViewState();
}

class DashViewState extends State<DashView> {
  List? data = [];
  bool isLoading = true;
  List<String> area_data= [];
  Future<StorageItem?> listItems(key) async {
    print("dash $key");
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = await Database.listItems();

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;
        if(widget.role == 'CCM'){
          ZoneData(latestFile.key);
        }else if(widget.role == 'ZCM'|| widget.role == ''){
          RegionData(latestFile.key);
        }else if(widget.role == 'RCM'){
          AreaData(latestFile.key);
        }
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
    return null;
  }
  Future<void> ZoneData(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");

    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;
      print(urlResult.url);
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) =>
          task['Country'] == widget.country
      ).toList();
      print("${widget.country} $filteredTasks");
      filteredTasks.sort((a,b){
        String scoreA = a[widget.title] ?? "0";
        String scoreB = b[widget.title] ?? "0";
        double scoreValueA = double.tryParse(scoreA.replaceAll("%", "") ?? "0") ?? 0;
        double scoreValueB = double.tryParse(scoreB.replaceAll("%", "") ?? "0") ?? 0;
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
  Future<void> RegionData(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");

    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;
      print(urlResult.url);
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['zone'] == widget.zone &&
          task['Country'] == widget.country
      ).toList();
      print("${widget.country} $jsonData");
      filteredTasks.sort((a,b){
        String scoreA = a[widget.title] ?? "0";
        String scoreB = b[widget.title] ?? "0";
        double scoreValueA = double.tryParse(scoreA.replaceAll("%", "") ?? "0") ?? 0;
        double scoreValueB = double.tryParse(scoreB.replaceAll("%", "") ?? "0") ?? 0;
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
          .where((task) => task['Region'] == widget.region &&
          task['Country'] == widget.country
      ).toList();
      print("${widget.country} $filteredTasks");
      filteredTasks.sort((a,b){
        String scoreA = a[widget.title] ?? "0";
        String scoreB = b[widget.title] ?? "0";
        double scoreValueA = double.tryParse(scoreA.replaceAll("%", "") ?? "0") ?? 0;
        double scoreValueB = double.tryParse(scoreB.replaceAll("%", "") ?? "0") ?? 0;
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
    if(widget.item=='zone'){
      listItems("dashboard/Region");
    }else if(widget.item=='country'){
      listItems("dashboard/zone");
    }else if(widget.item=='region'){
      listItems("dashboard");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 30.0,
              animation: true,
              center: Text(
                widget.value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: Text(
                widget.title,
                style: const TextStyle(
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
                    child: isLoading?const Center(child: CircularProgressIndicator()):
                    Column(
                      children: [

                        Text(
                          data!.first[widget.title] ?? "0",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.green),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Best performance")
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 80,
                    width: 150,
                    color: Colors.white,
                    child: isLoading?const Center(child: CircularProgressIndicator()):Column(
                      children: [

                        Text(
                    data!.last[widget.title] ?? "0",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Poor performance")
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

                          data![index][widget.title] ?? "0",
                          style: const TextStyle(
                              color: Colors.green, fontSize: 15),
                        ),
                        title: Text( data![index]['Region'],));
                  }),
            )
          ],
        ));
  }
}
