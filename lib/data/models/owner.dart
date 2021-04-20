
import 'package:gerenciador_cartoes/data/models/debit.dart';

class Owner {

  int id;
  String name;
  Map<String,List<Debit>> debits;
  Map<String, double> totalDebits;

  Owner({this.id, this.name, this.debits, this.totalDebits});

  Map<String, dynamic> toMap(){
    Map<String, dynamic> owner = {
      "name" : name
    };
    return owner;
  }
  Owner.fromMap(Map map){
      this.id = map["id"];
      this.name = map["name"];
      this.debits = {};
      this.totalDebits = {};
  }
}