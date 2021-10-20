class entrylist
{
  late String id,cid,date,particular,account_type,total_debit,total_credit,amount;
  entrylist(this.id, this.cid, this.date, this.particular, this.amount,
      this.account_type,this.total_debit,this.total_credit);

  entrylist.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    cid=json['cid'];
    date=json['date'];
    amount=json['amount'];
    account_type=json['account_type'];
    total_debit=json['total_debit'];
    total_credit=json['total_credit'];
  }

  Map<String,dynamic>? tojson()
  {
    final Map<String,dynamic> data=new Map<String,dynamic>();
    data['id']=this.id;
    data['cid']=this.cid;
    data['date']=this.date;
    data['amount']=this.amount;
    data['account_type']=this.account_type;
    data['total_debit']=this.total_debit;
    data['account_credit']=this.total_credit;
  }
}
