import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/models/owner.dart';

class OwnerDetails extends StatelessWidget {
  final Owner owner;

  OwnerDetails(this.owner);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(title: Row(children: [
      Text(owner.name)
    ],));
  }
}
