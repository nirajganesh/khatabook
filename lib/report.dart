import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/clientdetails.dart';
import 'package:khatabook/controller/getcontroller.dart';

import 'model/clientlist.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class report extends StatefulWidget {
  const report({Key? key}) : super(key: key);

  @override
  _reportState createState() => _reportState();
}

class _reportState extends State<report> {

  List<clientlist> data_details=[];
  List<clientlist> member_list=[];
  List<clientlist> contain_filter=[];
  bool data_filter=false;
  TextEditingController searchcontroller=TextEditingController();
  final getcontroller c = Get.put(getcontroller());
  DateTime _dateTime=DateTime.now();
  DateTime _dateTimefrom=DateTime.now();
  String nav_screen="report";

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
          //_details.addAll(data_details);
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchcontroller.addListener(() {
      filter_memberlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=searchcontroller.text.isNotEmpty;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Credit in September",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 12,fontFamily:'Montserrat_regular')),
                      ),
                      Text(
                        "Total Credit in September",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 12,fontFamily:'Montserrat_regular')),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ 62000",style: (TextStyle(color: HexColor("#71b340"),fontSize: 20,fontFamily:'Montserrat_bold')),
                      ),
                      Text(
                        "₹ 2000",style: (TextStyle(color: HexColor("#F30808"),fontSize: 20,fontFamily:'Montserrat_bold')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: HexColor("#16697A").withOpacity(0.1),
              child: Column(
                children: [
                  SizedBox(height:10),
                  Padding(
                      padding: EdgeInsets.all(13),
                      child: Row(
                        children: [
                          Expanded(
                            flex:3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 44,
                              child:Padding(
                                  padding: const EdgeInsets.only(left:8,right:8),
                                  child: Container(
                                     color: HexColor("#ffffff"),
                                     child: GestureDetector(
                                       onTap: (){
                                         showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                                           setState(() {
                                             _dateTime=date!;
                                           });
                                         });
                                       },
                                       child: Row(
                                         children: [
                                           Icon(Icons.date_range,color: Colors.black38,),
                                           SizedBox(width:5),
                                           Text(
                                             "${_dateTime.toLocal()}".split(' ')[0],style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.4),fontSize: 14,fontFamily:'Montserrat_regular')),
                                           ),
                                         ],
                                       ),
                                     ),
                                  ),
                                ),

                              ),
                            ),
                          SizedBox(width: 6,),
                          Text(
                            "To",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.4),fontSize: 14,fontFamily:'Montserrat_bold')),
                          ),
                          SizedBox(width: 6,),
                          Expanded(
                            flex:3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 44,
                              child:Padding(
                                padding: const EdgeInsets.only(left:8,right:8),
                                child: Container(
                                  color: HexColor("#ffffff"),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                                        setState(() {
                                          _dateTimefrom=date!;
                                        });
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range,color: Colors.black38,),
                                        SizedBox(width:5),
                                        Text(
                                          "${_dateTimefrom.toLocal()}".split(' ')[0],style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.4),fontSize: 14,fontFamily:'Montserrat_regular')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ),
                          ),
                          SizedBox(width: 6,),
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
                      children: [
                        Text(
                          "Due Client List",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
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
                                                padding: EdgeInsets.all(10),
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
                                                padding: EdgeInsets.all(10),
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
                                                padding: EdgeInsets.all(10),
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
                                                padding: EdgeInsets.all(10),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            if(!snapshot.hasData)
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
                              if(data_details.length.toString()!="0")
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
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>clientdetails(clientname:member_data.name,amount:member_data.amount,id:member_data.id,account:member_data.cat,nav_screen:nav_screen)),);
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
                                                      Text(
                                                        "₹ 2000",style: (TextStyle(color: HexColor("#71b340"),fontSize: 18,fontFamily:'Montserrat_bold')),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        member_data.subtitle,style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.2),fontSize: 14,fontFamily:'Montserrat_bold')),
                                                      ),
                                                    ],
                                                  )
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
                                  color: Colors.black,
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
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
