import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:get/get.dart';

class OwnerDialog extends StatelessWidget {

  final Owner owner;

  OwnerDialog({this.owner});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: GetBuilder<ModelController>(
          init: ModelController(),
          builder: (value) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: owner != null ? owner.name : "",
                  onChanged: (txt) => owner != null ? owner.name = txt : value.owner.name = txt,
                  decoration: InputDecoration(
                      hintText: "Nome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                ),
                Obx(() => Text("${value.message}")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (owner == null)
                          value.insertOwner();
                          else value.updateOwner(owner);
                        },
                        child: Text("Salvar")),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Cancelar"))
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
