import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:get/get.dart';

class OwnerScreen2 extends GetView<ModelController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView.builder(
              itemCount: 12,
              itemBuilder: (_, month) {
                return ListView.builder(
                    itemCount: controller.ownerList.length,
                    itemBuilder: (context, index) {
                      Owner owner = controller.ownerList[index];
                      List<dynamic> cards = owner.debits.keys.toList();
                      return ListView.builder(itemBuilder: (_, card) {
                        Map<String, dynamic> debits =
                            owner.debits[index][month];
                        return Card();
                      });
                    });
              })),
    );
  }
}
