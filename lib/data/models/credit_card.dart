import 'package:gerenciador_cartoes/data/models/debit.dart';

class CreditCard {
  int id;
  String name;
  int payDay;
  int bestDay;
  double usedLimit;
  double limitCredit;
  double total;
  List<Map<String, dynamic>> monthDebits;

  CreditCard(
      {this.id,
      this.name,
      this.payDay,
      this.bestDay,
      this.usedLimit,
      this.limitCredit,
      this.total = 0,
      this.monthDebits});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> creditCard = {
      "name": name,
      "payday": payDay,
      "bestday": bestDay,
      "usedlimit": usedLimit,
      "limitcredit": limitCredit
    };

    return creditCard;
  }

  CreditCard.fromMap(Map map) {
    this.id = map["id"];
    this.name = map["name"];
    this.payDay = map["payday"];
    this.bestDay = map["bestday"];
    this.usedLimit = map["usedlimit"];
    this.limitCredit = map["limitcredit"];
  }

  double getTotal(int month) {
    List<Debit> debits = [];
    monthDebits.forEach((element) {
      if (element["month"].month == month) {
        debits.addAll(element["debits"]);
      }
    });
    this.total = 0.0;
    if (debits != null)
      debits.forEach((element) {
        total += (element.value / element.quota);
      });
    return total;
  }
}
