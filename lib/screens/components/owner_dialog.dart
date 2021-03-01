import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:get/get.dart';

class OwnerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: GetBuilder<ModelController>(
          init: ModelController(),
          builder: (value){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (txt) => value.owner.name = txt,
                  decoration: InputDecoration(
                      hintText: "Nome",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)))
                  ),
                ),
                FlatButton(onPressed: (){
                  value.insertOwner();
                  Get.back();
                }, child: Text("Salvar")),
                FlatButton(onPressed: (){
                  Get.back();
                }, child: Text("Cancelar"))
              ],
            );
          },
        ),
      ),
    );
  }
}
