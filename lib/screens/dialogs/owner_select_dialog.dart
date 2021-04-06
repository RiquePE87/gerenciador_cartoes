import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:get/get.dart';

class OwnerSelectDialog extends GetView<ModelController> {
  final List<Owner> owners;
  OwnerSelectDialog({this.owners});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: GetX<ModelController>(
                  initState: (state) {
                    if (owners != null) {
                      owners.forEach((element) {
                        controller.selectedOwners.add(element);
                      });
                    }
                  },
                  builder: (_) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _.ownerList.length,
                        itemBuilder: (context, index) {
                          final Owner owner = _.ownerList[index];
                          return Obx(() => setButtonState(owner));
                        });
                  },
                )),
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

  Widget setButtonState(Owner owner) {
    if (controller.selectedOwners.contains(owner)) {
      return ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purple)),
          onPressed: () => controller.selectOwners(owner),
          child: Text("${owner.name}"));
    } else {
      return ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: () => controller.selectOwners(owner),
          child: Text(
            "${owner.name}",
            style: TextStyle(color: Colors.black),
          ));
    }
  }
}
