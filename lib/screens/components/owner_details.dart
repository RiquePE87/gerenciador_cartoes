import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:get/get.dart';

class OwnerDetails extends StatelessWidget {
  final Owner owner;

  OwnerDetails(this.owner);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (value){
      return ExpansionTile(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: owner.debits.length != null ? owner.debits.length : 0,
                    itemBuilder: (context, index) {
                      Debit d = owner.debits[index][0];
                      return owner.debits.length != null ? Container(
                        child: Row(
                          children: [Text(d.description)],
                        ),
                      ) : Center(child: CircularProgressIndicator(),);
                    }),
              ),
            )
          ],
          title: Column(
            children: [Text(owner.name)],
          ));
    });
  }
}
