import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/screens/dialogs/owner_dialog.dart';
import 'package:get/get.dart';

class OwnerDetails extends GetView<ModelController> {
  final Owner owner;
  double totalDebits = 0.0;

  OwnerDetails(this.owner);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        childrenPadding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
        children: [
          ListView(
            shrinkWrap: true,
            children: createList(owner.debits),
          )
        ],
        title: Card(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    owner.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      onPressed: () => Get.dialog(OwnerDialog(
                            owner: owner,
                          ))),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Atenção",
                            middleText: "Deseja realmente excluir?",
                            textConfirm: "Sim",
                            onConfirm: () => controller.deleteOwner(owner),
                            textCancel: "Não",
                            onCancel: () => Get.back());
                      })
                ],
              ),
               owner.totalDebits.length != 0 ? Text("R\$:${owner.totalDebits["ghjhhhb"].toStringAsFixed(2)}") : Container(),
            ],
          ),
        )));
  }

  List<Widget> createList(Map<String, List<Debit>> map) {
    List<Widget> widgets = [];
    if (map != null) {
      map.forEach((key, value) {
        value.forEach((element) {
          double total =
              (element.value / element.quota) / element.owners.length;
          totalDebits += total;
          widgets.add(Container(
            color: Colors.purple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(key,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                Text(element.description,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                Text(total.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white))
              ],
            ),
          ));
        });
      });
    }

    return widgets;
  }
}
