import 'package:flutter/material.dart';

import 'owner.dart';

class Debit{
  int id;
  String description;
  double value;
  int quota;
  int paiedQuotas;
  int creditCardId;
  DateTime createdAt;
  List<Owner> owners;

  Debit(
      {this.id,
      this.description,
      this.value,
      this.quota,
        this.paiedQuotas,
      this.creditCardId,
        this.createdAt,
      this.owners});

  Map<String, dynamic> toMap(){

   return {
     //"id" : id,
     "description": description,
     "value" : value,
     "quota" : quota,
     "paiedQuotas" : paiedQuotas,
     "creditCardId" : creditCardId,
     "createdAt": createdAt.toIso8601String()
   };
  }
  Debit fromMap(Map map){

    return Debit(
      id: map["id"],
      description: map["description"],
      value: map["value"],
      quota: map["quota"],
      paiedQuotas: map["paiedquotas"],
      creditCardId: map["creditCardID"],
      createdAt: DateTime.parse(map["createdAt"]),
      owners: []
    );
  }
}
