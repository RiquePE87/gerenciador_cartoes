import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:get/get.dart';

class OwnerSelectDialog extends GetView<ModelController> {
  final List<Owner> owners;
  final ModelController controller = Get.find<ModelController>();

  OwnerSelectDialog({this.owners});

  @override
  Widget build(BuildContext context) {
    if (owners != null) {
      owners.forEach((element) {
        controller.selectedOwners.add(element);
      });
    }

    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.ownerList.length,
                    itemBuilder: (context, index) {
                      Owner owner = controller.ownerList[index];
                      return Obx(() => GestureDetector(
                          onTap: () {
                            controller.selectOwners(owner);
                          },
                          child: setButtonState(controller.selectedOwners, owner)));
                    })),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      controller.selectedOwners.clear();
                      Get.back();
                    },
                    child: Text("OK"))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget setButtonState(List<Owner> owners, Owner owner) {
    if (owners.contains(owner)) {
      return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Colors.purple,
          border: Border.all(),
        ),
        child: Text(
          owner.name,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(),
        ),
        child: Text(
          owner.name,
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }
}
