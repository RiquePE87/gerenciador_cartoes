import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_details.dart';
import 'package:get/get.dart';

class DebitListWidget extends GetView<ModelController> {
  final List<dynamic> debitList;

  DebitListWidget(this.debitList);

  @override
  Widget build(BuildContext context) {
    return GetX<ModelController>(
            initState: (_)=> controller.getDebitsByMonth(DateTime.now().month),
            builder: (_){
          return Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.transparent,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return  DebitDetails(debitList[index]);
                  },
                  itemCount: debitList != null ? debitList.length : 0),
            ),
          );
        }
    );
  }
}
