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
                       final Owner owner = controller.ownerList[index];
                      return GetX<ModelController>(
                        initState: (state){
                          if (owners != null) {
                            owners.forEach((element) {
                              controller.selectOwners(element);
                            });
                          }
                        },
                          builder: (controller){
                        return controller.selectedOwners.length > 0 ? setButtonState(owner) :
                        Center(child: CircularProgressIndicator(),);
                      });
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

  Widget setButtonState(Owner owner) {
    if (controller.selectedOwners.contains(owner)) {
      return ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purple)
          ),
          onPressed: () => controller.selectOwners(owner),
          child: Text("${owner.name}"));
    } else {
      return ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)
          ),
          onPressed: () => controller.selectOwners(owner),
          child: Text("${owner.name}", style: TextStyle(color: Colors.black),));
    }
  }
}
