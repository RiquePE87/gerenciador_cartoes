import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';

class OwnerDetails extends StatelessWidget {
  final Owner owner;

  OwnerDetails(this.owner);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: owner.debits.length,
                  itemBuilder: (context, index) {
                    Debit d = owner.debits[index][0];
                    return Container(
                      child: Row(
                        children: [Text(d.description)],
                      ),
                    );
                  }),
            ),
          )
        ],
        title: Column(
          children: [Text(owner.name)],
        ));
  }
}
