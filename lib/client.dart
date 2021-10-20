import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/admin_login.dart';
import 'package:khatabook/clientdetails.dart';
import 'package:khatabook/model/client_bottomsheet.dart';
import 'package:khatabook/model/clientlist.dart';
import 'package:http/http.dart' as http;
import 'package:khatabook/model/update_client_bottomsheet.dart';
import 'package:khatabook/sample_clientdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'controller/getcontroller.dart';
class client extends StatefulWidget {
  const client({Key? key}) : super(key: key);

  @override
  _clientState createState() => _clientState();
}


class _clientState extends State<client> {
  final TextEditingController emailEditingController=TextEditingController();
  List<clientlist> data_details=[];
  List<clientlist> member_list=[];
  List<clientlist> contain_filter=[];
  bool data_filter=false;
  TextEditingController searchcontroller=TextEditingController();
  final getcontroller c = Get.put(getcontroller());
  bool state=false;
  late String state_checker="false";
  bool state_update=false;
  late  String clientname;
  late  String subtitle;
  String? id;
  String uid='';
  String username='';
  String password='';
  String nav_screen="client";



  Future _getData() async {
    var response = await http.post(Uri.parse("http://khatabook.nirajganesh.com/client.php"));
    var data = jsonDecode(response.body);
    var dataarray=data['store'];
    data_details.clear();
    print(dataarray);
    for(var clientdata in dataarray)
    {
      clientlist listdata=clientlist(clientdata['id'],clientdata['name'],clientdata['subtitle'],clientdata['amount'],clientdata['cat']);
      data_details.add(listdata);
    }
    return data_details;
  }

  Future _getFilterData() async {
    var response = await http.post(Uri.parse("http://khatabook.nirajganesh.com/client.php"));
    var data = jsonDecode(response.body);
    var dataarray=data['store'];
    data_details.clear();
    for(var clientdata in dataarray)
    {
      clientlist listdata=clientlist(clientdata['id'],clientdata['name'],clientdata['subtitle'],clientdata['amount'],clientdata['cat']);
      data_details.add(listdata);
    }
    c.state_change=RxInt(0);
    return data_details;
  }

