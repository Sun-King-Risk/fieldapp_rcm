import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/aws_bucket.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fieldapp_rcm/routing/nav_page.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicecontrol/v2.dart';
import 'package:http/http.dart' as http;
import 'package:aws_s3_private_flutter/aws_s3_private_flutter.dart';
import 'package:aws_s3_private_flutter/export.dart';

import 'add_task.dart';
import 'amplifyconfiguration.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(const MyApp());
}
Future<void> _configureAmplify() async {
  try {
    final storage = AmplifyStorageS3();
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugins([
      auth,
      storage,

    ]);

    await Amplify.configure(amplifyconfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUserAttributes();
  }
  void getUserAttributes() async {
    try {
      AuthUser currentUser = await Amplify.Auth.getCurrentUser();
      AuthUser userAttributes =
      await Amplify.Auth.getCurrentUser();

      // Process the user attributes

        print('$userAttributes');
    } catch (e) {
      print('Error retrieving user attributes: $e');
    }
  }
  Future<void> downloadToMemory(String key) async {
    try {
      final result = await Amplify.Storage.downloadData(
        key: key,

        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;

      safePrint('Downloaded data: ${result.bytes}');
    } on StorageException catch (e) {
      safePrint(key+e.message);
    }
  }
  Future<void> getFileFromS3Bucket() async {
    try {
      // Replace `key` with the actual key of the file in your S3 bucket
      final String key = 'example.txt';

      // Get the pre-signed URL for the file
      final urlResult = await Amplify.Storage.getUrl(
        key: key,
      );

      // Download the file using the URL
      final response = await http.get(urlResult as Uri);

      // Handle the downloaded file as needed
      // For example, you can save it to local storage
      // or process its content

      // Print the file content
      print(response.body);
    } catch (e) {
      print('Error retrieving file from S3 bucket: $e');
    }
  }

  Future<void> listItems() async {
    try {
      final result = await Amplify.Storage.list();
      final items = result.toString();
      safePrint('Got items: $items');
      List listResult = await Amplify.Storage.list() as List;
      for (StorageItem item in listResult) {
        print('Key: ${item.key}, Size: ${item.size}');
      }
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
  }

  Future<void> uploadExampleData() async {
    const dataString = 'Example file contents';

    try {
      final result = await Amplify.Storage.uploadData(
        data: S3DataPayload.string(dataString),
        key: 'ExampleKey',
        onProgress: (progress) {
          safePrint('Transferred bytes: ${progress.transferredBytes}');
        },
      ).result;

      safePrint('Uploaded data to location: ${result.uploadedItem.key}');
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> getFileProperties() async {
    try {
      final result = await Amplify.Storage.getProperties(
        key: 's3://Agents_with_low_welcome_calls_2023-05-05T0940_wyTm57.json',
      ).result;

      safePrint('File size: ${result.storageItem.size}');
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    late String selectedTask='';
    late String selectedSubTask='';
    late String regionselected ='';
    late String areaselected ='';
    late String agentselected= '';
    late String priority = '';
    late String target;
    List? _myActivities;
    return Authenticator(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        home:AddTask(),
      ),
    );
  }
}