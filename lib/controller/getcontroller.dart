import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class getcontroller extends GetxController{
  var count = 'to'.obs;
  var from='from'.obs;
  var state_change=0.obs;
  var total_debit='';
  var total_credit='';
  var balance=0;
  var account_type='';
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
    balance=0;
    update();
  }

  account_details()
  {
    if(int.parse(total_debit)>int.parse(total_credit))
      {
          balance=int.parse(total_debit)-int.parse(total_credit);
          account_type='Debit';
          update();
      }
    else if(int.parse(total_debit)<int.parse(total_credit))
      {
        balance=int.parse(total_credit)-int.parse(total_debit);
        account_type='Credit';
        update();
      }
    else
      {
        balance=int.parse(total_debit)-int.parse(total_credit);
        account_type='0';
        update();
      }
  }

}