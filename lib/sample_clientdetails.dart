import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/controller/getcontroller.dart';
import 'package:khatabook/due.dart';
import 'package:khatabook/model/entry_bottomsheet.dart';
import 'package:khatabook/model/entrylist.dart';
import 'package:http/http.dart' as http;
import 'package:khatabook/model/update_entry_bottomsheet.dart';
import 'package:shimmer/shimmer.dart';


class sample_clientdetails extends StatefulWidget {
  final String clientname;
  final String amount;
  final String id;
  final String account;
  final String nav_screen;
  const sample_clientdetails({
    required this.clientname,
    required this.amount,
    required this.id,
    required this.account,
    required this.nav_screen,
    Key? key}) : super(key: key);

  @override
  _sample_clientdetailsState createState() => _sample_clientdetailsState();
}

class _sample_clientdetailsState extends State<sample_clientdetails> {

  List<entrylist> data_details=[];
  List<entrylist> member_list=[];
  List<entrylist> contain_filter=[];
  bool data_filter=false;
  TextEditingController searchcontroller=TextEditingController();
  final getcontroller c = Get.put(getcontroller());
  bool state=false;
  late String state_checker="false";
  bool state_update=false;
  late String date_value;
  late String amount_value;
  late String account_type;
  late String particular;
  late  String clientname;
  late  String subtitle;
  late String eid;
  late String cid;
  late String old_amount;
  late String old_account;
  String loading="True";
 // final _gKey = new GlobalKey<ScaffoldState>();





  Future _getData() async {
    setState(() {
      loading="False";
    });
    var response = await http.post(Uri.parse("http://khatabook.nirajganesh.com/Entry.php"),body: {'cid':widget.id});
    var data = jsonDecode(response.body);
    var dataarray=data['data'];
    data_details.clear();
    c.value_null();
    print(dataarray);
    for(var entrydata in dataarray)
    {
      entrylist listdata=entrylist(entrydata['id'],entrydata['cid'],entrydata['date'],entrydata['particular'],entrydata['amount'],entrydata['account_type'],entrydata['total_debit'],entrydata['total_credit']);
      data_details.add(listdata);
      c.update_debit(entrydata['total_debit']);
      c.update_credit(entrydata['total_credit']);
    }
    c.account_details();
    return data_details;
  }

  Future _getFilterData() async {
    var response = await http.post(Uri.parse("http://khatabook.nirajganesh.com/Entry.php"),body: {'cid':widget.id});
    var data = jsonDecode(response.body);
    var dataarray=data['data'];
    data_details.clear();
    print(dataarray);
    c.value_null();
    for(var entrydata in dataarray)
    {
      entrylist listdata=entrylist(entrydata['id'],entrydata['cid'],entrydata['date'],entrydata['particular'],entrydata['amount'],entrydata['account_type'],entrydata['total_debit'],entrydata['total_credit']);
      data_details.add(listdata);
      c.update_debit(entrydata['total_debit']);
      c.update_credit(entrydata['total_credit']);
    }
    c.account_details();
    c.state_change=RxInt(0);
    return data_details;
  }

