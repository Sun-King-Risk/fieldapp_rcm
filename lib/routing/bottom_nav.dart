


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../utils/themes/theme.dart';
import '../../task.dart';
import '../../dashboard.dart';

class NavPage extends StatefulWidget{
  const NavPage({super.key});

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
      const Home(),
      const Task(),

    /*AreaDashboard(),
    Customer(),*/
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:SKAppBar(height: 70, context: context,),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.black87,
              color: Colors.black,
              tabs: const [
              /* GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),*/
                GButton(
                  icon: Icons.task,
                  text: 'Dashboard',
                ),
                  GButton(
                  icon: Icons.phone,
                  text: 'Task',
                ),
                GButton(
                  icon: Icons.phone,
                  text: 'Task',
                )
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

