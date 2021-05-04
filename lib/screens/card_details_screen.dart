import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_list_widget.dart';
import 'package:gerenciador_cartoes/screens/dialogs/credit_card_dialog.dart';
import 'package:gerenciador_cartoes/screens/dialogs/debit_dialog.dart';
import 'package:get/get.dart';

class CardDetailsScreen extends GetView<ModelController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.purple,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.all(5),
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Card(
                  color: Colors.purple.shade600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Get.back(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(()=> Text(controller.selectedCard.value.name,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400))),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(()=> Text(
                              "Total R\$:${controller.selectedCard.value.getTotal.toStringAsFixed(2)}",
                              style: TextStyle(color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.add_business_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //value.selectedCard = cc;
                                Get.dialog(DebitDialog());
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //value.selectedCard = cc;
                                Get.dialog(CreditCardScreen(creditCard: controller.selectedCard.value,));
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              DebitListWidget(controller.debitsList)
            ],
          ),
        ),
      ),
    );
  }
}
