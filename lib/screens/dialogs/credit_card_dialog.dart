import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:get/get.dart';

import '../../main.dart';

class CreditCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border =
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)));

    return Dialog(
        child: GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (txt) => value.name = txt,
                decoration: InputDecoration(
                    isDense: true, hintText: "Nome do cartão", border: border),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onChanged: (txt) => value.payDay = txt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Dia do vencimento",
                    border: border),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onChanged: (txt) => value.limitCredit = txt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Limite do cartão R\$:",
                    border: border),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onChanged: (txt) => value.usedLimit = txt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Limite disponível R\$:",
                    border: border),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() => Text("${value.message}")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        value.insertCreditCard();
                        Get.back();
                      },
                      child: Text("Salvar")),
                  TextButton(
                      onPressed: () => Get.back(), child: Text("Cancelar"))
                ],
              )
            ],
          ),
        );
      },
    ));
  }
}
