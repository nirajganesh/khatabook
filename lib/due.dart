import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/clientdetails.dart';
import 'package:khatabook/controller/duecontroller.dart';
import 'package:khatabook/model/due_clientlist.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'client.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  int current_index=0;
  final List<Widget>tabs=[
    Home(),
    //report(),
    client(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[current_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current_index,
        selectedItemColor:HexColor("#f2af29"),
        items: [
          BottomNavigationBarItem(
            icon:Icon(Icons.dashboard),
            title: Text("Due"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          // BottomNavigationBarItem(
          //   icon:Icon(Icons.report),
          //   title: Text("Report"),
          //   backgroundColor: Theme.of(context).primaryColor,
          // ),
          BottomNavigationBarItem(
            icon:Icon(Icons.list_alt_sharp),
            title: Text("Client"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        onTap: (index){
          setState(() {
            current_index=index;
          });
        },
      ),
    );
  }
}
class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map> myProducts =
  List.generate(4, (index) => {"id": index, "name": "Product $index"})
      .toList();
  List<due_clientlist> data_details=[];
  List<due_clientlist> member_list=[];
  List<due_clientlist> contain_filter=[];
  bool data_filter=false;
  TextEditingController searchcontroller=TextEditingController();
  final duecontroller c = Get.put(duecontroller());
  String nav_screen="due";



  Future _getData() async {
    var response = await http.post(Uri.parse("http://khatabook.nirajganesh.com/Due.php"));
    var data = jsonDecode(response.body);
    var dataarray=data['data'];
    data_details.clear();
    print(dataarray);
    for(var clientdata in dataarray)
    {
      due_clientlist listdata=due_clientlist(clientdata['id'],clientdata['name'],clientdata['subtitle'],clientdata['amount'],clientdata['cat'],clientdata['total_debit'],clientdata['total_credit']);
      data_details.add(listdata);
      c.update_debit(clientdata['total_debit']);
      c.update_credit(clientdata['total_credit']);
    }
    return data_details;
  }

  Future _getFilterData() async {
    var response = await http.post(Uri.parse("http://khatabook.nirajganesh.com/Due.php"));
    var data = jsonDecode(response.body);
    var dataarray=data['data'];
    data_details.clear();
    print(dataarray);
    for(var clientdata in dataarray)
    {
      due_clientlist listdata=due_clientlist(clientdata['id'],clientdata['name'],clientdata['subtitle'],clientdata['amount'],clientdata['cat'],clientdata['total_debit'],clientdata['total_credit']);
      data_details.add(listdata);
      c.update_debit(clientdata['total_debit']);
      c.update_credit(clientdata['total_credit']);
    }
    c.state_change=RxInt(0);
    return data_details;
  }

  filter_memberlist()
  {
    List<due_clientlist> _details=[];
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
       body: Container(
         child: Column(
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
                               "Amount Receivable",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 12,fontFamily:'Montserrat_regular')),
                             ),
                             Text(
                               "Advance Received",style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.3),fontSize: 12,fontFamily:'Montserrat_regular')),
                             ),
                           ],
                         ),
                         SizedBox(height: 8,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             GetBuilder<duecontroller>(
                                 builder:(controller){
                                   return
                                     Text(
                                       "₹"+'${controller.total_debit}',style: (TextStyle(color: HexColor("#F30808"),fontSize: 20,fontFamily:'Montserrat_bold')),
                                     );
                                 }
                             ),
                             GetBuilder<duecontroller>(
                                 builder:(controller){
                                   return
                                     Text(
                                       "₹"+'${controller.total_credit}',style: (TextStyle(color: HexColor("#71b340"),fontSize: 20,fontFamily:'Montserrat_bold')),
                                     );
                                 }
                             ),
                           ],
                         )
                       ],
                     ),
                   ),
                 ),
                 Expanded(
                   child:Container(
                   color: HexColor("#16697A").withOpacity(0.1),
                   child: Column(
                     children: [
                       SizedBox(height:10),
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
                                     return ListView.builder(itemCount: issearching==true?contain_filter.length:data_details.length,
                                         scrollDirection: Axis.vertical,
                                         shrinkWrap: true,
                                         itemBuilder: (context,index){
                                           due_clientlist member_data=issearching==true?contain_filter[index]:data_details[index];
                                           return Padding(
                                             padding: EdgeInsets.only(top: 0,bottom: 8,left:5,right: 5),
                                             child:GestureDetector(
                                               onTap: (){
                                                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                                                     clientdetails(clientname:member_data.name,amount:member_data.amount,id:member_data.id,account:member_data.cat,nav_screen:nav_screen)), (Route<dynamic> route) => false);
                                                 //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>clientdetails(clientname:member_data.name,amount:member_data.amount,id:member_data.id,account:member_data.cat)),);
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
                                                           member_data.cat=="Debit"?
                                                           Text(
                                                             "₹"+member_data.amount,style: (TextStyle(color: HexColor("#F30808"),fontSize: 18,fontFamily:'Montserrat_bold')),
                                                           ):
                                                           Text(
                                                             "₹"+member_data.amount,style: (TextStyle(color: HexColor("#71b340"),fontSize: 18,fontFamily:'Montserrat_bold')),
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
}

Future<void> _reload(var value) async {
  print(
      'Home Page resumed after popping/closing SecondPage with value {$value}. Do something.');
}
