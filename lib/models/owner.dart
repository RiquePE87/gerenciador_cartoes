import 'package:gerenciador_cartoes/models/debit.dart';

class Owner {
  int id;
  String name;
  List<Debit> debitsList;

  Owner({this.id, this.name});
}
