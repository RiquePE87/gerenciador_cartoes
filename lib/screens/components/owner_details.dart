import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/screens/dialogs/owner_dialog.dart';
import 'package:get/get.dart';

class OwnerDetails extends GetView<ModelController> {
  final Owner owner;

  OwnerDetails(this.owner);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down_circle_rounded,
          color: Colors.white,
        ),
        childrenPadding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
        children: [
          ListView(
            shrinkWrap: true,
            children: createList2(owner.debits),
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
              createTotalText(owner)
            ],
          ),
        )));
  }

  Widget createTotalText(Owner owner) {
    Widget text;
    Map<String, double> debits = owner.totalDebits;
    double total = 0;

    debits.values.forEach((element) {
      total += element;
    });

    return owner.totalDebits.length != 0
        ? Text("R\$:${total.toStringAsFixed(2)}")
        : Container();
  }

  List<Widget> createList2(Map<String, List<Debit>> map) {
    List<Widget> widgets = [];

    map.keys.forEach((card) {
      double tot = 0;
      List<Debit> debits = map[card];
      debits.forEach((element) {
        double total = (element.value / element.quota) / element.owners.length;
        tot += total;
        widgets.add(Container(
          color: Colors.purple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(element.description,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              Text("R\$: ${total.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white))
            ],
          ),
        ));
      });
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Total $card R\$: ${tot.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white))
          ],
        ),
      ));
    });
    return widgets;
  }
}
