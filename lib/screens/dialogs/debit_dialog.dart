import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/dialogs/owner_select_dialog.dart';
import 'package:get/get.dart';

class DebitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border =
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)));

    return Dialog(
        child: GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
          color: Colors.grey[100],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (txt) => value.debit.value = double.tryParse(txt),
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Valor total R\$:",
                    border: border),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (txt) => value.debit.quota = int.tryParse(txt),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Número de parcelas",
                    border: border),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (txt) => value.debit.description = txt,
                decoration: InputDecoration(
                    isDense: true, hintText: "Descrição", border: border),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.black87,
                      ),
                      onPressed: () => Get.dialog(OwnerSelectDialog()))
                ],
              ),
              Obx(() => Text("${value.message}")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        value.insertDebit();
                        Get.back();
                      },
                      child: Text("Salvar")),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancelar")),
                ],
              )
            ],
          ),
        );
      },
    ));
  }
}
