import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'components/card_credit_card.dart';
import 'dialogs/owner_dialog.dart';
import 'dialogs/credit_card_dialog.dart';

class HomeScreen extends GetView<ModelController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Obx(
                  () => Container(
                    child: controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ))
                        : ListView.builder(
                            itemCount: controller.creditCards.length,
                            itemBuilder: (context, index) {
                              return Obx(() => CardCreditCard(
                                  controller.creditCards[index].obs));
                            }),
                  ),
                ),
              ),
              Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    createMenuItem("Adicionar Devedor", Icons.person_add,
                        () => Get.dialog(OwnerDialog())),
                    createMenuItem("Adicionar Cartão", Icons.credit_card,
                        () => Get.dialog(CreditCardDialog())),
                    createMenuItem("Devedores", Icons.person,
                        () => Get.toNamed(Routes.OWNER_SCREEN)),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget createMenuItem(String description, IconData icon, Callback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Container(
          color: Colors.green.shade50,
          margin: const EdgeInsets.only(left: 5, right: 5),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.green[900],
              ),
              Text(
                description,
                style: TextStyle(color: Colors.green[900]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
