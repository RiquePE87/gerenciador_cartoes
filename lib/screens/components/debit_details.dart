import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:get/get.dart';

class DebitDetails extends StatelessWidget {

  Debit debit;

  DebitDetails(this.debit);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value){
        return Card(
          child: Row(
            children: [
              Column(
                children: [
                  Text(debit.description),
                  Text("${debit.value.toStringAsFixed(2)} X ${debit.quota.toString()}")
                ],
              ),
              Column(
                children: [
                  ListView.builder(itemBuilder: (context, index){
                    List<Owner> owners = value.ownerList;
                  })
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
