import 'owner.dart';

class Debit {
  int id;
  String description;
  double value;
  int quota;
  int creditCardId;
  List<Owner> owners;

  Debit(
      {this.id,
      this.description,
      this.value,
      this.quota,
      this.creditCardId,
      this.owners});

  Map<String, dynamic> toMap(){

   return {
     //"id" : id,
     "description": description,
     "value" : value,
     "quota" : quota,
     "creditCardId" : creditCardId
   };
  }
  Debit fromMap(Map map){

    return Debit(
      id: map["id"],
      description: map["description"],
      value: map["value"],
      quota: map["quota"],
      creditCardId: map["creditCardID"],
      owners: []
    );
  }
}
