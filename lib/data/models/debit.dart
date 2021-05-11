import 'owner.dart';

class Debit {
  int id;
  String description;
  double value;
  int quota;
  int creditCardId;
  DateTime purchaseDate;
  List<Owner> owners;
  int payedQuotas;
  int bestDay;
  List<int> months;

  Debit(
      {this.id,
      this.description,
      this.value,
      this.quota,
      this.creditCardId,
      this.purchaseDate,
      this.owners,
      this.payedQuotas,
      this.bestDay,
      this.months});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> debit = {
      "description": this.description,
      "value": this.value,
      "quota": this.quota,
      "creditCardId": this.creditCardId,
      "purchasedate": this.purchaseDate.toIso8601String(),
      "bestday" : this.bestDay
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
    this.bestDay = map["bestday"];
    this.owners = [];
    this.payedQuotas = setPayedQuotas();
    this.months = setMonths();
  }

  int setPayedQuotas(){
    DateTime today = DateTime.now();
    int remainingQuotas;
    if (purchaseDate.day < bestDay){
      remainingQuotas = today.month - purchaseDate.month;
    }else{
      remainingQuotas = (today.month - purchaseDate.month) + 1;
    }
    return remainingQuotas;
  }
  
  List<int> setMonths(){
    List<int> list = [];
    DateTime nextMonth = purchaseDate;

    if (purchaseDate.day < bestDay){
      list.add(purchaseDate.month);
      for(int i = 1; i < quota; i++){
        nextMonth = nextMonth.add(Duration(days: 30));
        list.add(nextMonth.month);
      }
    }else{
      for(int i = 1; i <= quota; i++){
        nextMonth = nextMonth.add(Duration(days: 30));
        list.add(nextMonth.month);
      }
    }
    return list;
  }
}
