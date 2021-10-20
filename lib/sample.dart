import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/controller/getcontroller.dart';
class sample extends StatefulWidget {
  const sample({Key? key}) : super(key: key);

  @override
  _sampleState createState() => _sampleState();
}

class _sampleState extends State<sample> {
  final getcontroller c = Get.put(getcontroller());
  final getcontroller c1 = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:GetBuilder<getcontroller>(
          builder:(controller){
            return
              Text(
                '${controller.balance}',style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14,fontFamily:'Montserrat_bold')),
              );
          }
      ),),
      body: GestureDetector(onTap:(){
         // c.update_debit(5);
      },child: Text("Update")),
    );
  }
}
