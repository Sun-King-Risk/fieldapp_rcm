import 'package:fieldapp_rcm/login.dart';
import 'package:fieldapp_rcm/routing/bottom_nav.dart';
import 'package:fieldapp_rcm/services/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';








class Authentication {


  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }





  }
