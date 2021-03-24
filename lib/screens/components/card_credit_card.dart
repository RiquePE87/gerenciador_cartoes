import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/credit_card.dart';
import 'package:gerenciador_cartoes/screens/card_details_screen.dart';
import 'package:get/get.dart';

class CardCreditCard extends StatelessWidget {
  final CreditCard card;

  CardCreditCard(this.card);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetBuilder<ModelController>(
        init: ModelController(),
        builder: (value) {
          return GestureDetector(
            onTap: () {
              value.selectedCard = card;
              value.getDebits().whenComplete(() => Get.to(() => CardDetailsScreen(), preventDuplicates: true));
            },
            onLongPress: () {
              Get.defaultDialog(
                  title: "Atenção",
                  middleText: "Você deseja excluir o cartão?",
                  onConfirm: (){
                    value.deleteCreditCard(card);
                    Get.back(closeOverlays: true);
                  },
                  textConfirm: "Sim",
                  buttonColor: Colors.white,
                  onCancel: () => Get.back(),
                  textCancel: "Cancelar");
              //
            },
            child: Card(
              color: Colors.purple.shade400,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("Vencimento:",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text(card.payDay.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Disponivel:",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text("R\$: ${card.usedLimit.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text("Total:",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text("R\$: ${card.limitCredit.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
