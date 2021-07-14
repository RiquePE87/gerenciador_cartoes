import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:get/get.dart';

import 'dialogs/owner_dialog.dart';

class OwnerScreen2 extends GetView<ModelController> {
  final PageController pageController =
      PageController(initialPage: DateTime.now().month - 1);
  @override
  Widget build(BuildContext context) {
    Owner owner;
    int month;
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
          child: PageView.builder(
              controller: pageController,
              itemCount: 12,
              itemBuilder: (context, months) {
                month = months;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () => Get.back())
                        ],
                      ),
                      Center(
                        child: Text(
                          MONTHS[month + 1],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.ownerList.length,
                          itemBuilder: (context, index) {
                            owner = controller.ownerList[index];
                            List<dynamic> cards = owner.debits.keys.toList();
                            return Card(
                              color: Colors.green[50],
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            owner.name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                          onPressed: () =>
                                              Get.dialog(OwnerDialog(
                                                owner: owner,
                                              ))),
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Get.defaultDialog(
                                                title: "Atenção",
                                                middleText:
                                                    "Deseja realmente excluir?",
                                                textConfirm: "Sim",
                                                onConfirm: () => controller
                                                    .deleteOwner(owner),
                                                textCancel: "Não",
                                                onCancel: () => Get.back());
                                          })
                                    ],
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: cards.length,
                                      itemBuilder: (context, card) {
                                        String cardName = cards[card];
                                        Map<String, dynamic> debits =
                                            owner.debits[cardName][month];
                                        double totalDebits =
                                            sumTotalDebit(debits["debits"]);
                                        return Column(
                                          children: [
                                            Text(
                                              cardName,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      debits["debits"].length,
                                                  itemBuilder:
                                                      (context, debit) {
                                                    Debit d =
                                                        debits["debits"][debit];
                                                    double total =
                                                        (d.value / d.quota) /
                                                            d.owners.length;
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4,
                                                              horizontal: 4),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(d.description),
                                                          Text(
                                                              "R\$:${(total.toStringAsFixed(2))}")
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "R\$:${totalDebits.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Total R\$:${controller.setCardsTotal(owner.debits, month).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                );
              })),
    );
  }

  double sumTotalDebit(List<Debit> list) {
    double total = 0;
    list.forEach((element) {
      total += (element.value / element.quota) / element.owners.length;
    });
    return total;
  }
}
