

import 'dart:convert';
import 'dart:io';
import 'package:fieldapp_rcm/area/dashboard.dart';
import 'package:fieldapp_rcm/services/user_detail.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis/fcm/v1.dart' as fcm;
import 'package:fieldapp_rcm/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart'as http;
import '../area/acl_task.dart';
import 'appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../utils/themes/theme.dart';
import '../../task.dart';
import '../../dashboard.dart';

class NavPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NavPagePageState();
  }

}
class NavPagePageState extends State<NavPage> {
  late String role;
  final String keyFilePath = 'google_fcm.json';
  final String projectId = 'fieldapp-a7447';
  final fileName = 'google_fcm.json';

  final messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


 @override
  void dispose() {
   super.dispose();
 }
 late String? tokenId;
 @override
 void initState(){
   super.initState();
   // reguest permission
   requestPermission();
   //get token and save to firestore
   getToken();
 }
 void getToken() async {
   String? userId  = _auth.currentUser?.uid;
   String? token = await messaging.getToken();
   setState(() {
     tokenId = token;
   });
   // Update the user's document with their FCM token
   firestore.collection('Users').where('UID', isEqualTo: userId).get().then((value) {
     value.docs.forEach((element) {
       FirebaseFirestore.instance.collection('Users').doc(element.id).update({
         'Token': token
       });
     });
   });
 }
  Future<void> sendFCMNotification(String deviceToken, String title, String body) async {
    final String serverKey = 'AAAAya62xSc:APA91bGUjqUqPuBqFbrUPgknT3BEnYmQs1b2iRuzdJcS5etSbMgDvDjQocvCmMSnlcRwdrKxHTwfsPSlU0tbtTqiH5ZIkAoiZZmkeNIRTkMCvDJRTsEd_-adCFji2utZHAPgGKhO3byd'; // Replace with your server key
    final String url = 'https://fcm.googleapis.com/fcm/send';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final Map<String, dynamic> data = {
      'notification': {
        title: 'Your request has been approved',
        body: 'You can now proceed with your task',
      },
      'priority':'high',
      'to':deviceToken
    };
    final String encodedData = json.encode(data);

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: encodedData,
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Error sending notification.');
      print('HTTP status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void requestPermission() async {

   final settings = await messaging.requestPermission(
     alert: true,
     announcement: false,
     badge: true,
     carPlay: false,
     criticalAlert: false,
     provisional: false,
     sound: true,
   );
   if(settings.authorizationStatus == AuthorizationStatus.authorized){
     print('user granted permission');
   }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
     print('user granted provisional permission');
   }else{
     print('user declined or has not accepted permission');

   }
 }
  int _selectedIndex = 0;
  final List<Widget> _tabs = <Widget>[

      Home(),
      Task(),
    /*AreaDashboard(),
    Customer(),*/
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:SKAppBar(height: 70,),
      body: Container(
          child: _tabs.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.mycolor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(

              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColor.mycolor,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.black87,
              color: Colors.black,
              tabs: const [
              /* GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),*/
                GButton(
                  icon: Icons.task,
                  text: 'task',
                ),
                  GButton(
                  icon: Icons.phone,
                  text: 'Customer',
                ),
              ],
              onTabChange: (index){
                setState(() {
                  _selectedIndex= index;
                });
              },

            ),
          ),
        ),
      ),
    );
  }
}

