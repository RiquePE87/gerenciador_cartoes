import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/card_credit_card.dart';
import 'package:gerenciador_cartoes/screens/components/owner_dialog.dart';
import 'package:gerenciador_cartoes/screens/credit_card_screen.dart';
import 'package:gerenciador_cartoes/screens/debit_dialog.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.purple.shade500,
        body: GetBuilder(
          init: ModelController(),
          builder: (value) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: value.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: value.creditCards.length,
                              itemBuilder: (context, index) {
                                return CardCreditCard(value.creditCards[index]);
                              }),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.person_add),
                                        onPressed: () {}),
                                    Text("Adicionar Devedor")
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.credit_card),
                                        onPressed: () {}),
                                    Text("Adicionar Devedor")
                                  ],
                                ),
                              )
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
