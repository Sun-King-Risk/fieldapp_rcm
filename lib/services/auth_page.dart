

import 'package:fieldapp_rcm/login.dart';
import 'package:fieldapp_rcm/services/auth_services.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:flutter/material.dart';

import '../dashboard.dart';

class AuthCheck extends StatefulWidget {
  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {

  bool isLogin = false;

  @override
  void initState() {

    if("user" != null){
      isLogin = true;
    }else{
      isLogin = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return Home();
    }else{
      return Login();
    }


  }
}
