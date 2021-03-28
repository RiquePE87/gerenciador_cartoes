import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:get/get.dart';

class OwnerSelectDialog extends StatelessWidget {

  final List<Owner> owners;

  OwnerSelectDialog(this.owners);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value) {
        if (owners != null){
          value.selectedOwners.assignAll(owners);
        }
        return Dialog(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: value.ownerList.length,
                      itemBuilder: (context, index) {
                        Owner owner = value.ownerList[index];
                        return GestureDetector(
                          onTap: () => value.selectOwners(owner),
                          child: Obx(()=> Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  color: value.selectedOwners.contains(owner)
                                      ? Colors.purple
                                      : Colors.transparent,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(owner.name)),)
                        );
                      }),
                ),
                Row(
                  children: [
                    TextButton(onPressed: (){Get.back();}, child: Text("OK"))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
