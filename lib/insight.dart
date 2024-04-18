
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/db.dart';

class Insight extends StatefulWidget {
  const Insight({super.key});


  @override
  State<Insight> createState() => _InsightState();
}
class _InsightState extends State<Insight> {
  String name ="";
  String region = '';
  String country ='';
  String role = '';
  List<List<dynamic>>data = [];
  bool isLoading = true;
  bool nodata = true;
  List<String> regiondata= [];

  @override
  void initState() {
    super.initState();
    getUserAttributes();

  }

  InsightUpdate() async{
    var connection = await Database.connect();
    var results = await connection.query("SELECT * FROM daily_insights");
    data = results;
    print(data);

  }
  void getUserAttributes() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      role = prefs.getString("role")!;
      name = prefs.getString("name")!;
      region = prefs.getString("region")!;
      country = prefs.getString("country")!;
    });
    name = prefs.getString("name")!;
    InsightUpdate();
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
        Expanded(
          child: ListView.separated(itemBuilder: (
              BuildContext context, int index) {
            var dataitem = data[index];
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
                                  "Subject:",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                Text("Region/Area/SKU:",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("Date:",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("Status:",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))
                                // Text("${account}"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("${dataitem[5]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${dataitem[4]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${dataitem[1]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    )),
                                Text("${dataitem[8]}",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                       ))
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
            itemCount: data.length,

          ),
        )
      ],

    );
  }
}