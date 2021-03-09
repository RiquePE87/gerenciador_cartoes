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
        return Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Card(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(debit.description),
                    Text("${debit.value.toStringAsFixed(2)} X ${debit.quota.toString()}")
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(

                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
