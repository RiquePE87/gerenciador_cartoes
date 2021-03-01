import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:get/get.dart';

class DebitListWidget extends StatelessWidget {
  final List<dynamic> debitList;

  DebitListWidget(this.debitList);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(builder: (value) {
      return Container(
        child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(value.debitsList[index].description),
                  Text(value.debitsList[index].quota.toString()),
                  Text(value.debitsList[index].value.toString()),
                ],
              );
            },
            itemCount: value.debitsList.length),
      );
    });
  }
}
