import 'package:gerenciador_cartoes/models/debit.dart';

class CreditCard {
  int id;
  String name;
  int payDay;
  double usedLimit;
  double limitCredit;
  double total;
  List<Debit> debits;

  CreditCard({this.id, this.name, this.payDay, this.usedLimit, this.limitCredit, this.total = 0, this.debits});

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

  double get getTotal{
    this.total = 0.0;
    if (debits != null)
    debits.forEach((element) {
      total += (element.value / element.quota);
    });
    return total;
  }
}
