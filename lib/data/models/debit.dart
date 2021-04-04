import 'owner.dart';

class Debit {
  int id;
  String description;
  double value;
  int quota;
  int creditCardId;
  DateTime purchaseDate;
  List<Owner> owners;

  Debit(
      {this.id,
      this.description,
      this.value,
      this.quota,
      this.creditCardId,
      this.purchaseDate,
      this.owners});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> debit = {
      "description": this.description,
      "value": this.value,
      "quota": this.quota,
      "creditCardId": this.creditCardId,
      "purchasedate": this.purchaseDate.toIso8601String()
    };
    return debit;
  }

  Debit.fromMap(Map map) {
    this.id = map["id"];
    this.description = map["description"];
    this.value = map["value"];
    this.quota = map["quota"];
    this.creditCardId = map["creditCardID"];
    this.purchaseDate = DateTime.parse(map["purchasedate"]);
    this.owners = [];
  }
}
