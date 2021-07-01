import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:get/get.dart';

class OwnerScreen2 extends GetView<ModelController> {
  PageController pageController =
      PageController(initialPage: DateTime.now().month - 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
          child: PageView.builder(
              controller: pageController,
              itemCount: 12,
              itemBuilder: (context, month) {
                return Column(
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
                          Owner owner = controller.ownerList[index];
                          double ownerTotal = 0;
                          List<dynamic> cards = owner.debits.keys.toList();
                          return Card(
                            child: Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: cards.length,
                                    itemBuilder: (context, card) {
                                      String cardName = cards[card];
                                      Map<String, dynamic> debits =
                                          owner.debits[cardName][month];
                                      double totalDebits =
                                          sumTotalDebit(debits["debits"]);
                                      ownerTotal += totalDebits;
                                      return Column(
                                        children: [
                                          Text(owner.name),
                                          Text(cardName),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    debits["debits"].length,
                                                itemBuilder: (context, debit) {
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
                                                "Total R\$:${totalDebits.toStringAsFixed(2)}",
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
                                      "Total R\$:${ownerTotal.toStringAsFixed(2)}",
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

double sumOwnerTotal(double total) {
  double t = 0;
}
