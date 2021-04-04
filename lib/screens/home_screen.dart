import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/owner_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'components/card_credit_card.dart';
import 'dialogs/owner_dialog.dart';
import 'dialogs/credit_card_dialog.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade500,
      body: GetBuilder<ModelController>(
        builder: (value) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Obx(()=> Container(
                    child: value.isLoading.value
                        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),))
                        : ListView.builder(
                        itemCount: value.creditCards.length,
                        itemBuilder: (context, index) {
                          return CardCreditCard(value.creditCards[index]);
                        }),
                  ),
                  ),),
                Container(
                  height: 90,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            createMenuItem("Adicionar Devedor", Icons.person_add, ()=> Get.dialog(OwnerDialog())),
                            createMenuItem("Adicionar Cartão", Icons.credit_card, ()=> Get.dialog(CreditCardScreen())),
                            createMenuItem("Devedores", Icons.person, ()=> Get.dialog(OwnerScreen())),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  Widget createMenuItem(String description, IconData icon, Callback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 100,
        child: Container(
          color: Colors.purple.shade600,
          margin: const EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white,),
              Text(description, style: TextStyle(color: Colors.white),)
            ],

          ),
        ),
      ),
    );
  }
}

