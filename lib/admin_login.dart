
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:khatabook/due.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class admin_login extends StatefulWidget {

  @override
  _admin_loginState createState() => _admin_loginState();
}

class _admin_loginState extends State<admin_login> {

  bool isRemeberme = false;
  var url;
  var res;
  var msg;
  late String email;
  late String password;
  String login="login";
  var response;
  bool hiddenpassword=true;
  bool loading=false;
  late http.Response respo;
  late Map<String,String> headers;
  final TextEditingController emailEditingController=TextEditingController();
  final TextEditingController passwordEditingcontroller= TextEditingController();
  bool visibles=true;
  late SharedPreferences sharedpreferenced;


  @override
  Widget build(BuildContext context) {

    Widget buildusername()
    {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(0,2),
                  )
                ]
            ),
            height: 45,
            child: TextField(
              controller: emailEditingController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'Montserrat_regular',
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black38,
                  ),
                  hintText: 'User name',
                  hintStyle: TextStyle(
                      color: Colors.black38,
                    fontFamily: 'Montserrat_regular',
                  )
              ),
            ),
          )
        ],
      );
    }

    Widget buildPassword()
    {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(0,2),
                  )
                ]
            ),
            height: 45,
            child: TextField(
              controller: passwordEditingcontroller,
              obscureText: hiddenpassword,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'Montserrat_regular',
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock, color: Colors.black38,),
                  suffixIcon: IconButton(
                    icon:Icon(hiddenpassword ?Icons.visibility_off :Icons.visibility),
                    onPressed: (){
                      setState(() {
                        hiddenpassword=!hiddenpassword;
                      });
                    },
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            ),
          ),

        ],
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: HexColor("#16697A").withOpacity(0.1),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 120
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/khatabook_logo.png',height: 100.0,),
                        SizedBox(height: 20,),
                        Text(
                          'Admin login',
                          style: TextStyle(
                            color:HexColor("#16697A"),
                            fontSize: 25,
                              fontFamily:'Montserrat_regular'
                          ),
                        ),
                        SizedBox(height: 50,),
                        buildusername(),
                        SizedBox(height: 20,),
                        buildPassword(),
                        SizedBox(height: 40,),
                        ArgonButton(
                          height: 42,
                          width: 350,
                          borderRadius: 5.0,
                          color: HexColor("#f2af29"),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily:'Montserrat_regular'
                            ),
                          ),
                          loader: Container(
                            padding: EdgeInsets.all(10),
                            child: SpinKitRotatingCircle(
                              color: Colors.white,
                              // size: loaderWidth ,
                            ),
                          ),
                          onTap: (startLoading, stopLoading, btnState) async {
                            if(btnState == ButtonState.Idle){
                              startLoading();
                              sharedpreferenced=await SharedPreferences.getInstance();
                              try
                              {
                                url= Uri.parse('http://khatabook.nirajganesh.com/Login.php');
                                http.post(url,body: {'username': emailEditingController.text, 'password': passwordEditingcontroller.text}
                                ).then((res){
                                  var jsondata=jsonDecode(res.body);
                                  print(jsondata);
                                  if(jsondata['status']=="success")
                                  {
                                    stopLoading();
                                    Fluttertoast.showToast(
                                        msg: "Successfully login",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
                                    sharedpreferenced.setString("uid","1");
                                    sharedpreferenced.setString("username",emailEditingController.text.toString());
                                    sharedpreferenced.setString("password",passwordEditingcontroller.text.toString());
                                    sharedpreferenced.commit();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                                        home()), (Route<dynamic> route) => false);
                                  }
                                  else
                                  {
                                    stopLoading();
                                    Fluttertoast.showToast(
                                        msg: "Invalid username or password.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
                                  }
                                });
                              }catch(e)
                              {
                                Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black38,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            }
                          },
                        )

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}




