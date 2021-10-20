import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/controller/entrycontroller.dart';
class entry_bottomsheet extends StatefulWidget {
  final VoidCallback close;
  final VoidCallback submit;
  static DateTime _datevalue=DateTime.now();
  static var to_date_value=_datevalue.year.toString()+"-"+_datevalue.month.toString()+"-"+_datevalue.day.toString();
  static TextEditingController particular_controller=TextEditingController();
  static TextEditingController amount_controller=TextEditingController();
  static TextEditingController other_controller=TextEditingController();
  static TextEditingController account_controller=TextEditingController();


  const entry_bottomsheet({
    required this.close,
    required this.submit,
    Key? key}) : super(key: key);

  @override
  _entry_bottomsheetState createState() => _entry_bottomsheetState();
}

class _entry_bottomsheetState extends State<entry_bottomsheet> {

  TextEditingController searchcontroller=TextEditingController();
  static final  List<String> listitem=<String>['Debit','Credit'];
  late String valuechoose;
  static List<String> listitem1=<String>['Income tax','Other'];
  static List<String> listitem2=<String>['Bank','Cash'];
  DateTime _dateTime=DateTime.now();
  late String valuechoose_select;
  final entrycontroller e = Get.put(entrycontroller());
  late List<String> listitem_select;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      valuechoose=listitem.first;
      valuechoose_select=listitem1.first;
      entry_bottomsheet.account_controller.text='Debit';
      entry_bottomsheet.particular_controller.text='Income tax';
      listitem_select=<String>['Income tax','Other'];
      e.update_visibile("false");
    });
  }
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
                child:SingleChildScrollView(
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
                          "Add New Entry",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                          padding: EdgeInsets.only(left:14,right:14),
                          child: Row(
                            children: [
                              Expanded(
                                flex:3,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 1,color: HexColor("#0c0c0c")),
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
                                              entry_bottomsheet.to_date_value=_dateTime.year.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.day.toString();
                                            });
                                          });
                                          //_toDate(context);
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
                              SizedBox(width: 15,),
                              Expanded(
                                flex:4,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 1.0, color:HexColor("#0c0c0c")),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 44,
                                  child: TextField(controller:entry_bottomsheet.amount_controller,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.money,
                                          color: Colors.black38,
                                        ),
                                        hintText: 'Enter Amount..',
                                        hintStyle: TextStyle(
                                            color: Colors.black38,fontFamily:'Montserrat'
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:13.0,right: 13.0),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(width:1,color:HexColor("0c0c0c")),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:DropdownButton(
                                      value: valuechoose,
                                      onChanged: (newvalue){
                                        setState(() {
                                          valuechoose=newvalue as String;
                                          print(valuechoose);
                                          if(valuechoose=='Debit')
                                          {

                                            entry_bottomsheet.account_controller.text="Debit";
                                            valuechoose_select=listitem1.first;
                                            entry_bottomsheet.particular_controller.text='Income tax';
                                            listitem_select=<String>['Income tax','Other'];
                                          }
                                          else
                                          {
                                            entry_bottomsheet.account_controller.text="Credit";
                                            valuechoose_select=listitem2.first;
                                            entry_bottomsheet.particular_controller.text='Bank';
                                            listitem_select=<String>['Bank','Cash'];
                                          }
                                        });
                                      },
                                      underline: SizedBox(),
                                      dropdownColor: Colors.white,
                                      hint:Text(valuechoose.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                                      items:listitem.map((valueitem) {
                                        return DropdownMenuItem(
                                            value: valueitem,
                                            child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                          ),
                          Expanded(
                                flex:4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:13.0,right: 13.0),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(width:1,color:HexColor("0c0c0c")),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:DropdownButton<String>(
                                      value: valuechoose_select,
                                      onChanged: (newvalue){
                                        setState(() {
                                          valuechoose_select=newvalue as String;
                                            if(newvalue=='Income tax')
                                            {
                                              //entry_bottomsheet.type_date_value1='Income tax';
                                              entry_bottomsheet.particular_controller.text='Income tax';
                                              e.update_visibile("false");
                                            }
                                            else if(newvalue=='Other')
                                            {
                                              //entry_bottomsheet.type_date_value1='Other';
                                              entry_bottomsheet.particular_controller.text='Other';
                                              e.update_visibile("true");
                                            }
                                            else if(newvalue=='Bank')
                                            {
                                              //entry_bottomsheet.type_date_value1='Bank';
                                              entry_bottomsheet.particular_controller.text='Bank';
                                              e.update_visibile("false");
                                            }
                                            else
                                            {
                                              //entry_bottomsheet.type_date_value1='Cash';
                                              entry_bottomsheet.particular_controller.text='Cash';
                                              e.update_visibile("false");
                                            }
                                        });
                                      },
                                      underline: SizedBox(),
                                      dropdownColor: Colors.white,
                                      hint:Text(valuechoose_select.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                                      items:listitem_select.map((valueitem) {
                                        return DropdownMenuItem(
                                            value: valueitem,
                                            child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left:13.0,right:13.0),
                        // child: check_visible==true?
                        // Container(
                        //     alignment: Alignment.centerLeft,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       border: Border.all(width: 1,color: HexColor("#0c0c0c")),
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     height: 44,
                        //     child: TextField(controller:entry_bottomsheet.other_controller,
                        //       keyboardType: TextInputType.text,
                        //       style: TextStyle(
                        //         color: Colors.black87,
                        //       ),
                        //       decoration: InputDecoration(
                        //           border: InputBorder.none,
                        //           hintText: 'ex:- Gst-june',
                        //           hintStyle: TextStyle(
                        //               color: Colors.black38,fontFamily:'Montserrat'
                        //           )
                        //       ),
                        //     ),
                        //   ):Container(child: Row(children: [],),),

                        child: GetBuilder<entrycontroller>(
                          builder:(controller){
                            return '${controller.check}'=="true"?
                               Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 1,color: HexColor("#0c0c0c")),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 44,
                                  child: TextField(controller:entry_bottomsheet.other_controller,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'ex:- Gst-june',
                                        hintStyle: TextStyle(
                                            color: Colors.black38,fontFamily:'Montserrat'
                                        )
                                    ),
                                  )
                              ):
                               Container(child: Row(children: [],),);
                          },
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
                                child:  FlatButton(
                                  padding: EdgeInsets.only(top: 12, bottom:12),
                                  onPressed:()
                                    {
                                      check_data();
                                    },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  color:HexColor("#f2af29"),
                                  child: Text(
                                    'ADD ENTRY',
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
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              );
  }
  check_data() {
    if(entry_bottomsheet.amount_controller.text.toString()=='')
    {
      Fluttertoast.showToast(
          msg: "Please enter the amount",
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
