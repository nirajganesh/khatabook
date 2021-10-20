import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
class update_client_bottomsheet extends StatefulWidget {
  final VoidCallback close;
  final VoidCallback update;
  static TextEditingController clientcontroller=TextEditingController();
  static TextEditingController subtitlecontroller=TextEditingController();
  final String clientname;
  final String subtitle;
  const update_client_bottomsheet({
    required this.close,
    required this.update,
    required this.clientname,
    required this.subtitle,
    Key? key}) : super(key: key);

  @override
  _update_client_bottomsheetState createState() => _update_client_bottomsheetState();
}

class _update_client_bottomsheetState extends State<update_client_bottomsheet> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    update_client_bottomsheet.clientcontroller.text=widget.clientname;
    update_client_bottomsheet.subtitlecontroller.text=widget.subtitle;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: HexColor("#ffffff"),
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
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
                "Update Client",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
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
                child: TextField(controller:update_client_bottomsheet.clientcontroller,
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
                child: TextField(controller:update_client_bottomsheet.subtitlecontroller,
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
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        child:  RaisedButton(
                          padding: EdgeInsets.only(top: 12, bottom:12),
                          onPressed: check_data,
                          //widget.update
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          color:HexColor("#f2af29"),
                          child: Text(
                            "UPDATE CLIENT",
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  check_data() {
    if(update_client_bottomsheet.clientcontroller.text.toString()=='')
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
        widget.update();
      }
  }
}
