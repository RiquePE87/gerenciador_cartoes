import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_list_widget.dart';
import 'package:get/get.dart';

class CardDetailsScreen extends StatelessWidget {

  String name = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cartão"),
      ),
      body: GetBuilder<ModelController>(
        builder: (value){
          name = value.cc.name;
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
