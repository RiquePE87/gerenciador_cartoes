import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/credit_card.dart';
import 'package:get/get.dart';

class CreditCardDialog extends GetView<ModelController> {

  final CreditCard creditCard;

  CreditCardDialog({this.creditCard});

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border =
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)));

    return Dialog(
        child: Card(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: creditCard != null ? creditCard.name : "",
              onChanged: (txt) => creditCard != null ? creditCard.name = txt : controller.cc.name = txt,
              decoration: InputDecoration(
                  isDense: true, hintText: "Nome do cartão", border: border),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: creditCard != null ? creditCard.payDay.toString() : "",
              onChanged: (txt) => creditCard != null ? creditCard.payDay = int.tryParse(txt) : controller.cc.payDay = int.tryParse(txt),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true, hintText: "Dia do vencimento", border: border),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: creditCard != null ? creditCard.bestDay.toString() : "",
              onChanged: (txt) => creditCard != null ? creditCard.bestDay = int.tryParse(txt) : controller.cc.bestDay = int.tryParse(txt),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Melhor dia de Compra",
                  border: border),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: creditCard != null ? creditCard.limitCredit.toStringAsFixed(2) : "",
              onChanged: (txt) =>  creditCard != null ?  creditCard.limitCredit = double.tryParse(txt.replaceAll(RegExp("[^0-9]"), "")) / 100 :
              controller.cc.limitCredit =
                  double.tryParse(txt.replaceAll(RegExp("[^0-9]"), "")) / 100,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealInputFormatter(centavos: true, moeda: true)
              ],
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Limite do cartão R\$:",
                  border: border),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: creditCard != null ? creditCard.usedLimit.toStringAsFixed(2) : "",
              onChanged: (txt) => creditCard != null ? creditCard.usedLimit = double.tryParse(txt.replaceAll(RegExp("[^0-9]"), "")) / 100 :
              controller.cc.usedLimit =
                  double.tryParse(txt.replaceAll(RegExp("[^0-9]"), "")) / 100,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealInputFormatter(centavos: true)
              ],
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Limite disponível R\$:",
                  border: border),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() => Text("${controller.message}")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                       creditCard != null ? controller.updateCreditCard(creditCard) : controller.insertCreditCard();
                    },
                    child: Text("Salvar")),
                TextButton(onPressed: () => Get.back(), child: Text("Cancelar"))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
