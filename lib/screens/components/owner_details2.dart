import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OwnerDetails2 extends GetView<ModelController> {
  final Owner owner;

  OwnerDetails2(this.owner);

  @override
  Widget build(BuildContext context) {
    List<dynamic> cards = owner.debits.values;

    return PageView(
      children: [],
    );
  }
}
