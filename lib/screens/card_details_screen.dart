import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_list_widget.dart';
import 'package:get/get.dart';

class CardDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ModelController>(
        builder: (value){
          return Container(
            child: Column(
              children: [
                DebitListWidget(value.debitsList)
              ],
            ),
          );
        },
      )
    );
  }
}
