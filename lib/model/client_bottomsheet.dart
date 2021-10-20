import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class client_bottomsheet extends StatefulWidget {
  final VoidCallback close;
  final VoidCallback submit;
  static TextEditingController clientcontroller=TextEditingController();
  static TextEditingController subtitlecontroller=TextEditingController();

  client_bottomsheet
      ({
    required this.close,
    required this.submit,
    Key? key}) : super(key: key);

  @override
  _client_bottomsheetState createState() => _client_bottomsheetState();
}

class _client_bottomsheetState extends State<client_bottomsheet> {

  @override
  Widget build(BuildContext context) {
       return Container(
           decoration: BoxDecoration(
               color: HexColor("#ffffff"),
               borderRadius: BorderRadius.all(
                 Radius.circular(6),
               )
           ),
             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   Row(
                     children: [
                       Expanded(
                         flex: 1,
                         child: Center(child: Divider(color: HexColor("#0c0c0c"),height: 4,)),
                       )
                     ],
                   ),
                   SizedBox(height: 3,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: <Widget>[
                       RaisedButton(onPressed: widget.close,color: Colors.white,elevation: 0,
                         child: Icon(Icons.clear,color: Colors.black,),
                       ),
                     ],
                   ),
                   Center(
                     child: Text(
                       "Add New Client",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                     ),
                   ),
                   SizedBox(height: 20,),
                   Padding(
                     padding: const EdgeInsets.only(left:15.0,right:15.0),
                     child: Container(
                         alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           border: Border.all(width: 1.0, color:HexColor("#0c0c0c")),
                           borderRadius: BorderRadius.circular(5),
                         ),
                         height: 44,
                         child: TextField(controller:client_bottomsheet.clientcontroller,
                           keyboardType: TextInputType.text,
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
                   SizedBox(height: 10,),
                   Padding(
                     padding: const EdgeInsets.only(left:15.0,right:15.0),
                     child: Container(
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         border: Border.all(width: 1.0, color:HexColor("#0c0c0c")),
                         borderRadius: BorderRadius.circular(5),
                       ),
                       height: 44,
                       child: TextField(controller:client_bottomsheet.subtitlecontroller,
                         keyboardType: TextInputType.text,
                         style: TextStyle(
                           color: Colors.black87,
                         ),
                         decoration: InputDecoration(
                             border: InputBorder.none,
                             prefixIcon: Icon(
                               Icons.person,
                               color: Colors.black38,
                             ),
                             hintText: 'Enter the client subtitle..',
                             hintStyle: TextStyle(
                                 color: Colors.black38,fontFamily:'Montserrat'
                             )
                         ),
                       ),
                     ),
                   ),
                   SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.only(left:12.0,right:12.0),
                           child: Container(
                             child:  RaisedButton(
                               padding: EdgeInsets.only(top: 12, bottom:12),
                               onPressed:(){
                                 check_data();
                               },
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(6),
                               ),
                               color:HexColor("#f2af29"),
                               child: Text(
                                 'SAVE CLIENT',
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: 'Montserrat_regular'
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
       );
  }

check_data() {
  if(client_bottomsheet.clientcontroller.text.toString()=='')
  {
    Fluttertoast.showToast(
        msg: "Please enter the client name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
  else
  {
    widget.submit();
  }
}
}
