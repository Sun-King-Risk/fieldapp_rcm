

import 'package:flutter/material.dart';


class UserNotification extends StatefulWidget {
  const UserNotification({super.key});





  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),

      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return const ListTile(
                leading: Icon(Icons.list),
                trailing: Text(
                  "notificationAlert",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("messageTitle"));
          }),

    );
  }
}