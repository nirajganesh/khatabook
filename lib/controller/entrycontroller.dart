import 'package:get/get.dart';

class entrycontroller extends GetxController{
  var check="false";


  update_visibile(String value)
  {
    check=value;
    update();
  }
}