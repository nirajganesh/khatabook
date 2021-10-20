import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/admin_login.dart';
import 'package:khatabook/due.dart';
import 'package:shared_preferences/shared_preferences.dart';
class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {

  var username;
  var password;
  var uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(Duration(seconds: 4),()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
    //     home()), (Route<dynamic> route) => false));
    getSharedPrefs(username,password,context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#16697A").withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/khatabook_logo.png',height: 190.0,),
            SizedBox(height: 10,),
            SpinKitChasingDots(
              color: HexColor("#f2af29"),
              size: 40.0,
            )
          ],
        ),
      ),
    );
  }

  Future<Null> getSharedPrefs(var branch_id,var gym_name,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username=prefs.getString("username");
    password=prefs.getString("password");
    uid=prefs.getString("uid");
    if(uid==null)
    {
      Timer(Duration(seconds: 4),()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          admin_login()), (Route<dynamic> route) => false));
    }
    else
    {
      Timer(Duration(seconds: 4),()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          home()), (Route<dynamic> route) => false));
    }
  }
}
