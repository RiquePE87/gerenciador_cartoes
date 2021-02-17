import 'package:gerenciador_cartoes/models/debit.dart';

class CreditCard {
  int id;
  String name;
  DateTime payDate;
  double limit;
  List<Debit> debitList;

  CreditCard({this.id, this.name, this.payDate, this.limit});
}
