import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/screens/dialogs/owner_dialog.dart';
import 'package:get/get.dart';

class OwnerDetails extends GetView<ModelController> {
  final Owner owner;

  OwnerDetails(this.owner);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  owner.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (_, index) {
                owner.debits;
                return Column(
                  children: [
                    Text("Card"),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (_, index) {
                          return Text("Teste");
                        }),
                    Text("Total"),
                  ],
                );
              })
          //createList2(owner.debits)
        ],
      ),
    );
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

  Widget createList2(Map<String, dynamic> map) {
    PageController pageController = PageController();
    Widget widget;
    widget = Expanded(
      flex: 1,
      child: PageView.builder(
          controller: pageController,
          itemCount: 3,
          itemBuilder: (_, position) {
            //Map element = card.value[position];
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("HHJHJ")],
            );
          }),
    );
    map.entries.forEach((card) {});
    return widget;
  }

  // Widget createPage(Map<String, dynamic> map) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Container(
  //         color: Colors.purple,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(element.description,
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.white)),
  //             Text("R\$: ${total.toStringAsFixed(2)}",
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.white))
  //           ],
  //         ),
  //       ),
  //       Padding(
  //       padding: const EdgeInsets.only(bottom: 10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Text("Total $card R\$: ${tot.toStringAsFixed(2)}",
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w700,
  //                   color: Colors.white))
  //         ],
  //       ),
  //     )
  //       ],
  //     ),
  //   );
  // }
}
