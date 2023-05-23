
import 'package:flutter/material.dart';

import '../login.dart';
import '../notification.dart';
import '../profile.dart';
import '../services/auth_services.dart';


class SKAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

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
          Authentication.signOut();
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

