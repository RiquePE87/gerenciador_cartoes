import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/screens/dialogs/debit_dialog.dart';
import 'package:get/get.dart';

class DebitDetails extends GetView<ModelController> {
  final Debit debit;
  DebitDetails(this.debit);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 5, 4, 0),
        child: Card(
          color: Colors.green.shade50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debit.description,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[900]),
                      ),
                      Text(
                        "R\$: ${debit.value.toStringAsFixed(2)} X ${debit.quota.toString()} = R\$: ${(debit.value / debit.quota).toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.green[900]),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        child: ListView.builder(
                            itemCount: debit.owners.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.green[900])),
                                  child: Text(
                                    debit.owners[index].name,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.green[900]),
                                  ));
                            }),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.green[900],
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                        title: "Atenção!",
                        middleText: "Você deseja realmente excluir?",
                        textCancel: "Não",
                        onCancel: () => Get.back(),
                        textConfirm: "Sim",
                        onConfirm: () => controller
                            .deleteDebit(debit)
                            .whenComplete(() => Get.back()));
                  }),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green[900],
                  ),
                  onPressed: () {
                    Get.dialog(DebitDialog(
                      debit: debit,
                    ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
