import 'package:gerenciador_cartoes/models/debit.dart';

class Owner {
  int id;
  String name;
  List<Debit> debits;


  Owner({this.id, this.name});

  Map<String, dynamic> toMap(){
    return {
      "name" : name
    };
  }
  Owner fromMap(Map map){
    return new Owner(
      id: map["id"],
      name: map["name"]
    );
  }
}
