import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/screens/components/debit_details.dart';
import 'package:get/get.dart';

class DebitListWidget extends StatelessWidget {
  final List<dynamic> debitList;

  DebitListWidget(this.debitList);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(builder: (value) {
      return Expanded(
        child: Container(
          child: ListView.builder(
              itemBuilder: (context, index) {
                return !value.isLoading ? DebitDetails(debitList[index]) : Center(child: CircularProgressIndicator());
              },
              itemCount: debitList.length != null ? debitList.length : 0),
        ),
      );
    });
  }
}