  _AddData() async {
    var url= Uri.parse('http://khatabook.nirajganesh.com/Add_entry.php');
    http.post(url, body: {'cid':widget.id, 'date':date_value,'particular':particular,'amount':amount_value,'account_type':account_type}
    ).then((res){
      if(res.statusCode==200)
      {
        setState(() {
          data_filter=true;
          c.state_change=RxInt(1);
        });
        Fluttertoast.showToast(
            msg: "Successfully Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
        Navigator.pop(context);
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
    var url= Uri.parse('http://khatabook.nirajganesh.com/Entry_update.php');
    http.post(url, body: {'eid':eid,'cid':cid,'date':date_value,'particular':particular,'amount':amount_value,'account_type':account_type
      ,'old_amount':old_amount,'old_account':old_account}
    ).then((res){
      if(res.statusCode==200)
      {
        setState(() {
          data_filter=true;
          c.state_change=RxInt(1);
        });
        Fluttertoast.showToast(
            msg: "Successfully Update Data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
        update_entry_bottomsheet.datecontroller.clear();
        update_entry_bottomsheet.amountcontroller.clear();
        update_entry_bottomsheet.particularcontroller.clear();
        update_entry_bottomsheet.accountcontroller.clear();
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
        update_entry_bottomsheet.datecontroller.clear();
        update_entry_bottomsheet.amountcontroller.clear();
        update_entry_bottomsheet.particularcontroller.clear();
        update_entry_bottomsheet.accountcontroller.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>
          back_track(),
      child: Scaffold(
       // key: _gKey,
        bottomSheet: state_checker!="false"? state_checker=="Add"?
        entry_bottomsheet(
          close:(){
            setState(() {
              state=false;
              state_checker="false";
            });
          },
          submit:(){
            setState(() {
              data_details.clear();
              state=false;
              state_checker="false";
              date_value=entry_bottomsheet.to_date_value;
              amount_value=entry_bottomsheet.amount_controller.text.toString();
              account_type=entry_bottomsheet.account_controller.text.toString();

              // print(date_value);
              // print(amount_value);
              // print(particular);
              // print(account_type);
              if(update_entry_bottomsheet.particularcontroller.text=='Other')
              {
                if(entry_bottomsheet.other_controller.text.toString()=='')
                {
                  particular="No";
                }
                else
                {
                  particular=entry_bottomsheet.other_controller.text.toString();
                }
              }
              else
              {
                particular=entry_bottomsheet.particular_controller.text.toString();
              }
              _AddData();
              print(data_details);
            });
          },
        ):update_entry_bottomsheet(cid: cid,eid:eid,date:date_value,particular:particular,amount:amount_value,account_type: account_type,
          close:(){
            setState(() {
              state_update=false;
              state_checker="false";
            });
          },
          update:(){
            setState(() {
              data_details.clear();
              state_update=false;
              state_checker="false";
              date_value=update_entry_bottomsheet.datecontroller.text.toString();
              amount_value=update_entry_bottomsheet.amountcontroller.text.toString();
              account_type=update_entry_bottomsheet.accountcontroller.text.toString();

              if(update_entry_bottomsheet.particularcontroller.text=="Other")
              {
                if(update_entry_bottomsheet.othercontroller.text=='')
                {
                  particular="No";
                }
                else
                {
                  particular=update_entry_bottomsheet.othercontroller.text.toString();
                }
              }
              else
              {
                particular=update_entry_bottomsheet.particularcontroller.text.toString();
              }
              _UpdateData();
            });
          },
        ):null,
        body: Column(
          children: [
            SizedBox(height: 40,),
            Container(
              color: HexColor("#ffffff"),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    GestureDetector(onTap: (){
                      if(widget.nav_screen=="due")
                      {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                            home()), (Route<dynamic> route) => false);
                      }
                      else
                      {
                        Navigator.pop(context);
                      }
                    }, child: Icon(Icons.arrow_back,color: HexColor("#0c0c0c"),)),
                    SizedBox(width: 15,),
                    Text(
                      widget.clientname,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_bold')),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GetBuilder<getcontroller>(
                            builder:(controller){
                              return
                                '${controller.account_type}'=='0'?
                                Text(
                                  "₹"+'${controller.balance.toString()}',style: (TextStyle(color: HexColor("#f2af29"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                ):
                                '${controller.account_type}'=='Debit'?
                                Text(
                                  "₹"+ '${controller.balance.toString()}',style: (TextStyle(color: HexColor("#F30808"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                ):
                                Text(
                                  "₹"+ '${controller.balance.toString()}',style: (TextStyle(color: HexColor("#71b340"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                );
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: HexColor("#16697A").withOpacity(0.1),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:20.0,left:20.0,right:20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Account Details",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                          ),
                          GestureDetector(
                            onTap: (){
                                // setState(() {
                                entry_bottomsheet.amount_controller.clear();
                                entry_bottomsheet.particular_controller.clear();
                                entry_bottomsheet.account_controller.clear();
                                entry_bottomsheet.other_controller.clear();
                                state=true;
                                state_checker="Add";
                              // });
                                _displayBottomSheet();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline,color:HexColor("#f2af29"),),
                                SizedBox(width: 2,),
                                Text(
                                  "Add New Entry",style: (TextStyle(color: HexColor("#f2af29"),fontSize: 16,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: HexColor("#ffffff"),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "DateTime",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                    ),
                                    Text(
                                      "Particular",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                    ),
                                    Text(
                                      "Debit",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                    ),
                                    Text(
                                      "Credit",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                    ),
                                    Text(
                                      "Action",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6,),
                                Divider(color: HexColor("#0c0c0c").withOpacity(0.3),height: 2,),
                                Divider(color: HexColor("#0c0c0c").withOpacity(0.3),height: 2,),
                                // SizedBox(height: 6,),
                                Container(
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
                                          if(data_details.length.toString()!="0")
                                          {
                                            return Container(
                                              constraints: BoxConstraints(
                                                maxHeight: 400.0,
                                              ),
                                              child: ListView.builder(itemCount:data_details.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context,index){
                                                    entrylist entryData=data_details[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 7),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              entryData.date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 12,fontFamily:'Montserrat_regular')),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15,),
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              entryData.particular,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 12,fontFamily:'Montserrat_regular')),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15,),
                                                          Expanded(
                                                            flex: 1,
                                                            child: entryData.account_type=='Debit'?
                                                            Text(
                                                              "₹"+entryData.amount.toString(),style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 12,fontFamily:'Montserrat_regular')),
                                                            ):
                                                            Text(
                                                              "-",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 12,fontFamily:'Montserrat_regular')),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15,),
                                                          Expanded(
                                                            flex:1,
                                                            child: entryData.account_type=='Credit'?
                                                            Text(
                                                              "₹"+entryData.amount.toString(),style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 12,fontFamily:'Montserrat_regular')),
                                                            ):
                                                            Text(
                                                              "-",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 12,fontFamily:'Montserrat_regular')),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          GestureDetector(
                                                            onTap: (){

                                                            },
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              // ignore: deprecated_member_use
                                                              child:FlatButton(
                                                                padding: EdgeInsets.only(top: 3, bottom:2),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(4),
                                                                ),
                                                                color: HexColor("#f2af29"),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    state_checker="update";
                                                                    state_update=true;
                                                                    eid=entryData.id;
                                                                    cid=widget.id;
                                                                    date_value=entryData.date;
                                                                    particular=entryData.particular;
                                                                    old_amount=entryData.amount;
                                                                    amount_value=entryData.amount;
                                                                    account_type=entryData.account_type;
                                                                    old_account=entryData.account_type;

                                                                    update_entry_bottomsheet.datecontroller.clear();
                                                                    update_entry_bottomsheet.amountcontroller.clear();
                                                                    update_entry_bottomsheet.particularcontroller.clear();
                                                                    update_entry_bottomsheet.accountcontroller.clear();

                                                                  });
                                                                },
                                                                child:Padding(
                                                                  padding: EdgeInsets.all(1),
                                                                  child:Icon(Icons.edit,color: Colors.white,size: 15,),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            );
                                          }
                                          else
                                          {
                                            return Container(
                                              color: Colors.white,
                                              child:Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children:<Widget>[
                                                    Text('No data found',style: TextStyle(color:HexColor("#c0c0c0"),fontSize: 16),),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    )
                                ),
                                SizedBox(height: 8,),
                                Divider(color: HexColor("#0c0c0c").withOpacity(0.3),height: 2,),
                                SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Total",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:  GetBuilder<getcontroller>(
                                          builder:(controller){
                                            return
                                              Text(
                                                "₹"+'${controller.total_debit}'+"Dr.",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                              );
                                          }
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:
                                      GetBuilder<getcontroller>(
                                          builder:(controller){
                                            return
                                              Text(
                                                "₹"+'${controller.total_credit}'+"Cr.",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                              );
                                          }
                                      ),

                                    )
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Closing Balance",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 14,fontFamily:'Montserrat_regular')),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:GetBuilder<getcontroller>(
                                          builder:(controller){
                                            return
                                              '${controller.account_type}'=='0'?
                                              Text(
                                                "₹"+'${controller.balance.toString()}',style: (TextStyle(color: HexColor("#f2af29"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                              ):
                                              '${controller.account_type}'=='Debit'?
                                              Text(
                                                "₹"+ '${controller.balance.toString()}',style: (TextStyle(color: HexColor("#F30808"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                              ):
                                              Text(
                                                "₹"+ '${controller.balance.toString()}',style: (TextStyle(color: HexColor("#71b340"),fontSize: 14,fontFamily:'Montserrat_bold')),
                                              );
                                          }
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  back_track() {
    if(widget.nav_screen=="due")
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          home()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
    }
  }
  
  void _displayBottomSheet()
  {
    showModalBottomSheet(context: context, enableDrag: true,builder: (BuildContext c){
      return Container(
        child:state_checker!="false"? state_checker=="Add"?
        entry_bottomsheet(
          close:(){
            //setState(() {
              state=false;
              state_checker="false";
              Navigator.pop(context);
           // });
          },
          submit:(){
            setState(() {
              data_details.clear();
              state=false;
              state_checker="false";
              date_value=entry_bottomsheet.to_date_value;
              amount_value=entry_bottomsheet.amount_controller.text.toString();
              account_type=entry_bottomsheet.account_controller.text.toString();

              // print(date_value);
              // print(amount_value);
              // print(particular);
              // print(account_type);
              if(update_entry_bottomsheet.particularcontroller.text=='Other')
              {
                if(entry_bottomsheet.other_controller.text.toString()=='')
                {
                  particular="No";
                }
                else
                {
                  particular=entry_bottomsheet.other_controller.text.toString();
                }
              }
              else
              {
                particular=entry_bottomsheet.particular_controller.text.toString();
              }
              _AddData();
              print(data_details);
            });
          },
        ):update_entry_bottomsheet(cid: cid,eid:eid,date:date_value,particular:particular,amount:amount_value,account_type: account_type,
          close:(){
            setState(() {
              state_update=false;
              state_checker="false";
            });
          },
          update:(){
            setState(() {
              data_details.clear();
              state_update=false;
              state_checker="false";
              date_value=update_entry_bottomsheet.datecontroller.text.toString();
              amount_value=update_entry_bottomsheet.amountcontroller.text.toString();
              account_type=update_entry_bottomsheet.accountcontroller.text.toString();

              if(update_entry_bottomsheet.particularcontroller.text=="Other")
              {
                if(update_entry_bottomsheet.othercontroller.text=='')
                {
                  particular="No";
                }
                else
                {
                  particular=update_entry_bottomsheet.othercontroller.text.toString();
                }
              }
              else
              {
                particular=update_entry_bottomsheet.particularcontroller.text.toString();
              }
              _UpdateData();
            });
          },
        ):null,
      );
    });
  }
}
