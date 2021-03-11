import 'package:gerenciador_cartoes/models/debit.dart';

class CreditCard {
  int id;
  String name;
  int payDay;
  double usedLimit;
  double limitCredit;
  double total;

  CreditCard({this.id, this.name, this.payDay, this.usedLimit, this.limitCredit, this.total = 0});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "payday": payDay,
      "usedlimit": usedLimit,
      "limitcredit": limitCredit
    };
  }

  CreditCard fromMap(Map map) {
    return new CreditCard(
        id: map["id"],
        name: map["name"],
        payDay: map["payday"],
        usedLimit: map["usedlimit"],
        limitCredit: map["limitcredit"]);
  }
}
