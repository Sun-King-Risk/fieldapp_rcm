import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postgres_dart/postgres_dart.dart';

import 'models/db.dart';


class Bucket extends StatefulWidget {
  var connection = PostgreSQLConnection("localhost", 5432, "dart_test", username: "dart", password: "dart");

  Bucket({super.key});
  /*final Function(String) onTask;

  //final Function(String) onSubTask;
  //final Function(List?) taskResult;
  final Function(String) onregionselected;
  final Function(String?) onareaselected;

  Bucket(
      {
      //required this.onregionselected,
   */
      //required this.onareaselected,
     // required this.onTask,
      //required this.onSubTask,
      //required this.taskResult});**/

  @override
  BucketState createState() => BucketState();
}

class BucketState extends State<Bucket> {
  @override
  initState() {
    Conent();
    listItems('Reginal');

  }

  void Conent() async {
    var connection = PostgreSQLConnection(
        'ec2-54-91-61-224.compute-1.amazonaws.com',
        5432,
        "dd9vqp2r0c7soq",
        username: "uf9fso6v2tj5up",
        password: "p9e0b305a3dd4a434a1763d5ce35170e9c7041e8ad5bcbdd5881472e508693472",
      useSSL: true
    );

    try {
      await connection.open();
      var results = await connection.query("SELECT last_name FROM users_newuser");
      print(results.map((row) => row[0]).where((role) => role != null && role.isNotEmpty).toSet().toList());
      }catch(e){
      print("error");
      print(e.toString());
    }
    }

  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation =  await Database.listItems();

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;
        print(latestFile);
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
  final _formKey = GlobalKey<FormState>();
  late String selectedTask = '';
  String selectedSubTask = '';
  late String regionselected = '';
  late String areaselected = '';
  late String agentselected = '';
  List? _myActivities;
  late String priority = '';
  late String target;
  String? selectedarea;
  late String _myActivitiesResult;
  List<String> agentList = [];







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new task"),
      ),
      body: const SingleChildScrollView(
        child: Text("dennis"),
      )
    );
  }
}

class PostgreSQLHelper{

  var connURL = PostgresDb.fromUrl('postgres://uf9fso6v2tj5up:p9e0b305a3dd4a434a1763d5ce35170e9c7041e8ad5bcbdd5881472e508693472@ec2-54-91-61-224.compute-1.amazonaws.com:5432/dd9vqp2r0c7soq');
  var connection = PostgresDb(
      host: 'ec2-54-91-61-224.compute-1.amazonaws.com',
      port: 5432,
      databaseName:"dd9vqp2r0c7soq",
      username: "uf9fso6v2tj5up",
      password: "p9e0b305a3dd4a434a1763d5ce35170e9c7041e8ad5bcbdd5881472e508693472");
  Future<void> openConnection() async{
    await  connection.open();
  }

  Future<void> closeConnection() async {
    connection;
  }

  Future<List<PostgreSQLResultRow>> executeQuery(String query) async {
    final results = await connection.query(query);
    return results.toList();
  }
}




class TaskAdd extends StatefulWidget{
  const TaskAdd({super.key});

  @override
  TaskAddState createState() => TaskAddState();

}
class TaskAddState extends State<TaskAdd>{
  List data = [];
  @override
  initState() {
    listItems("welcome_calls".replaceAll(" ", "_"));
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
        print(latestFile.key);
        getTask(latestFile.key);
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
  Future<void> getTask(key) async {
    List<Map<String, dynamic>>  uniqueAgentList = [];

    try {
      StorageGetPropertiesResult<StorageItem> result =
      await Amplify.Storage.getProperties(
        key: key,
      ).result;
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;
      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      //List<dynamic> jsonDataList = jsonDecode(jsonData);
      for (var item in jsonData) {
        String agent = item['Agent'];
        String unreachabilityRate = item['%Unreachabled rate within SLA'];
        Map<String, String> dataagent = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        Map<String, dynamic> dataItem = {
          'display': '$agent - $unreachabilityRate',
          'value': '$agent - $unreachabilityRate',
        };
        data.add(dataItem);
        uniqueAgentList.add(dataItem);
      }

      setState(() {
        safePrint('File team: $uniqueAgentList');
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          const Text("Visiting unreachable welcome call clients"),
          Text("Visiting unreachable welcome call clients".replaceAll(" ", "_")),
          Text("Visiting unreachable welcome call clients".replaceAll(" ", "_")),
        ],
      ),

    );
  }

}