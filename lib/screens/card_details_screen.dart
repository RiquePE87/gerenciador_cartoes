import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/screens/components/debit_list_widget.dart';
import 'package:gerenciador_cartoes/screens/dialogs/credit_card_dialog.dart';
import 'package:gerenciador_cartoes/screens/dialogs/debit_dialog.dart';
import 'package:get/get.dart';

class CardDetailsScreen extends GetView<ModelController> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 1);

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
                          Obx(() => Text(controller.selectedCard.value.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400))),
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
                child: Obx(()=> PageView(
                    controller: pageController,
                    onPageChanged: (page)=> controller.page.value = page,
                    children: controller.monthlyDebits.map((element) {
                      int lastMonth = element["month"]+1;
                      int firstMonth = element["month"]-1;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                MONTHS.length > firstMonth && MONTHS[firstMonth] != "Nulo" ? MONTHS[firstMonth] : "",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                MONTHS[element["month"]],
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                lastMonth < MONTHS.length ? MONTHS[lastMonth] : "",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                          Text(
                              "Total R\$:${element["total"].toStringAsFixed(2)}",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          DebitListWidget(element["debits"])
                        ],
                      );
                    }).toList()),)
              )
            ],
          ),
        ),
      ),
    );
  }
}
