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
          builder: (value) {
            name = value.cc.name;
            return Container(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 200,
                    padding: EdgeInsets.all(5),
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [Text(value.selectedCard.name),
                          Text("Total R\$:${value.selectedCard.total.toStringAsFixed(2)}")],
                      ),
                    ),
                  ),
                  DebitListWidget(value.debitsList)
                ],
              ),
            );
          },
        ));
  }
}
