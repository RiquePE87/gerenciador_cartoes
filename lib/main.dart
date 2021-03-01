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
        primaryColor: Colors.purple
      ),
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(icon: Icon(Icons.person), onPressed: ()=> Get.dialog(OwnerDialog()))
          ],
          title: Text('Gerenciador de Cartões'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.credit_card),
          onPressed: () => Get.to(() => CreditCardScreen()),
        ),
        body: Center(
            child: GetBuilder(
          init: ModelController(),
          builder: (value) {
            return Container(
              child: value.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: value.creditCards.length,
                      itemBuilder: (context, index) {
                        return CardCreditCard(value.creditCards[index]);
                      }),
            );
          },
        )),
      ),
    );
  }
}
