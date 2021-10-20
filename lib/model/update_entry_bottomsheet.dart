import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/model/entry_bottomsheet.dart';
class update_entry_bottomsheet extends StatefulWidget {
  final VoidCallback close;
  final VoidCallback update;
  static TextEditingController amountcontroller=TextEditingController();
  static TextEditingController accountcontroller=TextEditingController();
  static TextEditingController datecontroller=TextEditingController();
  static TextEditingController particularcontroller=TextEditingController();
  static TextEditingController othercontroller=TextEditingController();
  //static var account_type_value='Debit';
 // static var particular_type_value='Income tax';
  final String cid;
  final String eid;
  final String date;
  final String particular;
  final String amount;
  final String account_type;


  const update_entry_bottomsheet({
    required this.close,
    required this.update,
    required this.cid,
    required this.eid,
    required this.date,
    required this.particular,
    required this.amount,
    required this.account_type,
    Key? key}) : super(key: key);

  @override
  _update_entry_bottomsheetState createState() => _update_entry_bottomsheetState();
}

class _update_entry_bottomsheetState extends State<update_entry_bottomsheet> {

  static final  List<String> listitem=<String>['Debit','Credit'];
  late String valuechoose;
  static List<String> listitem1=<String>['Income tax','Other'];
  static List<String> listitem2=<String>['Bank','Cash'];
  DateTime _dateTime=DateTime.now();
  late String valuechoose_select1;
  late List<String> listitem_select;
  bool check_visible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    update_entry_bottomsheet.datecontroller.text=widget.date;
    update_entry_bottomsheet.amountcontroller.text=widget.amount;
    update_entry_bottomsheet.accountcontroller.text=widget.account_type;
    update_entry_bottomsheet.particularcontroller.text=widget.particular;

    //setState(() {
      if(update_entry_bottomsheet.accountcontroller.text=="Debit")
      {
        valuechoose=listitem.first;
        listitem_select=<String>['Income tax','Other'];
        if(update_entry_bottomsheet.particularcontroller.text=="Income tax")
        {
          valuechoose_select1=listitem1.first;
          check_visible=false;
          update_entry_bottomsheet.particularcontroller.text=widget.particular;
        }
        else
        {
          valuechoose_select1=listitem1.last;
          check_visible=true;
          update_entry_bottomsheet.othercontroller.text=widget.particular;
          update_entry_bottomsheet.particularcontroller.text="Other";
        }
      }
      else
      {
        valuechoose=listitem.last;
        listitem_select=<String>['Bank','Cash'];
        if(update_entry_bottomsheet.particularcontroller.text.toString()=="Bank")
        {
          valuechoose_select1=listitem2.first;
          update_entry_bottomsheet.particularcontroller.text=widget.particular;
        }
        else
        {
          valuechoose_select1=listitem2.last;
          update_entry_bottomsheet.particularcontroller.text=widget.particular;
        }
      }
   // });
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
                "Update Entry",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
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
                                    update_entry_bottomsheet.datecontroller.text=_dateTime.year.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.day.toString();
                                  });
                                });
                                //_toDate(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.date_range,color: Colors.black38,),
                                  SizedBox(width:5),
                                  Text(
                                    update_entry_bottomsheet.datecontroller.text,style: (TextStyle(color: HexColor("#0c0c0c").withOpacity(0.4),fontSize: 14,fontFamily:'Montserrat_regular')),
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
                        child: TextField(controller:update_entry_bottomsheet.amountcontroller,
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
                            if(valuechoose=='Debit')
                            {
                              update_entry_bottomsheet.accountcontroller.text='Debit';
                              valuechoose_select1=listitem1.first;
                              update_entry_bottomsheet.particularcontroller.text=listitem1.first;
                              listitem_select=<String>['Income tax','Other'];
                            }
                            else
                            {
                              update_entry_bottomsheet.accountcontroller.text='Credit';
                              valuechoose_select1=listitem2.first;
                              update_entry_bottomsheet.particularcontroller.text=listitem2.first;
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
                        value: valuechoose_select1,
                        onChanged: (newvalue){
                          setState(() {
                            valuechoose_select1=newvalue as String;
                            if(newvalue=='Income tax')
                            {
                              update_entry_bottomsheet.particularcontroller.text='Income tax';
                              check_visible=false;
                            }
                            else if(newvalue=='Other')
                            {
                              update_entry_bottomsheet.particularcontroller.text='Other';
                              check_visible=true;
                            }
                            else if(newvalue=='Bank')
                            {
                              update_entry_bottomsheet.particularcontroller.text='Bank';
                              check_visible=false;
                            }
                            else
                            {
                              update_entry_bottomsheet.particularcontroller.text='Cash';
                              check_visible=false;
                            }
                          });
                        },
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        hint:Text(valuechoose_select1.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
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
              child: check_visible==true?
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1,color: HexColor("#0c0c0c")),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 44,
                child: TextField(controller:update_entry_bottomsheet.othercontroller,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ex:-Gst-june',
                      hintStyle: TextStyle(
                          color: Colors.black38,fontFamily:'Montserrat_regular'
                      )
                  ),
                ),
              ):Container(child: Row(children: [],),),
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
                        onPressed:
                        widget.update,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        color:HexColor("#f2af29"),
                        child: Text(
                          'UPDATE ENTRY',
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
  // check_data() {
  //   if(update_entry_bottomsheet.clientcontroller.text.toString()=='')
  //   {
  //     Fluttertoast.showToast(
  //         msg: "Please enter the client name",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.white,
  //         textColor: Colors.black,
  //         fontSize: 16.0
  //     );
  //   }
  //   else
  //   {
  //     widget.update();
  //   }
  // }
}
