import 'package:flutter/material.dart';

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
    return {
      //"id" : id,
      "description": description,
      "value": value,
      "quota": quota,
      "creditCardId": creditCardId,
      "purchasedate": purchaseDate.toIso8601String()
    };
  }

  Debit fromMap(Map map) {
    return Debit(
        id: map["id"],
        description: map["description"],
        value: map["value"],
        quota: map["quota"],
        creditCardId: map["creditCardID"],
        purchaseDate: DateTime.parse(map["purchasedate"]),
        owners: []);
  }
}
