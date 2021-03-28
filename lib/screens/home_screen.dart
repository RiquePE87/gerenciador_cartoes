import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/owner_screen.dart';
import 'package:get/get.dart';

import 'components/card_credit_card.dart';
import 'dialogs/owner_dialog.dart';
import 'dialogs/credit_card_dialog.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          backgroundColor: Colors.purple.shade500,
          primaryColor: Colors.purple,
          iconTheme: IconThemeData(color: Colors.white)),
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.purple.shade500,
        body: GetBuilder<ModelController>(
          init: ModelController(),
          builder: (value) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(()=> Container(
                      child: value.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                          itemCount: value.creditCards.length,
                          itemBuilder: (context, index) {
                            return CardCreditCard(value.creditCards[index]);
                          }),
                    ),
                    ),),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.purple.shade600,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.person_add),
                                          onPressed: () {
                                            Get.dialog(OwnerDialog());
                                          }),
                                      Text(
                                        "Adicionar Devedor",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.purple.shade600,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.credit_card),
                                          onPressed: () {
                                            Get.dialog(CreditCardScreen());
                                          }),
                                      Text("Adicionar Cartão",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.purple.shade600,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.person),
                                          onPressed: () {
                                            Get.to(() => OwnerScreen());
                                          }),
                                      Text("Devedores",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.purple.shade600,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.person_add),
                                          onPressed: () {}),
                                      Text("Adicionar Devedor",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
