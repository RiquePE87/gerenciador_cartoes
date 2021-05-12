import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_details.dart';
import 'package:get/get.dart';

class DebitListWidget extends GetView<ModelController> {
  final List<dynamic> debitList;

  DebitListWidget(this.debitList);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(()=>
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.transparent,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return !controller.isLoading.value ? DebitDetails(debitList[index]) : Center(child: CircularProgressIndicator());
                  },
                  itemCount: debitList != null ? debitList.length : 0),
            ),
        )
    );
  }
}