  _AddData() async {
      var url= Uri.parse('http://khatabook.nirajganesh.com/Add_client.php');
      http.post(url, body: {'name':clientname, 'subtitle':subtitle,'cat':"no"}
      ).then((res){
        if(res.statusCode==200)
        {
          setState(() {
            data_filter=true;
          });
          Fluttertoast.showToast(
              msg: "Successfully Added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0
          );
        }
        else
        {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0
          );
        }
      });
  }

  _DeleteData() async {
    var url= Uri.parse('http://khatabook.nirajganesh.com/Delete_client.php');
    http.post(url, body: {'id':id}
    ).then((res){
      if(res.statusCode==200)
      {
        setState(() {
          data_filter=true;
        });
        Fluttertoast.showToast(
            msg: "Successfully delete data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
      else
      {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
    });
  }

  _UpdateData() async {
    var url= Uri.parse('http://khatabook.nirajganesh.com/Update_client.php');
    http.post(url, body: {'id':id,'name':clientname,'subtitle':subtitle}
    ).then((res){
      if(res.statusCode==200)
      {
        setState(() {
          data_filter=true;
        });
        Fluttertoast.showToast(
            msg: "Successfully Update Data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
      else
      {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
    });
  }


  filter_memberlist()
  {
    List<clientlist> _details=[];
    _details.addAll(data_details);
    if(searchcontroller.text.isNotEmpty)
    {
      _details.retainWhere((data_details){
        String searchterm=searchcontroller.text.toLowerCase();
        String name=data_details.name.toLowerCase();
        String subtitle=data_details.subtitle.toLowerCase();
        return name.contains(searchterm) || subtitle.contains(searchterm);
      });
      setState(() {
        contain_filter.clear();
        contain_filter=_details;
      });
    }
    else
    {
      if(data_filter==true)
      {
        setState(() {
          _details.clear();
         // _details.addAll(data_details);
        });
      }
      else
      {
        setState(() {
          _details.addAll(data_details);
        });
      }
    }
  }

  Future shareprefs_dec() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      uid=prefs.getString("uid")!;
      username=prefs.getString("username")!;
      password=prefs.getString("password")!;
    });
  }
  Future shareprefs_delete() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('uid');
      prefs.remove('username');
      prefs.remove('password');
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchcontroller.addListener(() {
      filter_memberlist();
    });
  }

  Future<Null> refreshlist() async{
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=searchcontroller.text.isNotEmpty;
    return Scaffold(
      body: Container(
          color: HexColor("#16697A").withOpacity(0.1),
            child:Column(
               children: [
                 SizedBox(height:50),
                 Align(
                   alignment: Alignment.topCenter,
                   child: GestureDetector(
                     onTap: (){
                       Fluttertoast.showToast(
                           msg: "Log Out",
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.BOTTOM,
                           backgroundColor: Colors.white,
                           textColor: Colors.black,
                           fontSize: 16.0
                       );
                       shareprefs_delete();
                       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                           admin_login()), (Route<dynamic> route) => false);
                     },
                     child: Text(
                       "Log out",style: (TextStyle(color: HexColor("#F30808"),fontSize: 16,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                     ),
                   )
                 ),
                 Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                       Expanded(
                         flex:5,
                         child: Container(
                            alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                  ),
                  height: 44,
                         child: TextField(controller: searchcontroller,
                          keyboardType: TextInputType.emailAddress,
                         style: TextStyle(
                           color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black38,
                          ),
                          hintText: 'Enter the client name..',
                          hintStyle: TextStyle(
                              color: Colors.black38,fontFamily:'Montserrat'
                          )
                    ),
                  ),
                ),
                       ),
                       SizedBox(width: 30,),
                       Expanded(
                         flex:1,
                         child: Container(
                  child:Container(
                    width: 50,
                    // ignore: deprecated_member_use
                    child:FlatButton(
                      padding: EdgeInsets.only(top: 12, bottom:12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                      ),
                      color: HexColor("#f2af29"),
                      onPressed: () {

                      },
                      child: Icon(Icons.search,color: Colors.white,),
                    ),
                  ),
                ),
                       ),
              ],
            )
        ),
                 Padding(
                   padding: const EdgeInsets.only(top:20.0,left:20.0,right:20),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Client List",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                       ),
                       Row(
                         children: [
                           Icon(Icons.add_circle_outline,color:HexColor("#f2af29"),),
                           SizedBox(width: 2,),
                           GestureDetector(
                             onTap: (){
                              // setState(() {
                                 state=true;
                                 state_checker="Add";
                             //  });
                                 _displayBottomSheet();
                             },
                             child: Text(
                               "Add New Client",style: (TextStyle(color: HexColor("#f2af29"),fontSize: 16,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                             ),
                           )
                         ],
                       )
                     ],
                   ),
                 ),
                 Flexible(
                   child: Container(
                       child:FutureBuilder(
                         future:data_filter==true?_getFilterData():_getData(),
                         //future: future_data,
                         builder:(context,snapshot)
                         {
                           if(c.state_change.toString()=='1')
                           {
                             return Container(
                               child: Center(
                                 child:Shimmer.fromColors(baseColor: HexColor("#ffffff"), highlightColor: HexColor("#16697a").withOpacity(0.1),
                                   child: Container(
                                     child: Column(
                                       children: <Widget>[
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),

                                               ),
                                             ),
                                           ),

                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),

                                               ),
                                             ),
                                           ),

                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),

                                               ),
                                             ),
                                           ),

                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ),
                                           ),

                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             );
                           }
                           if(snapshot.connectionState==ConnectionState.waiting)
                           {
                             return Container(
                               child: Center(
                                 child:Shimmer.fromColors(baseColor: HexColor("#ffffff"), highlightColor: HexColor("#16697a").withOpacity(0.1),
                                   child: Container(
                                     child: Column(
                                       children: <Widget>[
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),

                                               ),
                                             ),
                                           ),

                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),

                                               ),
                                             ),
                                           ),

                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),

                                               ),
                                             ),
                                           ),

                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child:Card(
                                             color: Colors.white,
                                             child: Padding(
                                               padding: EdgeInsets.all(5),
                                               child: Container(
                                                 child:Column(
                                                   children: <Widget>[
                                                     Row(
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children:<Widget> [
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                         Container(
                                                           width: 50,
                                                           height: 10,
                                                           alignment: Alignment.topLeft,
                                                           decoration: BoxDecoration(
                                                             color: Colors.black26,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ),
                                           ),

                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             );
                           }
                           else
                           {
                             if(data_details.length!=0)
                             {
                               return ListView.builder(itemCount: issearching==true?contain_filter.length:data_details.length,
                                   scrollDirection: Axis.vertical,
                                   shrinkWrap: true,
                                   itemBuilder: (context,index){
                                     clientlist member_data=issearching==true?contain_filter[index]:data_details[index];
                                     return Padding(
                                       padding: EdgeInsets.only(top: 0,bottom: 8,left:5,right: 5),
                                       child:GestureDetector(
                                         onTap: (){
                                           Navigator.push(context, MaterialPageRoute(builder: (context) =>sample_clientdetails(clientname:member_data.name,amount:member_data.amount,id:member_data.id,account:member_data.cat,nav_screen:nav_screen)),);
                                         },
                                         child: Card(
                                           color: HexColor("#ffffff"),
                                           shape:RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(6.0),
                                           ),
                                           child:Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Column(
                                               children: <Widget>[
                                                 Row(
                                                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                   children: <Widget>[
                                                       Text(
                                                         member_data.name,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                                       ),
                                                   ],
                                                 ),
                                                 Row(
                                                     mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                   children:[
                                                     Text(
                                                       member_data.subtitle,style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.2),fontSize: 14,fontFamily:'Montserrat_bold')),
                                                     ),
                                                     Row(
                                                       children: [
                                                         Container(
                                                           width: 40,
                                                           height: 40,
                                                           // ignore: deprecated_member_use
                                                           child:FlatButton(
                                                             padding: EdgeInsets.only(top: 12, bottom:12),
                                                             shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius.circular(10),
                                                             ),
                                                             color: HexColor("#f2af29"),
                                                             onPressed: () {
                                                                //setState(() {
                                                                  state_checker="update";
                                                                  state_update=true;
                                                                  clientname=member_data.name;
                                                                  subtitle=member_data.subtitle;
                                                                  id=member_data.id;
                                                              // });
                                                                 _displayBottomSheet();
                                                             },
                                                             child:Padding(
                                                               padding: EdgeInsets.all(1),
                                                               child:Icon(Icons.edit,color: Colors.white,size: 15,),
                                                             ),
                                                           ),
                                                         ),
                                                         SizedBox(width: 15,),
                                                         Container(
                                                           width: 40,
                                                           height: 40,
                                                           // ignore: deprecated_member_use
                                                           child:FlatButton(
                                                             padding: EdgeInsets.only(top: 12, bottom:12),
                                                             shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius.circular(10),
                                                             ),
                                                             color: HexColor("#F30808"),
                                                             onPressed: () {
                                                               showDialog(
                                                                   context: context,
                                                                   builder:(ctx)=>AlertDialog(
                                                                     title: Center(
                                                                       child: Text(
                                                                         "Alert for Delete",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                                                                       ),
                                                                     ),
                                                                     content: Padding(
                                                                       padding: const EdgeInsets.only(left:12.0,right:12.0),
                                                                       child: Text(
                                                                           "Do yow want to delete the client in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
                                                                         ),
                                                                     ),

                                                                     actions: <Widget>[
                                                                       Row(
                                                                         mainAxisAlignment:MainAxisAlignment.center,
                                                                         children: [
                                                                           FlatButton(
                                                                             onPressed: () {
                                                                               Navigator.of(ctx).pop();
                                                                             },
                                                                             shape: RoundedRectangleBorder(
                                                                               side: BorderSide(
                                                                                   width: 1,
                                                                                   color:Colors.black,
                                                                               ),
                                                                               borderRadius: BorderRadius.circular(10),
                                                                             ),

                                                                             child: Text("No"),
                                                                           ),
                                                                           SizedBox(width:6),
                                                                           FlatButton(
                                                                             onPressed: () {
                                                                               setState(() {
                                                                                 Navigator.of(ctx).pop();
                                                                                 data_details.clear();
                                                                                 state=false;
                                                                                 id=member_data.id;
                                                                                 _DeleteData();
                                                                                 c.state_change=RxInt(1);
                                                                               });
                                                                             },
                                                                             shape: RoundedRectangleBorder(
                                                                               borderRadius: BorderRadius.circular(10),
                                                                             ),
                                                                             color: HexColor("#F30808"),
                                                                             child: Text("Yes",style:(TextStyle(color: Colors.white)),),
                                                                           ),
                                                                         ],
                                                                       )
                                                                     ],
                                                                   )
                                                               );
                                                             },
                                                             child:Padding(
                                                               padding: EdgeInsets.all(1),
                                                               child:Icon(Icons.delete,color: Colors.white,size: 15,),
                                                             ),
                                                           ),
                                                         ),
                                                       ],
                                                     )
                                                   ]
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ),
                                     );
                                   });
                             }
                             else
                             {
                               return Container(
                                 color: Colors.white,
                                 width: double.infinity,
                                 height: double.infinity,
                                 child:Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children:<Widget>[
                                     Text('No data found',style: TextStyle(color: Colors.white,fontSize: 16),),
                                   ],
                                 ),
                               );
                             }
                           }
                         },
                       )
                   ),),
            ],
         ),
        ),
    );
  }

  void _displayBottomSheet()
  {
    showModalBottomSheet(context: context, enableDrag: true,builder: (BuildContext co){
      return Container(
        child:state_checker!="false"? state_checker=="Add"?
        client_bottomsheet(
          close:(){
           // setState(() {
              state=false;
              state_checker="false";
              Navigator.pop(context);
            //});
          },
          submit:(){
            setState(() {
              data_details.clear();
              state=false;
              state_checker="false";
              clientname=client_bottomsheet.clientcontroller.text;
              if(client_bottomsheet.subtitlecontroller.text=='')
              {
                subtitle='No';
              }
              else
              {
                subtitle=client_bottomsheet.subtitlecontroller.text;
              }
              _AddData();
              client_bottomsheet.clientcontroller.clear();
              client_bottomsheet.subtitlecontroller.clear();
              c.state_change=RxInt(1);
              Navigator.pop(context);
            });
          },
        ): update_client_bottomsheet(
          close:(){
           // setState(() {
              state_update=false;
              state_checker="false";
              Navigator.pop(context);
           // });
          },
          update:(){
            setState(() {
              data_details.clear();
              state_update=false;
              state_checker="false";
              clientname=update_client_bottomsheet.clientcontroller.text;
              if(update_client_bottomsheet.subtitlecontroller.text=='')
              {
                subtitle='No';
              }
              else
              {
                subtitle=update_client_bottomsheet.subtitlecontroller.text;
              }
              _UpdateData();
              c.state_change=RxInt(1);
              Navigator.pop(context);
            });
          },clientname: clientname,subtitle: subtitle,
        ):null,
      );
    });
  }

}
