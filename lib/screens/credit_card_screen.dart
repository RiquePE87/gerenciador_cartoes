import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:get/get.dart';

import '../main.dart';

class CreditCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border =
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)));

    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder(
            init: ModelController(),
              builder: (value) => IconButton(icon: Icon(Icons.save), onPressed: (){
                value.insertCreditCard();
                Get.back();
              }))
        ],
        title: const Text("Novo Cartão"),
      ),
      body: GetBuilder(
        init: ModelController(),
        builder: (value){
          return Center(
            child: Card(
              margin: const EdgeInsets.all(10),
              color: Colors.grey[100],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (txt) => value.name = txt,
                    decoration:
                    InputDecoration(
                        isDense: true,
                        hintText: "Nome do cartão", border: border),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    onChanged: (txt) => value.payDay = txt,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Dia do vencimento", border: border),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    onChanged: (txt) => value.limitCredit = txt,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Limite do cartão R\$:", border: border),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    onChanged: (txt) => value.usedLimit = txt,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Limite disponível R\$:", border: border),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
