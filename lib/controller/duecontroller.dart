import 'package:get/get.dart';

class duecontroller extends GetxController
{
  var state_change=0.obs;
  var total_debit='';
  var total_credit='';
  var refresh_data='';

  update_debit(String value)
  {
    total_debit=value;
    update();
  }
  update_credit(String value)
  {
    total_credit=value;
    update();
  }

  value_null()
  {
    total_debit='';
    total_credit='';
    update();
  }
  update_refresh()
  {
    refresh_data="Yes";
    update();
  }
}