class clientlist{
  late String id,name,subtitle,amount,cat;
  clientlist(this.id, this.name, this.subtitle,this.amount,this.cat);


  clientlist.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    name=json['name'];
    subtitle=json['subtitle'];
    amount=json['amount'];
    cat=json['cat'];
  }

  Map<String,dynamic>? tojson()
  {
    final Map<String,dynamic> data=new Map<String,dynamic>();
    data['id']=this.id;
    data['name']=this.name;
    data['subtitle']=this.subtitle;
    data['amount']=this.amount;
    data['cat']=this.cat;
  }
}