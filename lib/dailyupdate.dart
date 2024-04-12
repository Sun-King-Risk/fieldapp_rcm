import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/widget/title_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DailyUpdate extends StatefulWidget {
  const DailyUpdate({super.key});


  @override
  State<DailyUpdate> createState() => _DailyUpdateState();
}
class _DailyUpdateState extends State<DailyUpdate> {
  String name ="";
  String region = '';
  String country ='';
  String role = '';
  List? data = [];
  bool isLoading = true;
  bool nodata = true;
  List<String> regiondata= [];
  @override
  void initState() {

    super.initState();
    getUserAttributes();

  }
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = Amplify.Storage.list(
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
        InsightUpdate(latestFile.key);

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

  InsightUpdate(file) async{
    List<String> uniqueRegion = [];
    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: file)
          .result;


      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['Region'] == region&& task['Country'] == country )
          .toList();
      setState(() {

        data = filteredTasks;
        regiondata = uniqueRegion.toSet().toList();
        nodata = false;
        isLoading = false;

      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }

  }
  void getUserAttributes() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      role = prefs.getString("role")!;
      name = prefs.getString("name")!;
      region = prefs.getString("region")!;
      country = prefs.getString("country")!;
    });
    listItems("Regional_Wise_Preview");
    name = prefs.getString("name")!;
    if (kDebugMode) {
      print(country);
      print(name);
    }
    // Process the user attributes


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const KpiTittle(
          label: 'Sales Information',
          txtColor: Colors.black87,
        ),

      Expanded(
        child: isLoading?const Center(child: CircularProgressIndicator(),):ListView.separated(itemBuilder: (
            BuildContext context, int index) {
          return InkWell(
            onTap: () {},
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Unit Sales:",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                              Text(
                                "Unit Sales MTD:",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                              Text(
                                "Unit Sales LMSD:",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                              Text(
                                "Unit Sales Yesterday:",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                              Text(
                                "Projected Unit sales:",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                              Text(
                                "Revenue Realization:",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                              Text("Unit Sales Last Month:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text("Unit Sales Last 6 Months:",
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
                              Text("${data![0][' Unit Sales']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Weighted Sales - MTD']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Weighted Sales - LMSD']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Weighted Sales (Yesterday)']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Projected Weighted Sales By Month End']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Follow on Revenue Realization']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Weighted Sales - Last Month']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              Text("${data![0]['Weighted Sales - Last 6 Months']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  )),
                              // Text("${account}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          );
        },
          separatorBuilder: (BuildContext context, int index) =>
    const Divider(),
          itemCount: 1,

        ),
      ),
        const KpiTittle(

          label: 'Disablements Information',
          txtColor: Colors.black87,
        ),
        Expanded(
          child:isLoading?const Center(child: CircularProgressIndicator(),): ListView.separated(itemBuilder: (
              BuildContext context, int index) {
            double daysdisble = double.parse(data![index]['Average Cumulative Days Disabled']);
            return InkWell(
                onTap: () {},
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "FPD Rate:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "SPD Rate:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "Average Cumulative Days Disabled:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "At Risk Unit:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "Written Off Unit:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "Disabled > Two Week Rate:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "Disabled Rate:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "Count Detached:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text(
                                  "Count Disabled Over 7 Days:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("${data![0]['First Pay Default Rate']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Second Pay Default Rate']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text(daysdisble.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Units At Risk']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Count Written Off']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Disabled Greater Than Two Week Rate']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Disabled Rate']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Detached Count Units']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Count Disabled Over 7 Days']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                // Text("${account}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
            itemCount: 1,

          ),
        ),
        const KpiTittle(
          label: 'Repayment',
          txtColor: Colors.black87,
        ),
        Expanded(
          child: isLoading?const Center(child: CircularProgressIndicator(),):ListView.separated(itemBuilder: (
              BuildContext context, int index) {
            return InkWell(
                onTap: () {},
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Repayment Speed 2:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text("Sum Balance to Collect:",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("Revenue Realization:",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("Percent Repaid:",
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
                                Text("${data![0]['Repayment Speed 2']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Disabled Rate']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Follow on Revenue Realization']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${data![0]['Percent Repaid']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                // Text("${account}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
            itemCount: 1,

          ),
        ),
      ],

    );
  }
}

