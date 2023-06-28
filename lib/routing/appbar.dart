
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../login.dart';
import '../notification.dart';
import '../profile.dart';
import '../services/auth_services.dart';


class SKAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  void signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  SKAppBar({
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      elevation: 7,
      centerTitle: true,
      actions: [
        IconButton(onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>UserNotification(),
              ));
        }, icon: Icon(Icons.notifications)),
        IconButton(onPressed: (){
          signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Login(

              ),
            ),
          );
        }, icon: Icon(Icons.logout)),
      ],
      leading:IconButton(onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>Profile(),
            ));
      }, icon: Icon(Icons.person,)),


    );
  }
}

