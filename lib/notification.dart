

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class UserNotification extends StatefulWidget {




  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {

  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  Future<void> updateUserToken(String userId) async {
    // Get the user's FCM token
    String? token = await FirebaseMessaging.instance.getToken();

    // Update the user's document with their FCM token
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'fcmToken': token
    });
    print("Dennis $token");
  }
  @override
  void initState() {
    // TODO: implement initState
    updateUserToken(currentUser);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),

      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: const Icon(Icons.list),
                trailing: const Text(
                  "notificationAlert",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("$messageTitle"));
          }),

    );
  }
}