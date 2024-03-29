import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/credit_card.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/screens/components/debit_list_widget.dart';
import 'package:gerenciador_cartoes/screens/dialogs/credit_card_dialog.dart';
import 'package:gerenciador_cartoes/screens/dialogs/debit_dialog.dart';
import 'package:get/get.dart';

class CardDetailsScreen extends GetView<ModelController> {
  //final Rx<CreditCard> card;
  //CardDetailsScreen({this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade500,
      body: SafeArea(
        child: Container(
          color: Colors.green.shade500,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.all(5),
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Card(
                  color: Colors.green.shade400,
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
                          Text(controller.selectedCard.value.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 5,
                          ),
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
                                Get.dialog(DebitDialog());
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.dialog(CreditCardDialog(
                                  creditCard: controller.selectedCard.value,
                                ));
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Obx(
                    () => PageView.builder(
                        pageSnapping: true,
                        controller: controller.pageController.value,
                        itemCount: controller.selectedCard.value.monthDebits.length,
                        itemBuilder: (_, position) {
                          Map<String, dynamic> element =
                              controller.selectedCard.value.monthDebits[position];
                          int lastMonth = element["month"].month + 1;
                          int firstMonth = element["month"].month - 1;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    MONTHS.length >= firstMonth &&
                                            MONTHS[firstMonth] != "Nulo"
                                        ? MONTHS[firstMonth]
                                        : "${DateTime.now().year - 1}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    MONTHS[element["month"].month],
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    lastMonth < MONTHS.length
                                        ? MONTHS[lastMonth]
                                        : "",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                              Text(
                                  "Total R\$:${element["total"].toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              DebitListWidget(element["debits"]),
                            ],
                          );
                        }),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
