class due_clientlist
{
  late String id,name,subtitle,amount,cat,total_debit,total_credit;
  due_clientlist(this.id, this.name, this.subtitle,this.amount,this.cat,this.total_debit,this.total_credit);


  due_clientlist.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    name=json['name'];
    subtitle=json['subtitle'];
    amount=json['amount'];
    cat=json['cat'];
    total_debit=json['total_debit'];
    total_credit=json['total_credit'];
  }

  Map<String,dynamic>? tojson()
  {
    final Map<String,dynamic> data=new Map<String,dynamic>();
    data['id']=this.id;
    data['name']=this.name;
    data['subtitle']=this.subtitle;
    data['amount']=this.amount;
    data['cat']=this.cat;
    data['total_debit']=this.total_debit;
    data['total_credit']=this.total_credit;
  }
}