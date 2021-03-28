import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_list_widget.dart';
import 'package:gerenciador_cartoes/screens/dialogs/debit_dialog.dart';
import 'package:get/get.dart';

class CardDetailsScreen extends StatelessWidget {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value) {
        name = value.cc.name;
        return SafeArea(
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
                            Text(value.selectedCard.value.name,
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(()=> Text(
                                "Total R\$:${value.selectedCard.value.getTotal.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white)))
                          ],
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.add_business_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              //value.selectedCard = cc;
                              Get.dialog(DebitDialog());
                            })
                      ],
                    ),
                  ),
                ),
                DebitListWidget(value.debitsList)
              ],
            ),
          ),
        );
      },
    ));
  }
}
