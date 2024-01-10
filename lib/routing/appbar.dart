
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import '../main.dart';
import '../notification.dart';
import '../profile.dart';

class SKAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final BuildContext context; // Add this line

  void signOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginSignupApp()));
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  const SKAppBar({super.key, 
    required this.context, // Add this line
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
                builder: (context) => const UserNotification(),
              ));
        }, icon: const Icon(Icons.notifications)),
        IconButton(onPressed: (){
          signOut(context); // Pass the context here
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        }, icon: const Icon(Icons.logout)),
      ],
      leading: IconButton(onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Profile(),
            ));
      }, icon: const Icon(Icons.person)),
    );
  }
}

